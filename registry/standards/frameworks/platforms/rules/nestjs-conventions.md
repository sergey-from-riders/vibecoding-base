---
schema_version: 1
id: "frameworks.nestjs-conventions"
title: "NestJS: модули, имена и внедрение зависимостей"
section: "frameworks"
level: "recommended"
tags: ["frameworks", "conventions"]
technologies: ["NestJS 11", "TypeScript"]
published_at: "2026-11-13"
reviewed_at: "2026-11-13"
order: 1209
related: ["frameworks.nestjs-validation", "backend.typed-boundaries"]
sources: ["https://docs.nestjs.com/modules", "https://docs.nestjs.com/providers", "https://docs.nestjs.com/fundamentals/custom-providers"]
---

# NestJS: модули, имена и внедрение зависимостей

## Коротко

Собирайте функцию приложения через Nest module: controller обрабатывает транспорт, provider внедряется container, exports задает публичные зависимости. Имена и пути должны показывать роль без обязательных лишних слоев.

## Плохо

```typescript
const orders = new OrdersService(new DatabaseClient());
@Controller('orders')
export class OrdersController {
  @Get()
  list() { return orders.list(); }
} // Жизненный цикл и зависимости обходят Nest container.
```

## Хорошо

```typescript
import { Controller, Get, Injectable, Module } from '@nestjs/common';

@Injectable()
export class OrdersService {
  list(): ReadonlyArray<{ id: number }> {
    return [{ id: 1 }];
  }
}

@Controller('orders')
export class OrdersController {
  constructor(private readonly orders: OrdersService) {}
  @Get()
  list() { return this.orders.list(); }
}

@Module({
  controllers: [OrdersController],
  providers: [OrdersService],
  exports: [OrdersService],
})
export class OrdersModule {}
```

## Почему

Container может управлять жизненным циклом, scopes и тестовыми подменами только для зарегистрированных providers. Ручное создание зависимостей в глобальном коде скрывает их настройку и часто создает отдельные экземпляры ресурсов.

## Когда применять

NestJS 11 с TypeScript и включенными настройками decorators/metadata по шаблону выбранной версии. Пример в одном фрагменте; обычно файлы называются `orders.module.ts`, `orders.controller.ts`, `orders.service.ts`, классы — PascalCase, методы — camelCase. Это соглашение проекта/CLI, не ограничение файловой системы языка.

OrdersModule включен в imports корневого модуля. Другой модуль, которому нужен OrdersService, импортирует OrdersModule; provider экспортируется только если действительно нужен снаружи. Не повторяйте регистрацию одного stateful provider в каждом module, если нужен общий экземпляр.

TypeScript interface не существует в runtime: для interface-зависимости нужен явный injection token и binding. Concrete-классу отдельный token обычно не нужен. Scope request выбирают по причине; singleton не хранит изменяемое состояние текущего пользователя.

DTO и ValidationPipe защищают вход, guards — доступ; это другие границы. Изолируйте бизнес-операцию при необходимости, но не создавайте обязательные Repository/Manager/Facade для простого controller. Расширение imports для ESM зависит от moduleResolution и версии сборки, поэтому не смешивайте шаблоны разных профилей.

## Как проверить

| Вход и действие | Ожидаемый результат | Свидетельство |
| --- | --- | --- |
| Bootstrap корневого module и GET /orders | Provider разрешен, маршрут возвращает контрактный ответ | Nest TestingModule и HTTP |
| Удален import/exports нужного module | Зависимость не разрешается; проверка ловит конфигурацию | Негативный bootstrap |
| Provider заменен в тесте | Controller использует подмену через container | overrideProvider и наблюдение вызова |
| Два пользователя одновременно | Singleton не смешивает request state | Конкурентный сценарий |

Компиляция TypeScript без bootstrap Nest не подтверждает graph providers.

## Человек

Выбирает границы modules и действительно публичные providers.

## Агент

Проверяет imports/providers/exports, runtime tokens и scope; сохраняет транспортные DTO отдельно от доменного состояния.

## Источники

- [NestJS: modules](https://docs.nestjs.com/modules)
- [NestJS: providers](https://docs.nestjs.com/providers)
- [NestJS: custom providers](https://docs.nestjs.com/fundamentals/custom-providers)
