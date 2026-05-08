# Skill: auth-company-feature

## Когда использовать
- изменения login/register/session;
- изменения oauth/social login;
- изменения deep link/native exchange;
- изменения long-lived device restore;
- изменения переключения компании;
- изменения модели прав membership.

## Процедура
1. Прочитать и синхронизировать контракты:
- `docs/05-AUTH-COMPANY-SWITCH.md`
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md`
2. Зафиксировать API payload/response.
3. Проверить security инварианты:
- hash-only tokens/passwords;
- session TTL/revocation;
- session list + revoke one + revoke others;
- OAuth state/PKCE validation для web/native auth;
- device credential rotation/revoke/expiry;
- membership check на switch.
4. Проверить data integrity:
- корректность `current_company_id`;
- корректность `auth_identities` связей (`provider` + `provider_subject`);
- fk/indexes не деградировали.
5. Обновить тесты:
- happy path;
- unauthorized;
- expired session;
- revoked other session;
- revoke all except current;
- deep link exchange invalid `state`/`code_verifier`;
- foreign company access.
6. Обновить документацию:
- `docs/05-AUTH-COMPANY-SWITCH.md`
- `docs/16-UNIFIED-AUTH-SESSION-ARCHITECTURE.md` (если меняется архитектурный контракт)

## DoD
- поведение подтверждено тестами;
- security инварианты соблюдены;
- contract drift отсутствует.
