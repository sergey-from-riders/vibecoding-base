import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import {frontmatter,parseRule,validateCollection} from './standards-content.mjs';
import {readHandbook,verifyHandbook} from './handbook.mjs';
const file='registry/standards/api/openapi-modular/rules/http-status.md';
const raw=fs.readFileSync(new URL('../'+file,import.meta.url),'utf8');
test('all materials and generated standards form a complete catalogue',()=>{const data=readHandbook();assert.equal(data.sections.length,16);assert.ok(data.rules.length>=117);verifyHandbook();});
test('invalid metadata, future dates, missing examples and duplicate headings fail closed',()=>{
 for(const changed of [raw.replace('level: "required"','level: "anything"'),raw.replace('2026-11-09','2999-01-01'),raw.replace('## Хорошо','## Другое'),raw.replace('## Почему','## Коротко'),raw.replace('https://www.rfc-editor.org','javascript:alert')])assert.throws(()=>parseRule(changed,file,'2026-11-09'));
 assert.throws(()=>frontmatter(raw.replace('title:','id:')));
});
test('identities, related links and empty sections are checked',()=>{
 const {sections,rules}=readHandbook();assert.throws(()=>validateCollection(sections,[...rules,rules[0]]));assert.throws(()=>validateCollection(sections,rules.map((r,i)=>i===0?{...r,related:['missing.rule']}:r)));assert.throws(()=>validateCollection([...sections,{id:'empty'}],rules));
});
test('raw code is kept as data, including HTML examples',()=>{const rule=readHandbook().rules.find(r=>r.id==='interface.keyboard');assert.ok(rule.examples.good.code.includes('<button'));assert.ok(rule.markdown.includes('```html'));});
test('source links must match in metadata and the exported Markdown',()=>{
 assert.throws(()=>parseRule(raw.replace(/\]\(https:\/\/[^)]+\)/,'](https://example.com/unrelated)'),file,'2026-11-09'),/Sources differ/);
 assert.throws(()=>parseRule(raw.replace(/^sources: (.+)$/m,(_,value)=>{const sources=JSON.parse(value);return 'sources: '+JSON.stringify([...sources,sources[0]]);}),file,'2026-11-09'),/Sources differ/);
});

test('every rule assigns human and agent responsibilities; UI/UX is a Frontend child',()=>{const data=readHandbook();for(const r of data.rules){assert.ok(r.blocks['Человек']);assert.ok(r.blocks['Агент']);if(r.section==='frameworks')assert.ok(r.blocks['Пример применения']);}assert.equal(data.sections.find(s=>s.id==='interface').parent,'frontend');assert.throws(()=>validateCollection(data.sections.map(s=>s.id==='interface'?{...s,parent:'missing'}:s),data.rules));});
