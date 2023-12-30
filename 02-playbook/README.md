# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
adm2@srv1:~/downloads/playbook$ sudo ansible-lint site.yml
Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
adm2@srv1:~/downloads/playbook$ ansible-playbook --check site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
skipping: [clickhouse-01] => (item=clickhouse-common-static) 

TASK [Get clickhouse-common-static distrib] ***********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************
failed: [clickhouse-01] (item=clickhouse-client) => {"ansible_loop_var": "item", "changed": false, "item": "clickhouse-client", "msg": "No RPM file matching 'clickhouse-client-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-client-22.3.3.44.rpm' found on system"]}
failed: [clickhouse-01] (item=clickhouse-server) => {"ansible_loop_var": "item", "changed": false, "item": "clickhouse-server", "msg": "No RPM file matching 'clickhouse-server-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-server-22.3.3.44.rpm' found on system"]}
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "item": "clickhouse-common-static", "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ********************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
adm2@srv1:~/downloads/playbook$ ansible-playbook --diff site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
skipping: [clickhouse-01] => (item=clickhouse-common-static) 

TASK [Get clickhouse-common-static distrib] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Flush handlers] *********************************************************************************************************************************************************************

TASK [Create database] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************************************************
ok: [vector-01]

TASK [Replace vector.yaml] ****************************************************************************************************************************************************************
--- before: /etc/vector/vector.yaml
+++ after: /home/adm2/.ansible/tmp/ansible-local-421482cnz0ad0i/tmpzdady1cx/vector.yaml
@@ -42,6 +42,6 @@
 # Vector's GraphQL API (disabled by default)
 # Uncomment to try it out with the `vector top` command or
 # in your browser at http://localhost:8686
-# api:
+# api: test
 #   enabled: true
 #   address: "127.0.0.1:8686"

changed: [vector-01]

RUNNING HANDLER [Start vector service] ****************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP ********************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
adm2@srv1:~/downloads/playbook$ ansible-playbook --diff site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
skipping: [clickhouse-01] => (item=clickhouse-common-static) 

TASK [Get clickhouse-common-static distrib] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ********************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Flush handlers] *********************************************************************************************************************************************************************

TASK [Create database] ********************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] *********************************************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install vector packages] ************************************************************************************************************************************************************
ok: [vector-01]

TASK [Replace vector.yaml] ****************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP ********************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
