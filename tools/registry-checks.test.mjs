import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {spawnSync,execFileSync} from 'node:child_process';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
function fixture(t){const dir=fs.mkdtempSync(path.join(os.tmpdir(),'vibe-checks-'));t.after(()=>fs.rmSync(dir,{recursive:true,force:true}));return dir;}
function run(script,dir,env={}){return spawnSync('/bin/bash',[path.resolve(root,script),dir],{encoding:'utf8',env:{...process.env,...env}});}
function output(result){return result.stdout+result.stderr;}
function starter(dir,version){
 const base=path.join(dir,'contracts/openapi');fs.mkdirSync(path.join(base,'modules'),{recursive:true});fs.mkdirSync(path.join(base,'components'));
 fs.writeFileSync(path.join(base,'openapi.root.yaml'),`openapi: ${version}\npaths:\n`+['openapi.json','openapi.yaml','endpoints','testing/postman'].map(p=>`  /api/v1/docs/${p}: {}`).join('\n')+'\n');
 fs.writeFileSync(path.join(base,'endpoints.inventory.tsv'),'# method\tpath\tmodule\toperation_id\nGET\t/example\texample\treadExample\n');
 fs.writeFileSync(path.join(base,'modules/example.yaml'),'operationId: readExample\nsummary: Read example\nresponses: {}\n');
 return path.join(base,'openapi.root.yaml');
}
test('starter accepts OpenAPI 3.1/3.2 and does not require custom response headers',t=>{
 const dir=fixture(t),file=starter(dir,'3.1.1');
 for(const version of ['3.1.1','"3.1.2"',"'3.2.0'",'3.2.1 # tool-supported version']){
  fs.writeFileSync(file,fs.readFileSync(file,'utf8').replace(/^openapi:.*$/m,'openapi: '+version));
  const result=run('registry/checks/check_openapi.sh',dir);assert.equal(result.status,0,output(result));assert.match(result.stdout,/runtime conformance not checked/);
 }
 for(const version of ['3.0.3','3.1.1invalid']){
  fs.writeFileSync(file,fs.readFileSync(file,'utf8').replace(/^openapi:.*$/m,'openapi: '+version));
  assert.equal(run('registry/checks/check_openapi.sh',dir).status,1);
 }
});
test('OpenAPI inventory requires the header on the first line',t=>{
 const dir=fixture(t);starter(dir,'3.1.1');fs.writeFileSync(path.join(dir,'contracts/openapi/endpoints.inventory.tsv'),'invalid\nmethod\tpath\toperation_id\nGET\t/example\tx\n');
 const result=run('registry/checks/check_openapi.sh',dir);assert.equal(result.status,1);assert.match(result.stdout,/invalid_inventory_header/);
});
test('missing ripgrep is NOT_RUN with nonzero status, never pass',t=>{
 const dir=fixture(t),empty=path.join(dir,'empty');fs.mkdirSync(empty);
 for(const script of ['check_openapi.sh','check_template_hygiene.sh']){
  const result=run('registry/checks/'+script,dir,{PATH:empty});assert.equal(result.status,2);assert.match(output(result),/NOT_RUN/);assert.doesNotMatch(output(result),/passed/);
 }
});
test('scanner failures are errors rather than clean scans',t=>{
 const dir=fixture(t);starter(dir,'3.1.1');const bin=path.join(dir,'bin');fs.mkdirSync(bin);fs.writeFileSync(path.join(bin,'rg'),'#!/bin/sh\nexit 2\n',{mode:0o755});
 for(const script of ['check_openapi.sh','check_template_hygiene.sh']){
  const result=run('registry/checks/'+script,dir,{PATH:bin+':'+process.env.PATH});assert.equal(result.status,2);assert.match(output(result),/scan_failed/);assert.doesNotMatch(output(result),/passed/);
 }
});
test('hygiene reports filenames without reproducing detected secrets',t=>{
 const dir=fixture(t);fs.writeFileSync(path.join(dir,'sample.txt'),'public example');assert.equal(run('registry/checks/check_template_hygiene.sh',dir).status,0);
 const synthetic='gh'+'p_'+'x'.repeat(36);fs.writeFileSync(path.join(dir,'sample.txt'),synthetic);
 const result=run('registry/checks/check_template_hygiene.sh',dir);assert.equal(result.status,1);assert.match(output(result),/sample.txt/);assert.ok(!output(result).includes(synthetic));
 const missing=run('registry/checks/check_template_hygiene.sh',path.join(dir,'missing'));assert.equal(missing.status,2);
});
test('generated projects also reject skipped or failed hygiene checks',t=>{
 const dir=fixture(t),project=path.join(dir,'project');execFileSync(process.execPath,[path.join(root,'tools/vibe.mjs'),'use','go-next-postgres','--project',project],{stdio:'pipe'});
 const result=run(path.join(project,'scripts/check.sh'),project);assert.equal(result.status,0,output(result));
 const bin=path.join(dir,'bin');fs.mkdirSync(bin);
 let failure=run(path.join(project,'scripts/check.sh'),project,{PATH:bin});assert.equal(failure.status,2);assert.doesNotMatch(output(failure),/passed/);
 fs.writeFileSync(path.join(bin,'rg'),'#!/bin/sh\nexit 2\n',{mode:0o755});
 failure=run(path.join(project,'scripts/check.sh'),project,{PATH:bin+':'+process.env.PATH});assert.equal(failure.status,2);assert.match(output(failure),/scan_failed/);
});
