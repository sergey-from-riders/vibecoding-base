---
schema_version: 1
id: "security.output-encoding"
title: "Браузер: безопасный вывод текста и HTML"
section: "security"
level: "required"
tags: ["xss", "encoding", "sanitization"]
technologies: ["HTML", "JavaScript", "Web"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1053
related: ["security.csrf", "integrations.files", "security.supply-chain"]
sources: ["https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html", "https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md"]
---

# Браузер: безопасный вывод текста и HTML

## Коротко

Недоверенные строки выводятся как текст безопасным API или context-aware encoder. Если продукт разрешает пользовательский HTML, требуется отдельная sanitization policy.

## Плохо

```javascript
function renderMessage(untrustedText) {
  const message = document.createElement("p");
  message.innerHTML = untrustedText;
  document.body.append(message);
}
```

## Хорошо

```javascript
function renderMessage(untrustedText) {
  const message = document.createElement("p");
  message.textContent = untrustedText;
  document.body.append(message);
}
```

## Почему

Текст, HTML attribute, URL, JavaScript и CSS имеют разные правила интерпретации. Один универсальный escape или проверка при сохранении не покрывают все контексты. Framework auto-escaping помогает только пока не используется обход вроде raw HTML renderer или небезопасного DOM sink.

## Когда применять

Для web UI и генерации HTML, включая данные API/БД, внешние сервисы и Markdown. По умолчанию используйте текстовые template bindings/textContent в обычном текстовом элементе; не вставляйте недоверенные данные в script/style/handler code и не выполняйте eval. Safe sink для текста не делает безопасными произвольные tag names или attributes: в примере p выбран константой.

Для URL валидируйте разрешенные схемы и назначение, затем кодируйте компоненты/attribute по контексту; encodeURIComponent не проверяет полный URL. Javascript: и неподходящие data: не становятся допустимыми после HTML escaping. Для разрешенного rich HTML/Markdown задайте allowlist tags/attributes/URL schemes, поддерживаемый sanitizer и его обновления; не модифицируйте sanitized HTML небезопасно после проверки. Учитывайте stored, reflected и DOM-based пути, в том числе импортированный контент.

CSP является дополнительным ограничением исполнения, а не заменой encoding/sanitization. Если проект принимает ASVS 5.0.0 3.4.3, фиксируйте его уровень и политику: минимум object-src 'none' и base-uri 'none', а также allowlist либо nonces/hashes. Для L3 определите политику для каждого ответа с nonces или hashes; это не означает необходимость менять hash неизменного содержимого для каждого ответа. Report-Only сначала показывает нарушения, но не блокирует их; факт наличия заголовка не доказывает защиту. Пример решает вывод plain text и не обещает обработку rich HTML.

## Как проверить

1. Текст с <, >, кавычками и разметкой → renderMessage → показан буквальный текст, элементы/handlers не созданы → DOM и отсутствие выполнения.

2. Разрешенный rich HTML плюс event attribute/опасная URL scheme → sanitizer → разрешенное оформление сохранено, активные конструкции удалены → DOM fixture.

3. Данные из БД/URL доходят до raw renderer либо CSP только Report-Only → review/browser test → опасный путь обнаружен; защита не заявлена по наличию CSP → evidence конкретного sink.

## Человек

Определяет plain text/rich HTML возможности, допустимые URL и browser security profile.

## Агент

Прослеживает source→sink, выбирает контекстный API и проверяет sanitizer/CSP без универсального escape.

## Источники

- [OWASP XSS Prevention: output contexts, dangerous contexts, HTML sanitization, safe sinks](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
- [ASVS v5.0.0 V3: 3.2.2 safe text sinks и 3.4.3 CSP по уровню](https://raw.githubusercontent.com/OWASP/ASVS/v5.0.0/5.0/en/0x12-V3-Web-Frontend-Security.md)
