---
schema_version: 1
id: "frameworks.nestjs-validation"
title: "NestJS: ValidationPipe и DTO"
section: "frameworks"
level: "recommended"
tags: ["nestjs-validation", "NestJS", "TypeScript"]
technologies: ["NestJS", "TypeScript"]
published_at: "2026-11-09"
reviewed_at: "2026-11-13"
order: 112
related: ["backend.typed-boundaries", "security.object-access"]
sources: ["https://docs.nestjs.com/techniques/validation", "https://docs.nestjs.com/guards"]
---

# NestJS: ValidationPipe и DTO

## Коротко

DTO на HTTP-границе должен существовать во время выполнения. Включите ValidationPipe и явно задайте обязательность, null, пустые значения и обработку лишних полей; TypeScript-интерфейс этого не обеспечивает.

## Плохо

```typescript
interface CreateOrderDto { title: string }
// Тип исчезает после компиляции; ValidationPipe не получает правила.
@Post()
create(@Body() input: CreateOrderDto) {
  return this.orders.create(input);
}
```

## Хорошо

```typescript
import { Transform } from 'class-transformer';
import { IsDefined, IsNotEmpty, IsString, MaxLength } from 'class-validator';
import { ValidationPipe } from '@nestjs/common';

export class CreateOrderDto {
  @Transform(({ value }) => typeof value === 'string' ? value.trim() : value)
  @IsDefined()
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  title!: string;
}

// При bootstrap, до listen:
app.useGlobalPipes(new ValidationPipe({
  transform: true,
  transformOptions: { enableImplicitConversion: false },
  whitelist: true,
  forbidNonWhitelisted: true,
}));
// В controller: import { CreateOrderDto } ...; @Body() input: CreateOrderDto
```

## Почему

Проверка выполняется над значениями запроса, а не над предположениями компилятора. Неявное преобразование и пропуск null могут принять значение, которое API не обещал поддерживать.

## Когда применять

Профиль примера: NestJS 11, class-validator 0.14 и class-transformer 0.5; точные patch-версии и HTTP adapter фиксируются в приложении. Используется обычный value-import DTO, не `import type`. `app` — созданный Nest application; показан фрагмент bootstrap, а не самостоятельная программа.

Для POST title обязателен; null, число и строка из пробелов запрещены. Trim выполняется только для строки, после него длина не больше 200. Для PATCH задайте отдельный контракт: отсутствие поля, явный null и очистка не эквивалентны. Не включайте `skipMissingProperties` для такого POST без изменения требования.

Вложенный объект требует своей DTO, `ValidateNested` и корректного преобразования типа; массив дополнительно ограничивается по длине и проверяется по элементам. Это не появляется из `whitelist` автоматически. Размер HTTP-тела ограничивается adapter/proxy до дорогой валидации. Authorization guard и проверка доступа к объекту остаются отдельными действиями.

Преобразование path/query задавайте осознанно, например через `ParseIntPipe`; не объявляйте строку \"false\" ложью только из TypeScript-типа boolean.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| title="  Заказ  " | Handler получает "Заказ" | HTTP-тест с наблюдением DTO |
| Нет title, null, число, пробелы или более 200 символов | 400 до вызова сервиса | Таблица негативных запросов |
| Дополнительное ownerId или admin | 400 благодаря forbidNonWhitelisted | Ответ и отсутствие вызова записи |
| Добавлены массив/вложенная DTO | Проверяются вложенные неизвестные поля, элементы и лимит длины | Отдельные граничные запросы |
| Тело превышает согласованный предел | Отказ на транспортной границе, не бесконечная обработка | Проверка adapter/proxy |

Проверьте фактический сериализатор ошибок проекта. Сборка TypeScript и прямой вызов controller не подтверждают подключение глобального pipe.

## Человек

Утверждает входную схему, trim/coercion и лимиты тела и коллекций.

## Агент

Использует реальные классы DTO и value-import, показывает bootstrap и HTTP-проверку. Не приписывает whitelist авторизацию или глубокую валидацию без декораторов.

## Источники

- [NestJS: ValidationPipe](https://docs.nestjs.com/techniques/validation)
- [NestJS: guards](https://docs.nestjs.com/guards)
