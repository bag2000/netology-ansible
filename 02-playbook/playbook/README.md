##  Проект ClickHouse и Vector Ansible-Playbook
Репозиторий [ClickHouse](https://clickhouse.com) и [Vector](https://vector.dev) Ansible-Playbook

### Требования
  
**Control node**  
  
- Ansible 2.15.6+  
- Python 3.10.12+  
- Jinja 3.1.2+  
  
**Managed nodes**  
- Операционная система CentOS  
  
### Конфигурация

**Clickhouse**  
group_vars/clickhouse/vars.yml:  
- clickhouse_version: версия clickhouse  
- clickhouse_packages: пакеты для установки  

**Vector**  
group_vars/vector/vars.yml:  
- vector_version: версия vector  
  
Конфигурационный файл vector расположен в templates/vector.yaml. При установке копируется в /etc/vector/vector.yaml  

**Хосты для установки**
inventory/prod.yml  
В группе clickhouse должны находиться серверы ClickHouse.  
В группе vector должны находиться серверы Vector.  

### Установка

ansible-playbook site.yml -i inventory/prod.yml