# apps/desktop/qt

Qt 6 native desktop client (macOS/Windows/Linux).

## Scope
- auth
- switch active company

## Mandatory engineering contract
- `docs/20-CPP-QT-MEMORY-SAFETY-STANDARD.md`
- `docs/19-REACT-NODE-FRONTEND-STANDARD.md`
- `docs/08-UI-CROSS-PLATFORM-RULES.md`
- `docs/17-TESTING-TDD-QUALITY-GATES.md`

## Fixed baseline
1. `C++23`
2. `Qt 6.10+`
3. `CMake 3.29+`
4. `Clang 18+ / MSVC 2022 / AppleClang Xcode 15+`

## Hard memory-safety policy
1. `RAW_NEW_COUNT = 0`
2. `RAW_DELETE_COUNT = 0`
3. `MALLOC_FREE_COUNT = 0`
4. `OWNING_RAW_POINTER_MEMBERS = 0`
5. `QPointer` for guarded QObject observers
6. `std::unique_ptr`/`std::shared_ptr`/`std::weak_ptr` by ownership contract
