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
Основная проблема, которая мешает максимально автоматизировать этот процесс - необходимость передавать registration token при регистрации агента. В настоящее время офицыально получить это токен можно только из веб-интерфейса проекта/админского интефейса. Логичным способом получения этого токена был бы запрос к API, однако судя по окрытому Feature Request (https://gitlab.com/gitlab-org/gitlab-ce/issues/24030) пока данная функциональность не реализована.
