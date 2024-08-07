## Project-1

### Project Overview

This capstone project aims to create a comprehensive automated deployment pipeline for a web application using Ansible on an AWS EC2 instance running Ubuntu. The project follows best practices for playbooks and roles, implements version control, and uses dynamic inventory scripts to manage EC2 instances. The end result will be a fully functional deployment pipeline demonstrating mastery of Ansible for infrastructure automation.

### Project Objectives

- Set up an AWS EC2 instance as a worker node.
- Implement Ansible playbooks and roles following best practices.
- Use version control to manage the Ansible codebase.
- Document Ansible roles and playbooks.
- Break down deployment tasks into reusable roles.
- Write reusable and maintainable Ansible code.
- Use dynamic inventory scripts to manage AWS EC2 instances.
- Deploy a web application on the EC2 instance.

## Project Components and Milestones

### Milestone 1: Environment Setup
**Objective:** Configure your development environment and AWS infrastructure.

**Tasks:**
- Launch an AWS EC2 instance running Ubuntu.
- Install Ansible and Git on your local machine or control node.
```bash
pip install ansible
sudo apt install git
```


### Milestone 2: Create Ansible Role Structure
**Objective:** Organize your Ansible project using best practices for playbooks and roles.

**Tasks:**
- Use Ansible Galaxy to create roles for webserver, database, and application deployment.
- Define the directory structure and initialize each role.
```
ansible-galaxy init roles/application
ansible-galaxy init roles/database
ansible-galaxy init roles/webserver
```
![alt text](<images/Screenshot from 2024-08-06 18-28-45.png>)
---


### Milestone 3: Version Control with Git
**Objective:** Implement version control for your Ansible project.

**Tasks:**
- Initialize a Git repository in your project directory.
- Create a `.gitignore` file to exclude unnecessary files.
- Commit and push the initial codebase to a remote repository.

![alt text](<images/Screenshot from 2024-08-06 18-41-56.png>)
![alt text](<images/Screenshot from 2024-08-06 18-42-11.png>)
---


### Milestone 4: Develop Ansible Roles
**Objective:** Write Ansible roles for web server, database, and application deployment.

**Tasks:**
- Define tasks, handlers, files, templates, and variables within each role.
- Ensure each role is modular and reusable.

### First for Application role

+ first in the file folder (files/index.html)
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Day-19 Task</title>
</head>
<body>
    <center>
        <h1>Welcome to Day-19 Task</h1>
        <h3>hello and Welcome to my web application from day-19</h3>
    </center>
</body>
</html>
```

+ then in the tasks/main.yml
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
    mode: '755'
  become: yes

- name: Deploy Nginx configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  become: yes

```

+ Then in handler/main.yml
```yaml
---
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
  become: yes
```

### For the database

+ In tasks/main.yml
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

### For the Backend

+ In tasks/main.yml
```yaml
---
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


### Milestone 5: Dynamic Inventory Script
**Objective:** Use dynamic inventory scripts to manage AWS EC2 instances.

**Tasks:**
- Write a Python script that queries AWS to get the list of EC2 instances.
- Format the output as an Ansible inventory.

```py
#!/usr/bin/env python

import json
import boto3

def get_inventory():
    ec2 = boto3.client('ec2', region_name='ap-south-1')
    response = ec2.describe_instances(Filters=[{'Name': 'tag:Role', 'Values': ['webserver']}, {'Name': 'tag:Name', 'Values': ['Amaan-inst']}])
     
    inventory = {
        'all': {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }
    
    ssh_key_file = '/home/einfochips/Downloads/ookk.pem'  # Path to your SSH private key file
    ssh_user = 'ubuntu'  # SSH username
    
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            public_dns = instance.get('PublicDnsName', instance['InstanceId'])
            inventory['all']['hosts'].append(public_dns)
            inventory['_meta']['hostvars'][public_dns] = {
                'ansible_host': instance.get('PublicIpAddress', instance['InstanceId']),
                'ansible_ssh_private_key_file': ssh_key_file,
                'ansible_user': ssh_user
            }

    return inventory

if __name__ == '__main__':
    print(json.dumps(get_inventory(), indent=2))
```

![alt text](<images/Screenshot from 2024-08-07 11-12-49.png>)
![alt text](<images/Screenshot from 2024-08-07 11-38-47.png>)
---


### Milestone 6: Playbook Development and Deployment
**Objective:** Create and execute an Ansible playbook to deploy the web application.

**Tasks:**
- Develop a master playbook that includes all roles.
- Define inventory and variable files for different environments.
- Execute the playbook to deploy the web application on the EC2 instance.

**Deliverables:**
+ Ansible playbook for web application deployment.
+ Successfully deployed web application on the EC2 instance.

![alt text](<images/Screenshot from 2024-08-07 11-59-34.png>)
![alt text](<images/Screenshot from 2024-08-07 13-01-32.png>)

![alt text](<images/Screenshot from 2024-08-07 12-00-08.png>)
---