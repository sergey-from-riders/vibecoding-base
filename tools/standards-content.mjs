// Shared, dependency-free reader. This code is shipped with the site, never executed from fetched Git data.
export const SCHEMA_VERSION = 1;
export const LEVELS = {required:'Обязательно',recommended:'Рекомендуется',contextual:'Зависит от задачи'};
export const BLOCKS = ['Коротко','Плохо','Хорошо','Почему','Когда применять','Как проверить','Источники'];
const OPTIONAL_BLOCKS = ['Человек','Агент','Пример применения'];
const slug = /^[a-z][a-z0-9-]{0,79}$/;
const ruleId = /^[a-z][a-z0-9-]{0,79}\.[a-z][a-z0-9-]{0,79}$/;
const date = /^\d{4}-\d{2}-\d{2}$/;
function requireValue(ok, message) { if (!ok) throw new Error(message); }
export function frontmatter(raw) {
  requireValue(typeof raw === 'string' && Buffer.byteLength(raw) <= 100000, 'Invalid document size');
  const match = raw.replace(/\r\n/g,'\n').match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  requireValue(match && match[1].length < 16000,'Missing frontmatter');
  const meta = Object.create(null);
  for (const line of match[1].split('\n')) {
    const pair = line.match(/^([a-z_]+): (.+)$/);
    requireValue(pair && !Object.hasOwn(meta,pair[1]),'Invalid or duplicate metadata');
    meta[pair[1]] = JSON.parse(pair[2]);
  }
  requireValue(meta.schema_version === SCHEMA_VERSION, 'Unsupported content schema');
  return {meta,body:match[2].trim()};
}
function text(value, max=500) { return typeof value === 'string' && value.trim().length > 0 && value.length <= max; }
function strings(value,max=30) { return Array.isArray(value) && value.length<=max && value.every(v=>text(v,200)); }
function validDate(value) { return typeof value==='string' && date.test(value) && !Number.isNaN(Date.parse(value)) && new Date(value).toISOString().slice(0,10)===value; }
function safeUrl(value) {
  try { const url=new URL(value); return url.protocol==='https:' && !url.username && !url.password; } catch { return false; }
}
export function parseSection(raw,path) {
  requireValue(/^registry\/handbook\/[a-z0-9-]+\.md$/.test(path),'Invalid section path');
  const {meta,body}=frontmatter(raw);
  requireValue(slug.test(meta.id) && path.endsWith('/'+meta.id+'.md') && text(meta.title,100) && text(body,1000),'Invalid section');
  requireValue(Number.isInteger(meta.order) && meta.order>0,'Invalid section order');
  requireValue(meta.parent===undefined || (slug.test(meta.parent) && meta.parent!==meta.id),'Invalid section parent');
  return {id:meta.id,title:meta.title,description:body,order:meta.order,...(meta.parent?{parent:meta.parent}:{})};
}
export function parseRule(raw,path,updatedAt) {
  requireValue(/^registry\/standards\/[a-z0-9-]+\/[a-z0-9-]+\/rules\/[a-z0-9-]+\.md$/.test(path),'Invalid rule path');
  const {meta,body}=frontmatter(raw);
  requireValue(ruleId.test(meta.id) && slug.test(meta.section) && meta.id.startsWith(meta.section+'.'),'Invalid rule identity');
  const name=meta.id.split('.')[1];
  requireValue(path.endsWith('/'+name+'.md') && text(meta.title,160),'Invalid rule name');
  requireValue(Object.hasOwn(LEVELS,meta.level),'Invalid level');
  requireValue(validDate(meta.reviewed_at) && meta.reviewed_at<=new Date().toISOString().slice(0,10),'Invalid review date');
  requireValue(validDate(updatedAt),'Invalid modification date');
  requireValue(strings(meta.tags) && strings(meta.technologies) && strings(meta.related) && meta.related.every(v=>ruleId.test(v)),'Invalid tags or relationships');
  requireValue(strings(meta.sources) && meta.sources.length>0 && meta.sources.every(safeUrl),'Invalid sources');
  requireValue(Number.isInteger(meta.order) && meta.order>0,'Invalid rule order');
  requireValue(body.startsWith('# '+meta.title+'\n'),'Heading differs from title');
  const blocks=Object.create(null); let current=null, fenced=false;
  for(const line of body.split('\n').slice(1)) {
    if(line.startsWith('```')) fenced=!fenced;
    const heading=!fenced && line.match(/^## (.+)$/);
    if(heading) {
      requireValue([...BLOCKS,...OPTIONAL_BLOCKS].includes(heading[1]) && !Object.hasOwn(blocks,heading[1]),'Invalid or duplicate section heading');
      current=heading[1];blocks[current]=[];
    } else if(current) blocks[current].push(line);
    else requireValue(!line.trim(),'Text outside sections');
  }
  requireValue(!fenced,'Unclosed code fence');
  for(const key of BLOCKS) { requireValue(blocks[key]?.join('\n').trim(),'Missing section '+key); blocks[key]=blocks[key].join('\n').trim(); }
  for(const key of OPTIONAL_BLOCKS) if(blocks[key]) {blocks[key]=blocks[key].join('\n').trim();requireValue(blocks[key],'Empty section '+key);}
  const citedSources=[...blocks['Источники'].matchAll(/\[[^\]\n]+\]\((https:\/\/[^\s)]+)\)/g)].map(match=>match[1]);
  requireValue(new Set(meta.sources).size===meta.sources.length && citedSources.length===meta.sources.length && meta.sources.every(source=>citedSources.includes(source)),'Sources differ between metadata and Markdown');
  const examples={};
  for(const [name,key] of [['bad','Плохо'],['good','Хорошо']]) {
    const code=blocks[key].match(/^```([a-z0-9+-]*)\n([\s\S]*?)\n```$/);
    requireValue(code && code[2].length<=12000,'Example must be one bounded fenced block');
    examples[name]={language:code[1]||'text',code:code[2]};
  }
  return {id:meta.id,slug:name,section:meta.section,title:meta.title,level:meta.level,tags:meta.tags,technologies:meta.technologies,reviewedAt:meta.reviewed_at,updatedAt,order:meta.order,related:meta.related,sources:meta.sources,summary:blocks['Коротко'],blocks,examples,sourcePath:path,markdown:raw};
}
export function validateCollection(sections,rules) {
  requireValue(sections.length>0 && sections.length<=50 && rules.length>0 && rules.length<=2000,'Invalid catalogue size');
  const sectionIds=new Set(sections.map(s=>s.id)), ids=new Set(rules.map(r=>r.id));
  requireValue(sectionIds.size===sections.length && ids.size===rules.length,'Duplicate identifier');
  for(const rule of rules) {
    requireValue(sectionIds.has(rule.section),'Missing category for '+rule.id);
    requireValue(rule.related.every(id=>ids.has(id) && id!==rule.id),'Broken related rule for '+rule.id);
  }
  for(const section of sections) {
    requireValue(rules.some(r=>r.section===section.id),'Empty category '+section.id);
    if(section.parent)requireValue(sections.some(s=>s.id===section.parent&&!s.parent),'Invalid section hierarchy');
  }
  sections.sort((a,b)=>a.order-b.order||a.id.localeCompare(b.id));
  rules.sort((a,b)=>a.order-b.order||a.id.localeCompare(b.id));
  return {sections,rules};
}
export function renderStandard(title,rules) {
  return '# '+title+'\n\n> Собрано автоматически из rules/*.md. Редактируйте исходные правила, затем выполните `node tools/handbook.mjs generate`.\n\n'+rules.map(rule=>{
    const {body}=frontmatter(rule.markdown);
    return body.replace(/^# /m,'## ').replace(/^## (Коротко|Плохо|Хорошо|Почему|Когда применять|Как проверить|Источники|Человек|Агент|Пример применения)$/gm,'### $1')+'\n\nУровень: '+LEVELS[rule.level]+'. Проверено: '+rule.reviewedAt+'.\n';
  }).join('\n')+'\n';
}
