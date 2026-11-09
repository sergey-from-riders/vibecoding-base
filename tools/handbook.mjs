#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {execFileSync} from 'node:child_process';
import {parseRule,parseSection,validateCollection,renderStandard} from './standards-content.mjs';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
function files(dir) { return fs.readdirSync(dir,{withFileTypes:true}).flatMap(e=>e.isDirectory()?files(path.join(dir,e.name)):e.isFile()?[path.join(dir,e.name)]:[]); }
export function readHandbook() {
  const sections=files(path.join(root,'registry/handbook')).filter(p=>p.endsWith('.md')).map(p=>parseSection(fs.readFileSync(p,'utf8'),path.relative(root,p)));
  const rules=files(path.join(root,'registry/standards')).filter(p=>/\/rules\/[^/]+\.md$/.test(p)).map(p=>{
    const rel=path.relative(root,p); const modified=execFileSync('git',['log','-1','--format=%cs','--',rel],{cwd:root,encoding:'utf8'}).trim() || new Date().toISOString().slice(0,10);
    return parseRule(fs.readFileSync(p,'utf8'),rel,modified);
  });
  return validateCollection(sections,rules);
}
export function verifyHandbook(write=false) {
  const {sections,rules}=readHandbook(),groups=new Map();
  for(const rule of rules) {const dir=rule.sourcePath.split('/rules/')[0];groups.set(dir,[...(groups.get(dir)||[]),rule]);}
  for(const [dir,items] of groups) {
    const yaml=fs.readFileSync(path.join(root,dir,'standard.yaml'),'utf8');
    const title=yaml.match(/^name: (.+)$/m)?.[1];if(!title)throw new Error('Missing standard name: '+dir);
    const target=path.join(root,dir,'standard.md'),expected=renderStandard(title,items);
    if(write) fs.writeFileSync(target,expected);
    else if(!fs.existsSync(target)||fs.readFileSync(target,'utf8')!==expected)throw new Error('Generated standard drift: '+dir);
  }
  return {sections:sections.length,rules:rules.length,standards:groups.size};
}
if(process.argv[1] && path.resolve(process.argv[1])===fileURLToPath(import.meta.url)) {
  try { console.log(JSON.stringify(verifyHandbook(process.argv[2]==='generate'))); }
  catch(error) { console.error(error.message);process.exitCode=1; }
}
