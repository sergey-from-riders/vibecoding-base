#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const REGISTRY_VERSION = "1.0.0";
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, "..");
const REGISTRY_DIR = path.join(REPO_ROOT, "registry");

const STATUS_VALUES = new Set(["draft", "experimental", "stable", "deprecated"]);
const READINESS_VALUES = new Set(["ready", "partial", "missing"]);
const DISABLED_FEATURES = ["mobile", "desktop", "worker", "admin", "payments", "queue", "ai"];

function fail(message) {
  console.error(`vibe: ${message}`);
  process.exitCode = 1;
}

function die(message) {
  fail(message);
  process.exit(1);
}

function readText(file) {
  return fs.readFileSync(file, "utf8");
}

function writeText(file, content) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, content.endsWith("\n") ? content : `${content}\n`);
}

function copyDir(src, dest) {
  if (!fs.existsSync(src)) return;
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const from = path.join(src, entry.name);
    const to = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(from, to);
    } else if (entry.isFile()) {
      fs.mkdirSync(path.dirname(to), { recursive: true });
      fs.copyFileSync(from, to);
    }
  }
}

function listFiles(dir, predicate = () => true) {
  if (!fs.existsSync(dir)) return [];
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) out.push(...listFiles(full, predicate));
    if (entry.isFile() && predicate(full)) out.push(full);
  }
  return out;
}

function leadingSpaces(line) {
  const match = line.match(/^ */);
  return match ? match[0].length : 0;
}

function cleanYamlLines(text) {
  return text
    .split(/\r?\n/)
    .map((raw) => raw.replace(/\t/g, "  "))
    .filter((line) => line.trim() && !line.trim().startsWith("#"));
}

function parseScalar(value) {
  const trimmed = value.trim();
  if (trimmed === "true") return true;
  if (trimmed === "false") return false;
  if (trimmed === "[]") return [];
  if (trimmed === "{}") return {};
  if (
    (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
    (trimmed.startsWith("'") && trimmed.endsWith("'"))
  ) {
    return trimmed.slice(1, -1);
  }
  return trimmed;
}

function splitKeyValue(value) {
  const idx = value.indexOf(":");
  if (idx === -1) return null;
  return [value.slice(0, idx).trim(), value.slice(idx + 1).trim()];
}

function parseYaml(text) {
  const lines = cleanYamlLines(text);
  let index = 0;

  function parseBlock(indent) {
    if (index >= lines.length) return {};
    const current = lines[index];
    const currentIndent = leadingSpaces(current);
    if (currentIndent < indent) return {};
    if (current.trim().startsWith("- ")) return parseList(indent);
    return parseMap(indent);
  }

  function parseList(indent) {
    const arr = [];
    while (index < lines.length) {
      const line = lines[index];
      const lineIndent = leadingSpaces(line);
      const trimmed = line.trim();
      if (lineIndent < indent || !trimmed.startsWith("- ")) break;
      if (lineIndent > indent) break;

      const itemRaw = trimmed.slice(2).trim();
      index += 1;

      const kv = splitKeyValue(itemRaw);
      if (kv && !itemRaw.includes("@") && !itemRaw.startsWith("http")) {
        const [key, rawValue] = kv;
        const obj = {};
        obj[key] = rawValue ? parseScalar(rawValue) : parseBlock(indent + 2);
        while (index < lines.length && leadingSpaces(lines[index]) > indent) {
          const nestedIndent = leadingSpaces(lines[index]);
          const nestedTrimmed = lines[index].trim();
          if (nestedIndent < indent + 2 || nestedTrimmed.startsWith("- ")) break;
          const nestedKv = splitKeyValue(nestedTrimmed);
          if (!nestedKv) break;
          const [nestedKey, nestedValue] = nestedKv;
          index += 1;
          obj[nestedKey] = nestedValue ? parseScalar(nestedValue) : parseBlock(nestedIndent + 2);
        }
        arr.push(obj);
      } else {
        arr.push(parseScalar(itemRaw));
      }
    }
    return arr;
  }

  function parseMap(indent) {
    const obj = {};
    while (index < lines.length) {
      const line = lines[index];
      const lineIndent = leadingSpaces(line);
      if (lineIndent < indent) break;
      if (lineIndent > indent) break;
      const trimmed = line.trim();
      if (trimmed.startsWith("- ")) break;
      const kv = splitKeyValue(trimmed);
      if (!kv) {
        index += 1;
        continue;
      }
      const [key, rawValue] = kv;
      index += 1;
      obj[key] = rawValue ? parseScalar(rawValue) : parseBlock(indent + 2);
    }
    return obj;
  }

  return parseBlock(0);
}

function dumpYaml(value, indent = 0) {
  const pad = " ".repeat(indent);
  if (Array.isArray(value)) {
    if (value.length === 0) return "[]";
    return value
      .map((item) => {
        if (item && typeof item === "object" && !Array.isArray(item)) {
          const nested = dumpYaml(item, indent + 2);
          const lines = nested.split("\n");
          return `${pad}- ${lines[0].trimStart()}\n${lines.slice(1).join("\n")}`;
        }
        return `${pad}- ${formatScalar(item)}`;
      })
      .join("\n");
  }
  if (value && typeof value === "object") {
    return Object.entries(value)
      .map(([key, child]) => {
        if (Array.isArray(child)) {
          if (child.length === 0) return `${pad}${key}: []`;
          return `${pad}${key}:\n${dumpYaml(child, indent + 2)}`;
        }
        if (child && typeof child === "object") {
          return `${pad}${key}:\n${dumpYaml(child, indent + 2)}`;
        }
        return `${pad}${key}: ${formatScalar(child)}`;
      })
      .join("\n");
  }
  return `${pad}${formatScalar(value)}`;
}

function formatScalar(value) {
  if (typeof value === "boolean") return value ? "true" : "false";
  if (value === null || value === undefined) return "";
  const str = String(value);
  if (str === "" || str.includes(": #")) return JSON.stringify(str);
  return str;
}

function readYaml(file) {
  return parseYaml(readText(file));
}

function writeYaml(file, data) {
  writeText(file, dumpYaml(data));
}

function parseFlags(args) {
  const flags = {};
  const rest = [];
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (!arg.startsWith("--")) {
      rest.push(arg);
      continue;
    }
    const key = arg.slice(2);
    const next = args[i + 1];
    if (!next || next.startsWith("--")) {
      flags[key] = true;
    } else {
      flags[key] = next;
      i += 1;
    }
  }
  return { flags, rest };
}

function standardDir(id) {
  return path.join(REGISTRY_DIR, "standards", ...id.split("/"));
}

function templateDir(id) {
  return path.join(REGISTRY_DIR, "templates", ...id.split("/"));
}

function stackFile(id) {
  return path.join(REGISTRY_DIR, "stacks", `${id}.yaml`);
}

function checkFile(id) {
  return path.join(REGISTRY_DIR, "checks", `${id}.sh`);
}

function loadStandard(id) {
  const file = path.join(standardDir(id), "standard.yaml");
  if (!fs.existsSync(file)) die(`unknown standard: ${id}`);
  return readYaml(file);
}

function loadTemplate(id) {
  const file = path.join(templateDir(id), "template.yaml");
  if (!fs.existsSync(file)) die(`unknown template: ${id}`);
  return readYaml(file);
}

function loadStack(id) {
  const file = stackFile(id);
  if (!fs.existsSync(file)) die(`unknown stack: ${id}`);
  return readYaml(file);
}

function splitRef(ref) {
  const [id, range] = String(ref).split("@");
  return { id, range: range || "*" };
}

function satisfies(version, range) {
  if (!range || range === "*") return true;
  if (range.startsWith("^")) return version.split(".")[0] === range.slice(1).split(".")[0];
  return version === range;
}

function resolveStandardRef(ref) {
  const { id, range } = splitRef(ref);
  const standard = loadStandard(id);
  if (!satisfies(standard.version, range)) {
    die(`standard ${id}@${standard.version} does not satisfy ${range}`);
  }
  return { id, version: standard.version, standard };
}

function resolveTemplate(id) {
  const template = loadTemplate(id);
  return { id, version: template.version, template };
}

function allStandardIds() {
  return listFiles(path.join(REGISTRY_DIR, "standards"), (file) => file.endsWith("standard.yaml"))
    .map((file) => path.relative(path.join(REGISTRY_DIR, "standards"), path.dirname(file)).split(path.sep).join("/"))
    .sort();
}

function allStackIds() {
  return listFiles(path.join(REGISTRY_DIR, "stacks"), (file) => file.endsWith(".yaml"))
    .map((file) => path.basename(file, ".yaml"))
    .sort();
}

function stackFeature(stack, feature, variant) {
  const entry = stack.optional_features?.[feature];
  if (!entry) die(`stack ${stack.id} has no optional feature: ${feature}`);
  if (entry.variants) {
    const chosen = variant || Object.keys(entry.variants)[0];
    const value = entry.variants[chosen];
    if (!value) die(`feature ${feature} has no variant: ${chosen}`);
    return { key: feature, variant: chosen, ...value };
  }
  if (variant) die(`feature ${feature} does not accept a variant`);
  return { key: feature, variant: "default", ...entry };
}

function collectStandardRefs(stack, features = []) {
  const refs = [...(stack.standards || [])];
  for (const feature of features) refs.push(...(feature.standards || []));

  const seen = new Map();
  const visit = (ref) => {
    const resolved = resolveStandardRef(ref);
    if (seen.has(resolved.id)) return;
    seen.set(resolved.id, resolved);
    for (const dep of resolved.standard.dependencies || []) visit(dep);
  };

  for (const ref of refs) visit(ref);
  return [...seen.values()];
}

function collectTemplateRefs(stack, features = []) {
  const ids = [...(stack.templates || [])];
  for (const feature of features) ids.push(...(feature.templates || []));
  return [...new Set(ids)].map(resolveTemplate);
}

function activeStandardFileName(id, standard) {
  const exact = {
    "agent/base": "AGENTS.md",
    "framework/lifecycle": "FRAMEWORK.md",
    "api/openapi-modular": "API.md",
    "database/postgres": "DATABASE.md",
    "testing/tdd-strict": "TESTING.md",
    "security/no-secrets": "SECURITY.md",
    "observability/three-signals": "OBSERVABILITY.md",
    "ui/shadcn-compact": "UI.md",
    "backend/worker": "WORKER.md",
    "mobile/react-native": "MOBILE.md",
    "payments/stripe": "PAYMENTS.md"
  };
  if (exact[id]) return exact[id];
  if (standard.domain === "backend") return "BACKEND.md";
  if (standard.domain === "frontend") return "FRONTEND.md";
  return `${standard.domain.toUpperCase()}.md`;
}

function sortedActiveStandards(resolved) {
  const order = [
    "agent/base",
    "framework/lifecycle",
    "backend/go",
    "backend/python",
    "frontend/next",
    "frontend/react",
    "database/postgres",
    "api/openapi-modular",
    "testing/tdd-strict",
    "security/no-secrets",
    "observability/three-signals",
    "ui/shadcn-compact",
    "backend/worker",
    "mobile/react-native",
    "payments/stripe"
  ];
  return [...resolved].sort((a, b) => {
    const ai = order.indexOf(a.id);
    const bi = order.indexOf(b.id);
    return (ai === -1 ? 999 : ai) - (bi === -1 ? 999 : bi) || a.id.localeCompare(b.id);
  });
}

function componentLabel(key, value) {
  const labels = {
    "backend:go": "Go",
    "backend:python": "Python/FastAPI",
    "frontend:next": "Next.js",
    "frontend:react": "React",
    "database:postgres": "PostgreSQL",
    "contracts:openapi": "OpenAPI"
  };
  return labels[`${key}:${value}`] || value;
}

function renderAgents(stack, standards) {
  const readOrder = sortedActiveStandards(standards)
    .map((item) => `1. standards/active/${activeStandardFileName(item.id, item.standard)}`)
    .join("\n");
  const components = Object.entries(stack.components || {})
    .map(([key, value]) => `- ${key[0].toUpperCase()}${key.slice(1)}: ${componentLabel(key, value)}`)
    .join("\n");

  return `# Project Rules

Active stack:
${components}

Read order:
${readOrder}

Forbidden:
- Do not add unused folders.
- Do not add disabled technologies without updating .vibe/profile.yaml.
- Do not bypass quality gates.
- Do not commit real secrets.
- Do not duplicate business logic across API/web/mobile.
- Do not change standard versions without updating .vibe/registry.lock.

Generated from vibecoding-base registry ${REGISTRY_VERSION}.
`;
}

function renderProjectReadme(stack, standards) {
  const standardList = sortedActiveStandards(standards)
    .map((item) => `- \`${item.id}@${item.version}\``)
    .join("\n");
  const readiness = Object.entries(stack.readiness || {})
    .map(([key, value]) => `- ${key}: ${value}`)
    .join("\n");
  return `# Generated ${stack.name}

This project was generated from the \`${stack.id}\` stack profile.

## Active Standards

${standardList}

## Status Matrix

${readiness}

## Commands

\`\`\`bash
scripts/check.sh
\`\`\`

Do not copy inactive registry folders into this project. Enable optional parts through the registry generator so profile, lockfile, standards and checks stay in sync.
`;
}

function renderCheckScript() {
  return `#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

violations=0

required=(
  "AGENTS.md"
  ".vibe/profile.yaml"
  ".vibe/enabled.yaml"
  ".vibe/registry.lock"
  "standards/active/AGENTS.md"
)

for item in "\${required[@]}"; do
  if [ ! -e "$item" ]; then
    echo "VIOLATION missing_required_path path=$item"
    violations=$((violations + 1))
  fi
done

check_disabled_path() {
  local feature="$1"
  shift
  if awk -v feature="$feature" '
    $0 == "disabled:" { in_disabled = 1; next }
    in_disabled && $0 !~ /^ / { in_disabled = 0 }
    in_disabled && $0 == "  " feature ": true" { found = 1 }
    END { exit(found ? 0 : 1) }
  ' .vibe/profile.yaml 2>/dev/null; then
    for item in "$@"; do
      if [ -e "$item" ]; then
        echo "VIOLATION disabled_feature_path_exists feature=$feature path=$item"
        violations=$((violations + 1))
      fi
    done
  fi
}

check_disabled_path mobile apps/mobile mobile
check_disabled_path desktop apps/desktop desktop
check_disabled_path worker apps/worker worker
check_disabled_path admin apps/admin admin
check_disabled_path payments apps/payments packages/payments payments
check_disabled_path queue apps/queue queue
check_disabled_path ai apps/ai ai

if [ -d registry ] || [ -d frameworks ]; then
  echo "VIOLATION generated_project_contains_registry_or_legacy_frameworks"
  violations=$((violations + 1))
fi

if [ "$violations" -gt 0 ]; then
  echo "Generated project check failed: violations=$violations"
  exit 1
fi

echo "Generated project check passed"
`;
}

function enabledFeatureList(projectDir, stack) {
  const file = path.join(projectDir, ".vibe", "enabled.yaml");
  if (!fs.existsSync(file)) return [];
  const enabled = readYaml(file);
  const out = [];
  for (const [feature, config] of Object.entries(enabled.features || {})) {
    if (!config?.enabled) continue;
    out.push(stackFeature(stack, feature, config.variant === "default" ? undefined : config.variant));
  }
  return out;
}

function profileData(stack, projectName, featureConfigs = {}) {
  const enabled = {
    backend: true,
    frontend: true,
    database: true,
    contracts: true,
    testing: true,
    security: true,
    observability: true
  };
  const disabled = {};
  for (const feature of DISABLED_FEATURES) disabled[feature] = !featureConfigs[feature]?.enabled;
  for (const [feature, config] of Object.entries(featureConfigs)) {
    if (config.enabled) enabled[feature] = true;
  }
  return {
    stack: stack.id,
    project_name: projectName,
    registry_version: REGISTRY_VERSION,
    components: stack.components,
    enabled,
    disabled
  };
}

function lockData(stack, standards, templates, featureConfigs = {}) {
  const standardVersions = {};
  const templateVersions = {};
  for (const item of sortedActiveStandards(standards)) standardVersions[item.id] = item.version;
  for (const item of templates) templateVersions[item.id] = item.version;
  return {
    registry_version: REGISTRY_VERSION,
    stack: stack.id,
    standards: standardVersions,
    templates: templateVersions,
    features: featureConfigs
  };
}

function generateProject(stackId, projectDir, options = {}, featureConfigs = {}) {
  const stack = loadStack(stackId);
  projectDir = path.resolve(projectDir);
  const projectName = options.name || path.basename(projectDir);

  if (projectDir === REPO_ROOT && fs.existsSync(path.join(projectDir, "registry"))) {
    die("refusing to generate into the registry repository root; pass --project <dir>");
  }

  if (options.force && fs.existsSync(projectDir)) {
    fs.rmSync(projectDir, { recursive: true, force: true });
  }

  fs.mkdirSync(projectDir, { recursive: true });

  const features = Object.entries(featureConfigs)
    .filter(([, config]) => config.enabled)
    .map(([feature, config]) => stackFeature(stack, feature, config.variant === "default" ? undefined : config.variant));

  const templates = collectTemplateRefs(stack, features);
  const standards = collectStandardRefs(stack, features);

  for (const item of templates) {
    copyDir(path.join(templateDir(item.id), "files"), projectDir);
  }

  const activeDir = path.join(projectDir, "standards", "active");
  fs.rmSync(activeDir, { recursive: true, force: true });
  fs.mkdirSync(activeDir, { recursive: true });
  for (const item of sortedActiveStandards(standards)) {
    const source = path.join(standardDir(item.id), item.standard.files.human_readable || "standard.md");
    const target = path.join(activeDir, activeStandardFileName(item.id, item.standard));
    const header = `<!-- Generated from registry/standards/${item.id}@${item.version}. Update the registry standard, then regenerate. -->\n\n`;
    writeText(target, `${header}${readText(source)}`);
  }

  writeText(path.join(projectDir, "AGENTS.md"), renderAgents(stack, standards));
  writeText(path.join(projectDir, "README.md"), renderProjectReadme(stack, standards));
  writeText(path.join(projectDir, "scripts", "check.sh"), renderCheckScript());
  fs.chmodSync(path.join(projectDir, "scripts", "check.sh"), 0o755);

  writeYaml(path.join(projectDir, ".vibe", "profile.yaml"), profileData(stack, projectName, featureConfigs));
  writeYaml(path.join(projectDir, ".vibe", "enabled.yaml"), {
    stack: stack.id,
    features: featureConfigs
  });
  writeYaml(path.join(projectDir, ".vibe", "registry.lock"), lockData(stack, standards, templates, featureConfigs));

  console.log(`Generated ${stack.id} at ${path.relative(process.cwd(), projectDir) || "."}`);
}

function enableFeature(projectDir, feature, variant) {
  projectDir = path.resolve(projectDir);
  const profileFile = path.join(projectDir, ".vibe", "profile.yaml");
  if (!fs.existsSync(profileFile)) die(`not a generated project: ${projectDir}`);
  const profile = readYaml(profileFile);
  const stack = loadStack(profile.stack);
  stackFeature(stack, feature, variant);
  const enabled = fs.existsSync(path.join(projectDir, ".vibe", "enabled.yaml"))
    ? readYaml(path.join(projectDir, ".vibe", "enabled.yaml"))
    : { stack: stack.id, features: {} };
  enabled.features = enabled.features || {};
  enabled.features[feature] = { enabled: true, variant: variant || "default" };
  generateProject(stack.id, projectDir, { name: profile.project_name }, enabled.features);
}

function disableFeature(projectDir, feature) {
  projectDir = path.resolve(projectDir);
  const profileFile = path.join(projectDir, ".vibe", "profile.yaml");
  if (!fs.existsSync(profileFile)) die(`not a generated project: ${projectDir}`);
  const profile = readYaml(profileFile);
  const stack = loadStack(profile.stack);
  const enabled = fs.existsSync(path.join(projectDir, ".vibe", "enabled.yaml"))
    ? readYaml(path.join(projectDir, ".vibe", "enabled.yaml"))
    : { stack: stack.id, features: {} };
  const config = enabled.features?.[feature];
  if (config?.enabled) {
    const featureDef = stackFeature(stack, feature, config.variant === "default" ? undefined : config.variant);
    for (const templateId of featureDef.templates || []) {
      const template = loadTemplate(templateId);
      for (const itemPath of template.paths || []) {
        fs.rmSync(path.join(projectDir, itemPath), { recursive: true, force: true });
      }
    }
  }
  enabled.features = enabled.features || {};
  enabled.features[feature] = { enabled: false, variant: config?.variant || "default" };
  generateProject(stack.id, projectDir, { name: profile.project_name }, enabled.features);
}

function validateRequired(data, fields, label, errors) {
  for (const field of fields) {
    if (data[field] === undefined) errors.push(`${label}: missing ${field}`);
  }
}

function verifyRegistry() {
  const errors = [];
  const standardIds = allStandardIds();
  const seenStandards = new Set(standardIds);

  for (const id of standardIds) {
    const dir = standardDir(id);
    const meta = readYaml(path.join(dir, "standard.yaml"));
    validateRequired(
      meta,
      ["id", "name", "version", "status", "domain", "owners", "applies_to", "dependencies", "enforcement", "files", "compatibility", "changelog"],
      `standard ${id}`,
      errors
    );
    if (meta.id !== id) errors.push(`standard ${id}: id must match path`);
    if (!/^[0-9]+\.[0-9]+\.[0-9]+$/.test(meta.version || "")) errors.push(`standard ${id}: invalid SemVer version`);
    if (!STATUS_VALUES.has(meta.status)) errors.push(`standard ${id}: invalid status ${meta.status}`);
    if (!Array.isArray(meta.owners) || meta.owners.length === 0) errors.push(`standard ${id}: owners must be non-empty`);
    if (!Array.isArray(meta.dependencies)) errors.push(`standard ${id}: dependencies must be an array`);
    for (const dep of meta.dependencies || []) {
      const depId = splitRef(dep).id;
      if (!seenStandards.has(depId)) errors.push(`standard ${id}: unknown dependency ${dep}`);
    }
    if (!fs.existsSync(path.join(dir, meta.files?.human_readable || ""))) errors.push(`standard ${id}: missing human-readable file`);
    if (!fs.existsSync(path.join(dir, meta.changelog || ""))) errors.push(`standard ${id}: missing changelog`);
    if (!fs.existsSync(path.join(dir, "README.md"))) errors.push(`standard ${id}: missing README.md`);
    const enforced = meta.enforcement?.linted || meta.enforcement?.tested || meta.enforcement?.ci_blocking;
    if (enforced) {
      const checksPath = meta.files?.checks;
      if (!checksPath || !fs.existsSync(path.join(dir, checksPath))) {
        errors.push(`standard ${id}: enforcement is true but checks.yaml is missing`);
      } else {
        const checks = readYaml(path.join(dir, checksPath));
        for (const check of checks.checks || []) {
          if (!check.file || !fs.existsSync(path.join(REPO_ROOT, check.file))) {
            errors.push(`standard ${id}: check file is missing for ${check.id || "unknown"}`);
          }
        }
      }
    }
  }

  for (const stackId of allStackIds()) {
    const stack = loadStack(stackId);
    validateRequired(stack, ["id", "name", "status", "description", "components", "standards", "templates", "checks", "readiness"], `stack ${stackId}`, errors);
    if (stack.id !== stackId) errors.push(`stack ${stackId}: id must match filename`);
    if (!STATUS_VALUES.has(stack.status)) errors.push(`stack ${stackId}: invalid status ${stack.status}`);
    for (const [key, value] of Object.entries(stack.readiness || {})) {
      if (!READINESS_VALUES.has(value)) errors.push(`stack ${stackId}: invalid readiness ${key}=${value}`);
    }
    for (const ref of stack.standards || []) {
      const id = splitRef(ref).id;
      if (!seenStandards.has(id)) errors.push(`stack ${stackId}: unknown standard ${ref}`);
    }
    for (const templateId of stack.templates || []) {
      if (!fs.existsSync(path.join(templateDir(templateId), "template.yaml"))) errors.push(`stack ${stackId}: unknown template ${templateId}`);
    }
    for (const check of stack.checks || []) {
      if (!fs.existsSync(checkFile(check))) errors.push(`stack ${stackId}: unknown check ${check}`);
    }
    for (const [feature, config] of Object.entries(stack.optional_features || {})) {
      const variants = config.variants || { default: config };
      for (const [variant, value] of Object.entries(variants)) {
        for (const ref of value.standards || []) {
          const id = splitRef(ref).id;
          if (!seenStandards.has(id)) errors.push(`stack ${stackId}: optional ${feature}/${variant} unknown standard ${ref}`);
        }
        for (const templateId of value.templates || []) {
          if (!fs.existsSync(path.join(templateDir(templateId), "template.yaml"))) {
            errors.push(`stack ${stackId}: optional ${feature}/${variant} unknown template ${templateId}`);
          }
        }
      }
    }
  }

  for (const schema of ["standard.schema.json", "stack.schema.json", "profile.schema.json"]) {
    if (!fs.existsSync(path.join(REGISTRY_DIR, "schemas", schema))) errors.push(`missing schema ${schema}`);
  }

  return errors;
}

function disabledPaths(feature) {
  return {
    mobile: ["apps/mobile", "mobile"],
    desktop: ["apps/desktop", "desktop"],
    worker: ["apps/worker", "worker"],
    admin: ["apps/admin", "admin"],
    payments: ["apps/payments", "packages/payments", "payments"],
    queue: ["apps/queue", "queue"],
    ai: ["apps/ai", "ai"]
  }[feature] || [feature];
}

function verifyProject(projectDir) {
  const errors = [];
  projectDir = path.resolve(projectDir);
  const profileFile = path.join(projectDir, ".vibe", "profile.yaml");
  const lockFile = path.join(projectDir, ".vibe", "registry.lock");
  const enabledFile = path.join(projectDir, ".vibe", "enabled.yaml");
  for (const required of ["AGENTS.md", ".vibe/profile.yaml", ".vibe/enabled.yaml", ".vibe/registry.lock", "standards/active/AGENTS.md", "scripts/check.sh"]) {
    if (!fs.existsSync(path.join(projectDir, required))) errors.push(`project ${projectDir}: missing ${required}`);
  }
  if (!fs.existsSync(profileFile) || !fs.existsSync(lockFile)) return errors;

  const profile = readYaml(profileFile);
  const lock = readYaml(lockFile);
  if (!fs.existsSync(stackFile(profile.stack))) errors.push(`project ${projectDir}: unknown stack ${profile.stack}`);
  if (lock.stack !== profile.stack) errors.push(`project ${projectDir}: lock stack differs from profile stack`);
  if (fs.existsSync(path.join(projectDir, "registry")) || fs.existsSync(path.join(projectDir, "frameworks"))) {
    errors.push(`project ${projectDir}: contains registry or legacy frameworks folder`);
  }
  for (const [feature, disabled] of Object.entries(profile.disabled || {})) {
    if (!disabled) continue;
    for (const itemPath of disabledPaths(feature)) {
      if (fs.existsSync(path.join(projectDir, itemPath))) {
        errors.push(`project ${projectDir}: disabled feature ${feature} path exists: ${itemPath}`);
      }
    }
  }
  for (const [id, version] of Object.entries(lock.standards || {})) {
    if (!fs.existsSync(path.join(standardDir(id), "standard.yaml"))) {
      errors.push(`project ${projectDir}: lock references unknown standard ${id}`);
      continue;
    }
    const standard = loadStandard(id);
    if (standard.version !== version) errors.push(`project ${projectDir}: standard ${id} lock=${version} registry=${standard.version}`);
    const activeFile = path.join(projectDir, "standards", "active", activeStandardFileName(id, standard));
    if (!fs.existsSync(activeFile)) errors.push(`project ${projectDir}: missing active standard ${activeStandardFileName(id, standard)}`);
  }
  for (const [id, version] of Object.entries(lock.templates || {})) {
    if (!fs.existsSync(path.join(templateDir(id), "template.yaml"))) {
      errors.push(`project ${projectDir}: lock references unknown template ${id}`);
      continue;
    }
    const template = loadTemplate(id);
    if (template.version !== version) errors.push(`project ${projectDir}: template ${id} lock=${version} registry=${template.version}`);
  }
  if (fs.existsSync(enabledFile)) {
    const enabled = readYaml(enabledFile);
    if (enabled.stack !== profile.stack) errors.push(`project ${projectDir}: enabled stack differs from profile stack`);
  }
  return errors;
}

function scanSecrets(targetDir) {
  const patterns = [
    /BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY/,
    /AKIA[0-9A-Z]{16}/,
    /AIza[0-9A-Za-z_-]{35}/,
    /xox[baprs]-[0-9A-Za-z-]+/,
    /ghp_[0-9A-Za-z]{36}/,
    /github_pat_[0-9A-Za-z_]{80,}/,
    /sk-[A-Za-z0-9]{20,}/
  ];
  const ignored = new Set([".git", "node_modules", "dist"]);
  const errors = [];

  function walk(dir) {
    if (!fs.existsSync(dir)) return;
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      if (ignored.has(entry.name)) continue;
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(full);
        continue;
      }
      if (!entry.isFile()) continue;
      const text = readText(full);
      if (patterns.some((pattern) => pattern.test(text))) {
        errors.push(`secret-like pattern in ${path.relative(targetDir, full)}`);
      }
    }
  }
  walk(targetDir);
  return errors;
}

function runVerify(target, flags = {}) {
  const errors = [];
  if (!flags["project-only"]) {
    errors.push(...verifyRegistry());
    errors.push(...scanSecrets(REGISTRY_DIR));
  }

  if (target) {
    errors.push(...verifyProject(target));
  } else if (!flags["registry-only"] && !flags["project-only"]) {
    const examplesDir = path.join(REPO_ROOT, "examples");
    if (fs.existsSync(examplesDir)) {
      for (const entry of fs.readdirSync(examplesDir, { withFileTypes: true })) {
        if (entry.isDirectory() && fs.existsSync(path.join(examplesDir, entry.name, ".vibe", "profile.yaml"))) {
          errors.push(...verifyProject(path.join(examplesDir, entry.name)));
        }
      }
    }
  }

  if (errors.length) {
    for (const error of errors) console.error(`VIOLATION ${error}`);
    die(`verify failed: violations=${errors.length}`);
  }
  console.log("vibe verify passed");
}

function listStandards() {
  for (const id of allStandardIds()) {
    const standard = loadStandard(id);
    console.log(`${id}@${standard.version} ${standard.status} owner=${standard.owners.join(",")}`);
  }
}

function explainStandard(id) {
  const standard = loadStandard(id);
  console.log(`${standard.name} (${id}@${standard.version})`);
  console.log(`status: ${standard.status}`);
  console.log(`domain: ${standard.domain}`);
  console.log(`owners: ${standard.owners.join(", ")}`);
  console.log(`file: ${path.relative(process.cwd(), path.join(standardDir(id), standard.files.human_readable))}`);
}

function updateStandard(projectDir, id) {
  projectDir = path.resolve(projectDir);
  const lockFile = path.join(projectDir, ".vibe", "registry.lock");
  if (!fs.existsSync(lockFile)) die(`not a generated project: ${projectDir}`);
  const lock = readYaml(lockFile);
  const stack = loadStack(lock.stack);
  const enabled = fs.existsSync(path.join(projectDir, ".vibe", "enabled.yaml"))
    ? readYaml(path.join(projectDir, ".vibe", "enabled.yaml"))
    : { stack: stack.id, features: {} };
  const features = enabledFeatureList(projectDir, stack);
  const standards = collectStandardRefs(stack, features);
  if (!standards.some((item) => item.id === id)) die(`standard ${id} is not active in ${projectDir}`);
  generateProject(stack.id, projectDir, { name: readYaml(path.join(projectDir, ".vibe", "profile.yaml")).project_name }, enabled.features || {});
}

function printDoctor() {
  console.log(`registry_version: ${REGISTRY_VERSION}`);
  console.log(`standards: ${allStandardIds().length}`);
  console.log(`stacks: ${allStackIds().join(", ")}`);
  console.log(`registry: ${path.relative(process.cwd(), REGISTRY_DIR)}`);
}

function usage() {
  console.log(`Usage:
  vibe init --project <dir>
  vibe use <stack> --project <dir> [--name <name>] [--force]
  vibe generate <stack> --project <dir> [--force]
  vibe enable <feature> [variant] --project <dir>
  vibe disable <feature> --project <dir>
  vibe standards list
  vibe standards explain <standard-id>
  vibe standards update <standard-id> --project <dir>
  vibe verify [project-dir]
  vibe doctor`);
}

function main() {
  const [command, ...args] = process.argv.slice(2);
  const { flags, rest } = parseFlags(args);

  if (!command || command === "help" || command === "--help") {
    usage();
    return;
  }

  if (command === "init") {
    const project = flags.project || process.cwd();
    console.log("Choose a stack with `vibe use <stack> --project <dir>`.");
    console.log(`Project target: ${project}`);
    return;
  }

  if (command === "use" || command === "generate") {
    const stack = rest[0];
    if (!stack) die(`${command} requires a stack id`);
    generateProject(stack, flags.project || process.cwd(), { name: flags.name, force: Boolean(flags.force) });
    return;
  }

  if (command === "enable") {
    const feature = rest[0];
    const variant = rest[1];
    if (!feature) die("enable requires a feature id");
    enableFeature(flags.project || process.cwd(), feature, variant);
    return;
  }

  if (command === "disable") {
    const feature = rest[0];
    if (!feature) die("disable requires a feature id");
    disableFeature(flags.project || process.cwd(), feature);
    return;
  }

  if (command === "standards") {
    const sub = rest[0];
    if (sub === "list") return listStandards();
    if (sub === "explain") return explainStandard(rest[1]);
    if (sub === "update") return updateStandard(flags.project || process.cwd(), rest[1]);
    die("standards requires list, explain or update");
  }

  if (command === "verify") {
    return runVerify(rest[0], flags);
  }

  if (command === "doctor") {
    return printDoctor();
  }

  die(`unknown command: ${command}`);
}

main();
