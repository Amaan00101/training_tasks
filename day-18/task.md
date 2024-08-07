## Ansible Three-Tier Web Application Deployment

## Overview

This project automates the deployment of a three-tier web application using Ansible. The application consists of:

1. **Frontend:** Nginx web server
2. **Backend:** Node.js application
3. **Database:** MySQL server

The deployment is managed through Ansible roles, including roles from Ansible Galaxy and custom roles as needed. The project ensures that all components are configured correctly and can communicate with each other.

## Project Structure

The directory structure is organized as follows:

```
ansible_project/
├── roles/
│   ├── frontend/
│   ├── backend/
│   └── database/
├── playbooks/
│   ├── deploy.yml
│   └── test.yml
├── inventory/
│   └── hosts
├── group_vars/
│   └── all.yml
└── README.md
```

- **roles/**: Contains Ansible roles for Nginx, Node.js, and MySQL.
- **playbooks/**: Contains playbooks for deployment and testing.
- **inventory/**: Contains inventory files defining host groups.
- **group_vars/**: Contains variable files for different environments.

## Prerequisites

1. **Ansible**: Ensure Ansible is installed on your control node. You can install it using pip:

```bash
pip install ansible
```

2. **Ansible Galaxy Roles**: The project uses roles from Ansible Galaxy. Ensure you have the necessary roles installed. You can install them using:

```bash
ansible-galaxy install -r requirements.yml
```

3. **Inventory File**: Update the `inventory/hosts` file with the IP addresses or hostnames of your servers.

```ini
[group]
alias-name ansible_host=xx.xx.xx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/key
```

## Setup

#### 1. Ansible Project Directory Structure
+ Organized directory structure with roles, playbooks, inventory, and configuration files.
```
ansible-galaxy init roles/frontend
ansible-galaxy init roles/database
ansible-galaxy init roles/backend
```
![alt text](<images/Screenshot from 2024-08-05 17-24-36.png>)

![alt text](<images/Screenshot from 2024-08-06 16-57-16.png>)
---


#### 2. Role Definitions and Dependencies
+ meta/ main.yml files for each role defining dependencies.
+ Customized roles with necessary configurations.

+ update roles/frontend/tasks/mail.yaml and dependencis
```yaml
---
- name: Instal nginx
  apt: 
    name: nginx
    state: present
  become: yes

- name: Ensure Nginx is running
  service:
    name: nginx
    state: started
    enabled: yes
  become: yes
  notify: Restart Nginx

- name: Deploy app file
  copy:
    src: index.html
    dest: /var/www/html/index.html

- name: Deploy Nginx configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  become: yes
```

+ update roles/database/tasks/mail.yaml and dependencis
```yaml
---
- name: Install MySQL server
  ansible.builtin.apt:
    update_cache: yes
    name: "{{ item }}"
    state: present
  with_items:
    - mysql-server
    - mysql-client 
    - python3-mysqldb 
    - libmysqlclient-dev
  become: yes

- name: Copy MySQL configuration file
  template:
    src: mysql.cnf.j2
    dest: /etc/mysql/mysql.conf.d/mysqld.cnf
  become: yes
  notify: Restart MySQL

- name: Ensure MySQL service is running and enabled
  service:
    name: mysql
    state: started
    enabled: yes
  become: yes

- name: Creating MySQL user
  mysql_user:
    name: "{{ new_user }}"
    password: "{{ new_pass }}"
    priv: '*.*:ALL'
    host: '%'
    state: present
  become: yes

- name: Create MySQL database
  mysql_db:
    name: "{{ dbname }}"
    state: present
  become: yes
```

+ update roles/backend/tasks/mail.yaml and dependencis
```yaml
- name: Install Node.js
  apt:
    name: 
      - nodejs
      - npm
    state: present
  become: yes

- name: Create application directory
  file:
    path: /var/www/app
    state: directory
  become: yes

- name: Deploy Node.js application
  copy:
    src: files/
    dest: /var/www/app/
    mode: '0755'
  become: yes

- name: Install npm dependencies
  npm:
    path: /var/www/app
    production: yes
  become: yes

- name: Start the Node.js application in the background
  shell: nohup node /var/www/app/* > /var/www/app/nohup.out 2>&1 &
  args:
    chdir: /var/www/app
  become: yes
```


#### 3. Inventory File
+ Inventory file defining groups and hosts for frontend, backend, and database tiers.

```ini
[frontend]
frontend02 ansible_host=6x.xx.xx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/Downloads/ansible-worker.pem

[backend]
backend02 ansible_host=6x.xx.xx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/Downloads/ansible-worker.pem

[database]
database02 ansible_host=6x.2x.xx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/Downloads/ansible-worker.pem
```


#### 4. Playbook for Deployment
+ Playbook that orchestrates the deployment of the three-tier application.
```yaml
---
- hosts: target02
  roles:
    - roles/database
    - roles/frontend
    - roles/backend
```

+ run the playbook
```bash
ansible-playbook -i inventory playbooks/run.yaml
```

![alt text](<images/Screenshot from 2024-08-06 11-18-32.png>)
![alt text](<images/Screenshot from 2024-08-06 16-52-32.png>)
---

![alt text](<images/Screenshot from 2024-08-06 17-38-39.png>)
---