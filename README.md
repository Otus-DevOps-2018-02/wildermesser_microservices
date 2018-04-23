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
