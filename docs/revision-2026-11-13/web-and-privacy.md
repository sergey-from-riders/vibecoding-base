# Новые правила SEO и персональных данных

> Исторический отчет подготовки присланной редакции. Указанные здесь доступы, окружение, отсутствие публикации и результаты запусков относятся к тому этапу. Дополнительные исправления и проверки при принятии: [интеграционное ревью](../integration-review-2026-11-13.md).

13 ноября 2026 года. Добавлены 17 правил SEO и приемки публичного сайта и 14 правил обработки персональных данных для РФ. Новые статьи не имеют выдуманной даты первой публикации.

## Первичные источники и границы

SEO-положения проверены по Google Search Central, Google Crawling Infrastructure, web.dev, W3C и RFC 9110. Число H1, бюджет ресурсов и состав релизной матрицы явно отделены от требований поисковой системы. Показ favicon, title и расширенного результата не гарантируется разметкой.

Правовые положения сверены с текстами статей 5, 6, 9, 10.1, 12, 14, 18, 18.1, 20, 21 и 22 закона № 152-ФЗ и статьи 18 закона № 38-ФЗ. Использована доступная консолидированная редакция 152-ФЗ от 26.07.2026; будущие, не вступившие в силу редакции не применялись. Официальная публикация Минтруда использована для сопоставления, но ее дата обновления не подменяет проверку конкретной действующей статьи. Письмо Минцифры от 12.05.2025 № П25-44929 обозначено как разъяснение, а не нормативный акт.

Правила описывают инженерные и организационные критерии. Они не являются готовой политикой конкретного оператора, текстом согласия на все случаи или подтверждением юридического соответствия eval.su.

## Принятые уточнения

| ID | Нормативный текст | Проверяемый результат |
| --- | --- | --- |
| `seo.page-titles` | [Открыть](../../registry/standards/seo/site-audit/rules/page-titles.md) | Проверьте исходный и итоговый HTML главной, категории, карточки, статьи, пагинации и 404. |
| `seo.heading-structure` | [Открыть](../../registry/standards/seo/site-audit/rules/heading-structure.md) | Проверьте число основных H1 и дерево заголовков на каждом типе страницы. |
| `seo.meta-description` | [Открыть](../../registry/standards/seo/site-audit/rules/meta-description.md) | Проверьте description в итоговом HTML и после смены маршрута. |
| `seo.favicon` | [Открыть](../../registry/standards/seo/site-audit/rules/favicon.md) | Запросите URL без пользовательской сессии, проверьте HTTP-статус, MIME, декодирование и квадратные размеры. |
| `seo.indexability` | [Открыть](../../registry/standards/seo/site-audit/rules/indexability.md) | Проверьте матрицу по реальным HTTP-ответам и итоговому HTML, включая robots.txt и заголовки CDN. |
| `seo.canonical-urls` | [Открыть](../../registry/standards/seo/site-audit/rules/canonical-urls.md) | Проверьте чистый URL, tracking-параметры, другой домен/протокол, локаль и вторую страницу каталога. |
| `seo.status-redirects` | [Открыть](../../registry/standards/seo/site-audit/rules/status-redirects.md) | Запросите известный, случайный, удаленный и перенесенный URL, включая trailing slash и HTTPS. |
| `seo.sitemaps` | [Открыть](../../registry/standards/seo/site-audit/rules/sitemaps.md) | Распарсите XML, проверьте лимиты, дубли, доступность и статусы выборки URL. |
| `seo.crawlable-links` | [Открыть](../../registry/standards/seo/site-audit/rules/crawlable-links.md) | Обойдите сайт от главной и сравните достижимые URL с индексируемым набором. |
| `seo.rendered-content` | [Открыть](../../registry/standards/seo/site-audit/rules/rendered-content.md) | Сравните исходный ответ, DOM после рендеринга и проверку URL целевой поисковой системы. |
| `seo.images` | [Открыть](../../registry/standards/seo/site-audit/rules/images.md) | Проверьте URL, MIME, загрузку на мобильном устройстве, alt и отсутствие лишнего скачивания оригиналов. |
| `seo.structured-data` | [Открыть](../../registry/standards/seo/site-audit/rules/structured-data.md) | Проверьте JSON и применимый Rich Results Test, затем вручную сопоставьте поля с содержанием. |
| `seo.pagination-facets` | [Открыть](../../registry/standards/seo/site-audit/rules/pagination-facets.md) | Обойдите каталог без scroll/click-обработчиков и подтвердите достижимость всех нужных объектов. |
| `seo.multilingual` | [Открыть](../../registry/standards/seo/site-audit/rules/multilingual.md) | Проверьте пары страниц, обратные ссылки, статусы и фактический язык содержания. |
| `seo.performance` | [Открыть](../../registry/standards/seo/site-audit/rules/performance.md) | Сохраните конфигурацию и результаты измерений главной, категории, карточки и формы. |
| `seo.mobile-content` | [Открыть](../../registry/standards/seo/site-audit/rules/mobile-content.md) | Проверьте реальный мобильный браузер и HTML, получаемый мобильным роботом. |
| `seo.release-audit` | [Открыть](../../registry/standards/seo/site-audit/rules/release-audit.md) | Покажите заполненную матрицу с конкретными URL, а не пустой шаблон. |
| `legal-ru.processing-basis` | [Открыть](../../registry/standards/legal/russia-web/rules/processing-basis.md) | Сверьте все публичные формы, API и виджеты с матрицей целей и оснований. |
| `legal-ru.privacy-policy` | [Открыть](../../registry/standards/legal/russia-web/rules/privacy-policy.md) | Откройте каждую форму без сессии и клавиатурой; проверьте ссылку, реквизиты и читаемость. |
| `legal-ru.separate-consent` | [Открыть](../../registry/standards/legal/russia-web/rules/separate-consent.md) | Проверьте отправку без отметки, подмену версии текста и отключенный JavaScript; сервер не создает согласие автоматически. |
| `legal-ru.consent-evidence` | [Открыть](../../registry/standards/legal/russia-web/rules/consent-evidence.md) | Восстановите текст и событие для тестового согласия после обновления формы. |
| `legal-ru.marketing-consent` | [Открыть](../../registry/standards/legal/russia-web/rules/marketing-consent.md) | Создайте заявку без рекламы: заявка обрабатывается, рекламный контакт не активируется. |
| `legal-ru.cookies-trackers` | [Открыть](../../registry/standards/legal/russia-web/rules/cookies-trackers.md) | В чистом профиле запишите Network до выбора, после отказа, после согласия и после отзыва. |
| `legal-ru.localization` | [Открыть](../../registry/standards/legal/russia-web/rules/localization.md) | Проследите тестовую заявку от браузера до всех получателей и хранилищ; сопоставьте с договорами и конфигурацией регионов. |
| `legal-ru.cross-border` | [Открыть](../../registry/standards/legal/russia-web/rules/cross-border.md) | Сверьте Network, серверные исходящие запросы и доступ поддержки со списком получателей. |
| `legal-ru.processors` | [Открыть](../../registry/standards/legal/russia-web/rules/processors.md) | Сопоставьте договорный перечень с реальными интеграциями, полями и доступом. |
| `legal-ru.operator-notification` | [Открыть](../../registry/standards/legal/russia-web/rules/operator-notification.md) | Сверьте новую форму или SDK с действующими документами и уведомлениями. |
| `legal-ru.retention` | [Открыть](../../registry/standards/legal/russia-web/rules/retention.md) | Отправьте форму без необязательных полей и проверьте все получатели. |
| `legal-ru.subject-requests` | [Открыть](../../registry/standards/legal/russia-web/rules/subject-requests.md) | Пройдите запрос доступа, исправления и отзыва от тестового субъекта; проверьте сроки, идентификацию и ответ. |
| `legal-ru.public-distribution` | [Открыть](../../registry/standards/legal/russia-web/rules/public-distribution.md) | Проверьте опубликованный объект, исходный HTML, JSON API, изображения и экспорт без авторизации. |
| `legal-ru.incidents` | [Открыть](../../registry/standards/legal/russia-web/rules/incidents.md) | Проведите настольный сценарий с инцидентом ночью/в выходной и проверьте возможность соблюсти сроки. |

## Проверка примеров

JSON-LD проверяется как JSON, sitemap как XML, HTML — как ограниченные фрагменты. Примеры с доменом example.com и условными данными не утверждают наличие этих страниц или документов в production. Пример отдельного согласия требует реального текста оператора и серверной проверки; его нельзя публиковать как универсальный юридический документ.

Полевые метрики, состояние индекса, реальная отправка форм, согласий и cookies в eval.su не проверялись как реализация этих новых правил: исходники и канал deployment сайта недоступны.

## Дополнительное независимое ревью

Прочитаны все 31 новая статья. В `legal-ru.public-distribution` добавлен срок публикации сведений об условиях обработки, запретах и условиях по части 10 статьи 10.1 — не позднее трех рабочих дней после получения соответствующего согласия. В `seo.pagination-facets` для выбранного профиля обхода Google явно заданы 404 на исходном URL для пустых/некорректных фасетов и несуществующей пагинации, с отдельной оговоркой об обычном внутреннем поиске. JSON-LD BreadcrumbList исправлен на два упорядоченных элемента. Эти изменения включены в правила и приемку.
