### Project 01

### Deploy a Database Server with Backup Automation

**Objective**: Automate the deployment and configuration of a PostgreSQL database server on an Ubuntu instance hosted on AWS, and set up regular backups.

#### Problem Statement

**Objective**: Automate the deployment, configuration, and backup of a PostgreSQL database server on an Ubuntu instance using Ansible.


#### Requirements:

**1. AWS Ubuntu Instance**: You have an Ubuntu server instance running on AWS. 

**2. Database Server Deployment**: Deploy and configure PostgreSQL on the Ubuntu instance.

**3. Database Initialization**: Create a database and a user with specific permissions.

**4.Backup Automation**: Set up a cron job for regular database backups and ensure that backups are stored in a specified directory.

**5. Configuration Management**: Use Ansible to handle the deployment and configuration, including managing sensitive data like database passwords.

### Deliverables

#### 1. Ansible Inventory File
+ **Filename**: inventory.ini
+ **Content**: Defines the AWS Ubuntu instance and connection details for Ansible.

```ini
[group1]
target02 ansible_host=3.1xx.xxx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/Downloads/ookk.pem
```
![alt text](<images/Screenshot from 2024-07-31 16-24-45.png>)
---


#### 2. Ansible Playbook
+ **Filename**: deploy_database.yml
+ **Content**: Automates the installation of PostgreSQL, sets up the database, creates a user, and configures a cron job for backups. It also includes variables for database configuration and backup settings.

```yaml
---
- name: Task-17
  hosts: target02
  become: yes
  vars:
    new_user: "amaan"
    new_pass: "password"
    dbname: new_db
  tasks:
  - name: Install MySQL server
    apt:
      update_cache: yes
      name: "{{ item }}"
      state: present
    with_items:
      - mysql-server
      - mysql-client 
      - python3-mysqldb 
      - libmysqlclient-dev

  - name: Copy MySQL configuration file
    template:
      src: mysql.cnf.j2
      dest: /etc/mysql/mysql.conf.d/mysqld.cnf
    notify: Restart MySQL

  - name: Ensure MySQL service is running and enabled
    service:
      name: mysql
      state: started
      enabled: yes

  - name: Creating MySQL user
    mysql_user:
      name: "{{ new_user }}"
      password: "{{ new_pass }}"
      priv: '*.*:ALL'
      host: '%'
      state: present

  - name: Create MySQL database
    mysql_db:
      name: "{{ dbname }}"
      state: present

  - name: Copy the script
    ansible.builtin.copy:
      src: "/home/einfochips/training_day-17/project-1/backup.sh"
      dest: "/home/ubuntu/backup.sh"
      mode: '755'

  - name: Set up cron job for MySQL backup
    cron:
      name: "Database backup"
      minute: "0"
      hour: "2"
      job: "/home/ubuntu/backup.sh"

  handlers:
  - name: Restart MySQL
    service:
      name: mysql
      state: restarted
```


#### 3. Jinja2 Template
+ **Filename**: templates/pg_hba.conf.j2
+ **Content**: Defines the PostgreSQL configuration file (pg_hba.conf) using Jinja2 templates to manage access controls dynamically.

```
# Here is entries for some specific programs
# The following values assume you have at least 32M ram

!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
```


#### 4. Backup Script
+ **Filename**: scripts/backup.sh
+ **Content**: A script to perform the backup of the PostgreSQL database. This script should be referenced in the cron job defined in the playbook.

```sh
#!/bin/bash

BACKUP_DIR=/var/backups/mysql
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="${BACKUP_DIR}/mysql_backup_${DATE}.sql"

mysqldump -u amaan -p${new_pass} ${dbname} > ${BACKUP_FILE}
gzip ${BACKUP_FILE}
```

+ ### OutPut
![alt text](<images/Screenshot from 2024-08-01 15-03-11.png>)
---

+ #### Database Created
![alt text](<images/Screenshot from 2024-08-01 19-08-46.png>)
---


### Project 02

**Objective**: Automate the setup of a multi-tier web application stack with separate database and application servers using Ansible.

#### Problem Statement

**Objective**: Automate the deployment and configuration of a multi-tier web application stack consisting of:
**1. Database Server**: Set up a PostgreSQL database server on one Ubuntu instance.

**2. Application Server**: Set up a web server (e.g., Apache or Nginx) on another Ubuntu instance to host a web application.

**3. Application Deployment**: Ensure the web application is deployed on the application server and is configured to connect to the PostgreSQL database on the database server.

**4. Configuration Management**: Use Ansible to automate the configuration of both servers, including the initialization of the database and the deployment of the web application.


### Deliverables
#### 1. Ansible Inventory File

+ **Filename**: inventory.ini
+ **Content**: Defines the database server and application server instances, including their IP addresses and connection details.

```ini
[group2]
target03 ansible_host=13.2xx.xxx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/Downloads/ookk.pem
```


#### 2. Ansible Playbook

+ **Filename**: deploy_multitier_stack.yml
+ **Content**: Automates:
    - The deployment and configuration of the PostgreSQL database server.
    - The setup and configuration of the web server.
    - The deployment of the web application and its configuration to connect to the database.

```yaml
---
- name: Configure Web Application Server
  hosts: target03
  become: yes
  tasks:
    - name: Install nginx server
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Ensure Nginx is running and enabled
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy index.html
      copy:
        src: index.html
        dest: /var/www/html/index.html

    - name: Deploy app conf file
      template:
        src: app_config.php.j2
        dest: /var/www/html/app_config.php

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```
![alt text](<images/Screenshot from 2024-08-01 18-26-17.png>)


#### 3. Jinja2 Template

+ **Filename**: templates/app_config.php.j2
+ **Content**: Defines a configuration file for the web application that includes placeholders for dynamic values such as database connection details.

```
<?php
// Database configuration
define('DB_HOST', '3.1xx.1xx.xxx');
define('DB_NAME', 'new_db');
define('DB_USER', 'amaan');
define('DB_PASSWORD', 'password');

// Create connection
$conn = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
```


#### 4. Application Files

+ **Filename**: index.html (or equivalent application files)
+ **Content**: Static or basic dynamic content served by the web application.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello From My Web Application</title>
</head>
<body>
    <h1>Welcome to My Web Application</h1>
    <p>This is a simple web application deployed using Ansible.</p>
</body>
</html>
```
![alt text](<images/Screenshot from 2024-08-01 18-53-16.png>)
---