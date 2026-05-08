# 20. C++/Qt Engineering Standard 2026 (Strict Memory Safety)

Этот стандарт обязателен для `apps/desktop/qt`.

## 1) Language and toolchain (fixed)

1. `CPP_STANDARD = C++23`
2. `QT_MAJOR = 6`
3. `QT_MINOR_MIN = 10`
4. `CMAKE_MIN_VERSION = 3.29`
5. `NINJA_REQUIRED = 1`

Primary compilers:
1. `LINUX_PRIMARY = clang++ 18+`
2. `LINUX_SECONDARY = g++ 13+`
3. `WINDOWS_PRIMARY = MSVC 2022 (19.3x+)`
4. `WINDOWS_SECONDARY = clang-cl 18+`
5. `MACOS_PRIMARY = AppleClang (Xcode 15+)`

## 2) Hard memory-safety limits

1. `RAW_NEW_COUNT = 0`
2. `RAW_DELETE_COUNT = 0`
3. `MALLOC_FREE_COUNT = 0`
4. `OWNING_RAW_POINTER_MEMBERS = 0`
5. `UNIQUE_PTR_RELEASE_CALLS = 0`
6. `SHARED_PTR_CYCLE_ALLOWED = 0`
7. `NULL_DEREFERENCE_TOLERANCE = 0`
8. `USE_AFTER_FREE_TOLERANCE = 0`
9. `OUT_OF_BOUNDS_TOLERANCE = 0`
10. `DOUBLE_FREE_TOLERANCE = 0`

## 3) Ownership contract (mandatory)

### 3.1 Non-Qt resources
1. Single owner: `std::unique_ptr<T>`
2. Shared owner: `std::shared_ptr<T>`
3. Cycle break: `std::weak_ptr<T>`
4. Factory creation:
- `std::make_unique<T>() = 100%`
- `std::make_shared<T>() = 100%`

### 3.2 QObject resources
1. QObject lifetime owner by parent tree: `QObject parent-child = primary`
2. Guarded non-owning reference to external QObject: `QPointer<T>`
3. Storing long-lived raw `QObject*` without guard when ownership external: `0`
4. Using `std::shared_ptr<QObject>` as general policy: `0`
5. Combining QObject parent ownership + smart pointer ownership for same object: `0`

### 3.3 Function interface ownership signals
1. Owning return by pointer in new code: `0` (use value/`unique_ptr`)
2. Ownership transfer by raw pointer argument: `0`
3. Non-null pointer contract via `not_null`/reference/asserted precondition: `100%` for non-null required inputs

## 4) Buffer and bounds safety

1. `std::span` for non-owning contiguous ranges: `100%`
2. Raw pointer arithmetic in feature code: `0`
3. C-style arrays in feature code: `0`
4. Bounds-unsafe APIs without guarded wrapper: `0`
5. Unsafe buffer warnings ignored without explicit suppress region: `0`

## 5) C++/Qt file and function limits

1. `MAX_CPP_FILE_LINES = 260`
2. `MAX_HPP_FILE_LINES = 260`
3. `MAX_FUNCTION_LINES = 45`
4. `MAX_METHOD_LINES = 45`
5. `MAX_CLASS_PUBLIC_METHODS = 14`
6. `MAX_NESTING_DEPTH = 3`
7. `MAX_CYCLOMATIC_COMPLEXITY = 10`
8. `MAX_COMMENT_RATIO_PERCENT = 5`
9. `MAX_UNTESTED_CHANGED_FILES = 0`

## 6) Qt UI parity contract with web/Next

Qt desktop UI обязан повторять semantic contract web клиента:
1. `FLOW_PARITY_PERCENT = 100` для `auth` и `switch company`
2. `LIST_FORMAT_VARIANTS = 1`
3. `DESIGN_TOKEN_SOURCE_COUNT = 1` (`packages/tokens/tokens.json`)
4. `TOTAL_PROJECT_COLORS_MAX = 5`
5. `SHADOW_USAGE_COUNT = 0`
6. `BLACK_BORDER_USAGE_COUNT = 0`
7. `ANIMATION_LAYOUT_SHIFT_ALLOWED = 0`
8. `ANIMATION_ALLOWED_PROPERTIES = color, background-color, border-color, opacity`
9. `MAX_ANIMATION_DURATION_MS = 160`

## 7) Sanitizers and static analysis gates

Required debug/profile gates:
1. `ASAN = required`
2. `UBSAN = required`
3. `LSAN = required (where supported)`
4. `TSAN = required for multi-threaded critical modules`
5. `CLANG_TIDY = required`
6. `CLANG_STATIC_ANALYZER = required`

Required pass rate:
1. `SANITIZER_PASS_RATE = 100%`
2. `STATIC_ANALYSIS_PASS_RATE = 100%`
3. `CPP_LIMITS_CHECK_PASS_RATE = 100%`

## 8) Mandatory clang-tidy profile (minimum)

1. `cppcoreguidelines-*`
2. `modernize-*`
3. `bugprone-*`
4. `performance-*`
5. `readability-*`
6. `clang-analyzer-*`
7. `hicpp-*`

## 9) AI-generated C++/Qt code profile (strict)

Для генерации кода агентами обязательно:
1. `CMAKE_EXPORT_COMPILE_COMMANDS = ON`
2. `CMakePresets.json` usage = `100%`
3. `clangd` project integration = `100%`
4. `prompt-to-code checklist coverage = 100%`
5. `template-first generation = 100%`

Generation checklist (hard):
1. Ownership model selected before code generation: `1`
2. Raw pointer ownership paths generated: `0`
3. `new/delete` emitted by generator: `0`
4. QObject lifetime plan declared (`parent` or guarded observer): `1`
5. Tests generated with code: `>= 1` unit and `>= 1` integration scenario per changed module
6. UI parity checklist vs web flow: `100%`

## 10) Build flags baseline

Linux/macOS (Clang):
1. `-Wall`
2. `-Wextra`
3. `-Wpedantic`
4. `-Wconversion`
5. `-Wsign-conversion`
6. `-Wshadow`
7. `-Wnon-virtual-dtor`
8. `-Wold-style-cast`
9. `-Werror`

MSVC:
1. `/W4`
2. `/permissive-`
3. `/WX`
4. `/analyze` (for dedicated analysis builds)

## 11) Merge gate

Фича не принимается при любом нарушении:
1. Любой лимит из разделов `1-10`: `> 0`
2. Любая sanitizer/static-analysis ошибка: `> 0`
3. Любой ownership ambiguity в коде: `> 0`
4. Любой UI parity drift с web flow: `> 0`

## 12) Automated checks

1. `tools/scripts/check_cpp_limits.sh apps/desktop/qt`
2. Допустимое число нарушений: `0`
3. Код возврата при нарушениях: `1`

## 13) Related docs

1. `docs/08-UI-CROSS-PLATFORM-RULES.md`
2. `docs/09-PLATFORM-UI-STACKS.md`
3. `docs/10-DESIGN-TOKENS-BUILD-PIPELINE.md`
4. `docs/17-TESTING-TDD-QUALITY-GATES.md`
5. `docs/19-NEXT-NODE-FRONTEND-STANDARD.md`
6. `docs/99-REFERENCES.md`
