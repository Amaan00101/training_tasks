## Project 1 : Deploying Ansible

#### Problem Statement: 

You are tasked with deploying Ansible in a multi-node environment consisting of multiple Linux servers. The goal is to set up Ansible on a control node and configure it to manage several managed nodes. This setup will be used for automating system administration tasks across the network.


### Deliverables:

#### 1. Control Node Setup:
+ Install Ansible on the control node.
```
sudo apt update
sudo apt install ansible
ansible --version
```

![alt text](<images/Screenshot from 2024-07-30 19-08-45.png>)
---

+ Configure SSH key-based authentication between the control node and managed nodes.
```
ssh -i /path/to/key/key.pem user@ip
```


#### 2. Managed Nodes Configuration:

+ Ensure all managed nodes are properly configured to be controlled by Ansible.

+ Verify connectivity and proper setup between the control node and managed nodes.

```
ansible target -i inventory -m ping
```

![alt text](<images/Screenshot from 2024-07-30 15-55-33.png>)
---


## Project 2: Ad-Hoc Ansible Commands

### Problem Statement: 

Your organization needs to perform frequent, one-off administrative tasks across a fleet of servers. These tasks include checking disk usage, restarting services, and updating packages. You are required to use Ansible ad-hoc commands to accomplish these tasks efficiently.

### Deliverables:

#### 1. Task Execution:

+ Execute commands to check disk usage across all managed nodes.
```
ansible -i inventory -m shell -a 'du -h' all
```

![alt text](<images/Screenshot from 2024-07-30 16-16-50.png>)
---


+ Restart a specific service on all managed nodes.
    - For restart the server first we will install nginx service using ad-hoc command
```
ansible -i inventory -m apt -a "name=nginx state=present" all --become
```

![alt text](<images/Screenshot from 2024-07-30 16-23-50.png>)
---


+ now we will restart the service
```
ansible -i inventory -m service -a "name=nginx state=restarted" all
```

![alt text](<images/Screenshot from 2024-07-30 16-28-21.png>)
---


+ Update all packages on a subset of managed nodes.
```
ansible all -i inventory -b -m apt -a "update_cache=yes"
```

![alt text](<images/Screenshot from 2024-07-30 16-43-51.png>)
---


## Project 3: Working with Ansible Inventories

### Problem Statement: 

You need to manage a dynamic and diverse set of servers, which requires an organized and flexible inventory system. The project involves creating static and dynamic inventories in Ansible to categorize servers based on different attributes such as environment (development, staging, production) and roles (web servers, database servers).

### Deliverables:

#### Static Inventory:

+ Create a static inventory file with different groups for various environments and roles.
```
[new]
target02 ansible_host=52.14.x.xx ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training_day-16/ansible-worker.pem

[new-group]
target04 ansible_host=18.21x.xx.xxx ansible_user=ubuntu ansible_ssh_private_key_file=/home/einfochips/training_day-16/ansible-worker.pem
```


+ Verify that the inventory is correctly structured and accessible by Ansible.
```
ansible all -i inventory -m ping
```

![alt text](<images/Screenshot from 2024-07-30 19-00-33.png>)
---


## Project 4: Ansible Playbooks: The Basics

### Problem Statement: 

Your team needs to automate repetitive tasks such as installing packages, configuring services, and managing files on multiple servers. The project involves writing basic Ansible playbooks to automate these tasks, ensuring consistency and efficiency in the operations.

### Deliverables:

#### 1. Playbook Creation:

+ Write a playbook to install a specific package on all managed nodes.
+ Create a playbook to configure a service with specific parameters.
+ Develop a playbook to manage files, such as creating, deleting, and modifying files on managed nodes.

```yaml
---
- name: installinf nginx and create, update & delete file 
  hosts: target02
  become: yes
  tasks:
    - name: installing nginx
      apt: 
        name: nginx
        state: present
        update_cache: yes

    - name: creating file
      file:
        path: /home/amaan.txt
        state: touch

    - name: updating fiel
      lineinfile: 
        path: /home/amaan.txt
        line: this is day-16 task file

    - name: deleting file
      file:
        path: /home/amaan.txt
        state: absent
```


#### 2. Testing and Verification:

+ Test the playbooks to ensure they run successfully and perform the intended tasks.
+ Validate the changes made by the playbooks on the managed nodes.

![alt text](<images/Screenshot from 2024-07-30 17-13-21.png>)
---


## Project 5: Ansible Playbooks - Error Handling

### Problem Statement: 

In a complex IT environment, tasks automated by Ansible playbooks may encounter errors due to various reasons such as incorrect configurations, unavailable resources, or network issues. The project focuses on implementing error handling in Ansible playbooks to ensure resilience and proper reporting of issues.

### Deliverables:

#### 1. Playbook with Error Handling:

+ Write a playbook that includes tasks likely to fail, such as starting a non-existent service or accessing a non-existent file.
```yaml
---
- name: block-rescue task
  hosts: target02
  become: yes
  tasks:
  - name: download transaction_list
    block:
      - get_url:
          url: https://autocatalogarchive.com/wp-content/uploads/2024/01/McLaren-GTS-2023-INT.pdf
          dest: /home/McLaren
      - debug: msg="File downloaded"
    rescue:
      - debug: msg="The upper link is Not working. downloading other file"
      - get_url:
          url: https://autocatalogarchive.com/wp-content/uploads/2016/09/Ford-Mustang-2013-CA.pdf
          dest: /home/Mustang

```



+ Implement error handling strategies using modules like block, rescue, and always.

![alt text](<images/Screenshot from 2024-07-30 18-46-52.png>)
---