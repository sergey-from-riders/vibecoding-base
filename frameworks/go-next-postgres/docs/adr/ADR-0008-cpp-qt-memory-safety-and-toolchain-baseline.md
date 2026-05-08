# ADR-0008: C++/Qt memory-safety and toolchain baseline for 2026

- Status: accepted
- Date: 2026-03-02

## Context
Desktop Qt client требует строгого и однозначного стандарта разработки в C++, особенно для memory safety.
Без жестких правил ownership и toolchain гейтов в агентной генерации кода быстро появляются use-after-free, null-deref и lifecycle drift.

## Decision
Принят фиксированный C++/Qt стандарт:
- `C++23`, `Qt 6.10+`, `CMake 3.29+`;
- фиксированные компиляторы по платформам;
- `new/delete/malloc/free` запрещены в feature коде;
- обязательный ownership contract через smart pointers + Qt ownership model;
- обязательные sanitizer/static-analysis gates;
- Qt UI flow parity с web/Next design contract;
- обязательный `tools/scripts/check_cpp_limits.sh`.

Канонический регламент:
- `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`

## Consequences
- Резко снижается риск memory-corruption/regression в desktop клиенте.
- AI-generated C++ код становится предсказуемым и проверяемым.
- Возрастает дисциплина и объем обязательных проверок в CI.
