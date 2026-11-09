---
schema_version: 1
id: "frameworks.nestjs-validation"
title: "NestJS: ValidationPipe и DTO"
section: "frameworks"
level: "recommended"
tags: ["nestjs-validation", "NestJS", "TypeScript"]
technologies: ["NestJS", "TypeScript"]
reviewed_at: "2026-11-09"
order: 112
related: ["backend.typed-boundaries", "security.object-access"]
sources: ["https://docs.nestjs.com/techniques/validation", "https://docs.nestjs.com/guards"]
---

# NestJS: ValidationPipe и DTO

## Коротко

Runtime-валидация требует классов DTO с правилами. TypeScript-интерфейс не проверяет входящий JSON.

## Плохо

```typescript
interface CreateOrder { title: string }
// Тип исчезает после компиляции.
```

## Хорошо

```typescript
class CreateOrderDto {
  @IsString()
  @MaxLength(200)
  title!: string;
}
app.useGlobalPipes(new ValidationPipe({
  whitelist: true, forbidNonWhitelisted: true
}));
```

## Почему

Клиент может отправить поля и типы, которых нет в TypeScript-описании.

## Когда применять

NestJS с class-validator/class-transformer, декораторами и DTO-классом в @Body(). Импорты IsString/MaxLength — class-validator, ValidationPipe — @nestjs/common. Guard/Policy для доступа настраивается отдельно.

## Человек

Определяет допустимые поля и контракт ошибки.

## Агент

Настраивает ValidationPipe, DTO и запросы с некорректным JSON.

## Пример применения

POST /orders принимает title длиной до 200 символов. Поле isPaid, присланное клиентом, отклоняется; оплату меняет только серверный процесс.

## Как проверить

- Число вместо title и лишнее поле получают 400.
- Авторизация проверяется отдельно от DTO.

## Источники

- [Documentation](https://docs.nestjs.com/techniques/validation)
- [Guards](https://docs.nestjs.com/guards)
