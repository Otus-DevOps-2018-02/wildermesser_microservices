# wildermesser_microservices
# Docker
## Базовые вещи
Запущены контейнеры hello-world и ubuntu:16.04 командо `docker run`. Содержимое одного контейнера изменено, повторный запуск команды создаёт новый контейнер без внесённых изменений. Изменения сохранены в образе командой `docker commit`. Проверн запуск команды внутри контейнера с помощью `docker exec`. Остановлены и удалены все используемые контейнеры. Удалены все образы.
## Изоляция
По умолчанию контейнеры максимально изолированы от хостовой системы. Однако, в случае необходимости доступа к каким-то ресурсам хоста, можно выключить какой-либо механизм изоляции: pid, net, user. Например, опция `--pid` позволяет в контейнере увидеть процессы хоста
## Docker-machine
Предоставляет удобный способ использования удалённого демона docker для локального управления и запуска контейнеров. После настройки достаточно в текущем терминале выполнить `eval $(docker-machine env docker-host)` и пользоваться Docker как-будто он установлен локально.
## Dockerfile
Позволяет описать в файле построение нового Docker образа. Должен базироваться на каком-то созданном заранее образе. Затем должна быть задана последовательность команд, выполняемых для построения образа. После выполнения каждой команды создаётся новый слой, чтобы проще было переиспользовать. Это повдение можно отключить. В образ можно копировать локальные или удалённые файлы. Так же обязательно задать команду, которая будет выполняться при старте контейнера и получил PID=1.
## Docker hub
Публичный registry образов Docker. Можно добавлять свои образы и затем использовать в проектах.
## Оптимизация dockerfile
- Взять за основу минимальй образ типа apline
- Все наиболее часто изменяемые сущности указывать как можно ниже в Dockerfile
- Очищать контейнер от временных данные сборки
- Использовать multi-stage
## Взаимосвязь контейнеров
Чтобы контейнеры могли обмениваться данным по сети, необхоимо создать сеть командой `docker network`, затем использовать эту сеть при запуске контейнеров. Аналогом DNS имён являются `network aliases`. Каждый контейнер может иметь их несколько. Удобно на эти имена внутри контейнера ссылатья через переменные окружения. Их можно будет изменить с помощью опции `-e`.
## Сети в Docker
При старте контейнера можно задать используемую сеть. Существует несколко типов сетей:
- none
- host
- bridge
- MACVLAN
- overlay
У каждой существут свои настройки, bridge по улмолчанию. В brigde можно использовать встроенный Serice Discovery. По умолчанию создаётся запись в DNS с именем контейнера и ip адресом. Также можно использовать aliases для задания дополнительных имён внутри одной bridge сети. При старте контейнера можно укзатаь только одну сеть, поэтому присоединение к дополнительной сети осуществляется командой `docker network connect`
## Docker-compose
Позволяет в yaml файле описать запуск одного или более контейнера. А так же описать используемые сети и volumes. Поддерживает переменные окружения для дополнительной параметризации. По умолчанию значения переменных берутся из `.env` файла. Задание базового имени проекта, на основе которого называются остальные сущности, такие как контейнеры, сети и т.д. осуществляется через параметр `-p` или переменную окружения `COMPOSE_PROJECT_NAME`
## Docker-compose override
Возможно переопределить часть кода из docker-compose файла и в момен запуска "слить" эти данные. По умолчанию берётся файл docker-compose.override.yml, однако можно указать свой через опцию `-f`. В том числе таких файлов может быть несколько. Актуальными становятся данные, определённый в последнем файле при конфликте.
Чтобы дать возможность редактировать данные в запущеном контейнере, можно создать новый `volume` указав на нужную директорию внутри контейнера. В такмо случае при старте содержимое данной директории будет скопировано в папку volume'a (по умолчанию `/var/lib/docker/volumes/имя_volume`), а затем эта директория будет примонтирована в контейнер.
# Gitlab CI
## Общее
Комбайн, сочетающий в себе большое количество иструментов для разработки ПО:
- git repo
- CI/CD
- issue tracker
- chat
- хранилище артефактов
- и т.д.
Может использоваться как сервис или быть установленным на собственные можности. Существует несколько редакций, в том числе беслпатная open souce. Для простоты испльзования существует omnibus пакет, содержащий все зависимости.
## CI/CD
Задаётся в виде yaml файла `.gitlab-ci.yml`. Весь процесс разделён на стадии `stages`. Каждая стадия может иметь несколько задач `jobs`, которые выполняются параллельно. Стадии выполняются последовательно. Выполнение производится процессами `giltab-runner`, которые управляют процессами `executors`. Они бывают различных видов:
- Shell
- Docker
- Docker Machine and Docker Machine SSH (autoscaling)
- Parallels
- VirtualBox
- SSH
- Kubernetes
Runners бывают общими или приватными. Первые могут быть использованы в различных проектах, вторые только в одном. Runner'ам могут быть заданы теги, по которым можеть быть определена возможность запуска pipline на этом runner.
## Автоматическое развёртывание и регистрация runner'ов
### Вариант 1
Если для запуска runners используется инфраструктура, поддерживаемая docker-machine (https://docs.docker.com/machine/drivers/), оптимальным вариантом мне видится следующий:
1. Создаётся руками простой runner (возможно даже на хосте с самим gitlab), который использует docker-machine executor
2. Задаются необходимые параметры количества запускаемых runners
Плюсом такого подхода является динамическое количество runners. Минусом - runners будут создаваться одинаковые. Соответственно, если требуются различные среды linux, windows и т.д., придётся создавать несколько простых управляющих runners.
Очень полезным при таком подходе будет создание общего кэша для создаваемых runners. Иначе создаваемые при каждом запуске runners будут постоянно скачивать требуемые docker образы. Особенно это важно при использовании публичных или сторонних docker registry.
### Вариант 2
Если первый вариант не подходит по каким-то причинам, тогда остаётся вариант создания runners средствами ansible. В ansible роли описывается установка бинарника `gitlab-runner` и регистрация его на сервере gitlab. Необходимые параметры должны задаваться через host_vars/group_vars.
Основная проблема, которая мешает максимально автоматизировать этот процесс - необходимость передавать registration token при регистрации агента. В настоящее время официально получить это токен можно только из веб-интерфейса проекта/админского интефейса. Логичным способом получения этого токена был бы запрос к API, однако судя по окрытому Feature Request (https://gitlab.com/gitlab-org/gitlab-ce/issues/24030) пока данная функциональность не реализована.
## Окружения в Gitlab
### Статические окружения
В `.gitlab-ci.yml` можно описать не только этапы, но и обозначить окружения, на которые осуществляется выкатка кода. Возможно задать фильтры по наличию/отсутствию тегов git или на определённые ветки. В дальнешем на созданные окружения можно выкатывать код через веб-интерфейс и видеть всю историю.
### Динамические окружения
Окружения так же могу быть динамическими. Для этого необходимо описать две задачи: для создания окружени и для его остановки.
В данном репозитории используется платформа GCP для создания динамических окружений.
Вся создаваемая инфраструктура описана в виде кода в директории `infra`. С помощью terraform создаётся новый инстанс, задаются правила firewall и регистрируется имя в DNS. Так как данные текущего состояния terraform необходимо хранить между запусками конвейера, используется bucket в облачном хранилище GCP.
### Использование docker для deploy
В данном репозитории приложение из директории `reddit` упаковывается в docker образ на основе `Dockerfile`. Затем данный образ экспортируется в публичный docker registry. Тестирование выполняется уже на основе собранного образа. На созданное динамическое окружение копируется файл `infra/docker/docker-compose.yml`, с помощью которого запускается контейнер приложения с доступом к контейнеру с mongodb. Подготовка инстанса с возможностью запуска docker контейнеров осуществяется через terraform provision скриптом `infra/terraform/install-docker.sh`. Для того, чтобы на docker executor можно было собирать образы docker, используется немного дополненный образ docker-in-docker. Дополнения описаны в `infra/docker/Dockerfile` и заключаютя в установке ssh клиента и terraform.
### Секреты и url динамического окружения
Переменные, содержащие приватные данные, задаются на уровне проекта или группы. В данном случае там хранятся: приватный ключ доступа к GCP, приватный ключ для доступа по ssh к создаваемому инстансу и пароль к docker registry.  
Судя по открытому issue (https://gitlab.com/gitlab-org/gitlab-ce/issues/27424), генерируемый url окружения может использовать только встроенные в gitlab переменные `CI_*`. Этот url можно менять через API, однако это не соответствует концепции IaaC и требует дополнительных проверок для корректной работы. В данном репозитории используется следующий подход.  
Url окружения генерируется на основе базового DNS суффикса плюс $CI_ENVIRONMENT_SLUG. Соответствующая запись в DNS создаётся средствами terraform.
# Мониторинг
## Prometheus
Prometheus представляет собой сборщик метрик и TSDB. Пристуствует простой web интефейс с возможностью строить графики. Работает по push модели, то есть проходит по endpoint'ам, описанным в файле конфигурации для конкретной задачи и собирает метрики запросом по протоколу http. Собранные метрики храняться в TSDB указанное в конфигурации время. Метрики помимо названия содержат ещё мекти (labels) несущие дополнительную информацию помимо значения самой метрики.
## Expoters
Если приложение не умеет отадвать метрики в нужном виде, можно использовать prometheus exporter. Это дополнительное ПО, которое собирает метрики с нужного сервиса и отдаёт в нужном для prometheus виде. В данном проекте используеются node-exporter и percona-mongodb-exporter для предоставления метрик хоста, на котором запущен prometheus, и mongodb соответственно. Если требуется посмотреть на приложение снаружи, то можно использовать balckbox exporter, который запускает проверки на ping, соединение по порту и т.д. и отдаёт эти метрики prometheus. В данном проекте используется cloudporber для снятия метрик доступности прилоежние на порту 9292.
## Запуск проекта
Запуск проекта осуществляется с помощью docker-compose. Все используемые образы эспотированы в https://hub.docker.com/u/wildermesser/. Для удобства сборки и экспорта написан `Makefile`. Команда `make имя_образа` собирает нужные образ, команда `make push-имя_образа` эспортирует собранный образ. `make` без параметров собирает все образы, `make push` экспортирует все образы.
