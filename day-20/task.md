## Project 01: Advanced Ansible Configurations

### Project Overview

Project 01 focuses on advanced Ansible configurations and practices to manage dynamic inventories, tune performance, debug playbooks, and explore advanced modules. This project involves configuring a dynamic inventory plugin, optimizing Ansible performance, troubleshooting playbooks, and utilizing advanced modules for containerized applications and AWS infrastructure management.


### Project Objectives

1. **Dynamic Inventory Plugins**: Configure a dynamic inventory plugin to manage web servers dynamically and integrate it with Ansible for real-time server updates.
2. **Performance Tuning**: Optimize Ansible performance by adjusting configuration settings and improving playbook efficiency.
3. **Debugging and Troubleshooting**: Implement strategies for debugging and troubleshooting playbooks, including advanced error handling and logging.
4. **Exploring Advanced Modules**: Utilize advanced Ansible modules to manage Docker containers and AWS EC2 instances, showcasing their integration and benefits.



## Activities and Deliverables

### 1. Dynamic Inventory Plugins
**Activity:** Configure a dynamic inventory plugin to manage a growing number of web servers dynamically. Integrate the plugin with Ansible to automatically detect and configure servers in various environments.

**Deliverable:**
- **Dynamic Inventory Configuration File or Script:** A configuration file or script demonstrating automatic inventory updates based on real-time server data.

+ aws_ec2.yaml
```yaml
plugin: aws_ec2
regions:
  - us-east-2
filters:
  instance-state-name:
    - running
hostnames:
  - dns-name
compose:
  ansible_host: public_dns_name
  ansible_user: 'ubuntu'
```

+ ansible.cfg file
```yaml
[defaults]
private_key_file =  /home/einfochips/Downloads/ansible-worker.pem
enable_plugins = aws_ec2
ansible_python_interpreter = /usr/bin/python3
remote_user = ubuntu

[ssh_connection]
host_key_checking = False
```

+ commands for listing Hosts
```
ansible-inventory -i aws_ec2.yml --list
ansible-inventory -i aws_ec2.yml --graph
```
![alt text](<images/Screenshot from 2024-08-07 22-37-13.png>)
![alt text](<images/Screenshot from 2024-08-07 23-41-28.png>)
---


### 2. Performance Tuning
**Activity:** Tune Ansible performance by adjusting settings such as parallel execution (forks), optimizing playbook tasks, and reducing playbook run time.

**Deliverable:**
- **Optimized `ansible.cfg` Configuration File:** An updated Ansible configuration file with performance tuning adjustments.
- **Performance Benchmarks:** Results from performance tests before and after optimization.
- **Documentation:** Detailed changes made to improve performance, including adjustments to parallel execution and task optimization.

```
[defaults]
forks = 10

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
```


### 3. Debugging and Troubleshooting Playbooks
**Activity:** Implement debugging strategies to identify and resolve issues in playbooks, including setting up verbose output and advanced error handling.

**Deliverable:**
- **Debugged Playbooks:** Playbooks with enhanced error handling and logging.
- **Troubleshooting Guide:** Documentation outlining common issues and their solutions.

**Details:**
- Use Ansible's verbose mode (`-vvvv`) to diagnose issues.
- Implement error handling and logging strategies to improve playbook troubleshooting.

```
ansible-playbook -i inventory.ini docker-playbook.yml -v

ansible-playbook -i inventory.ini docker-playbook.yml -vv

ansible-playbook -i inventory.ini docker-playbook.yml -vvv

ansible-playbook -i inventory.ini docker-playbook.yml -vvvv
```

![alt text](<images/Screenshot from 2024-08-08 00-04-52.png>)
---


### 4. Exploring Advanced Modules
**Activity:** Use advanced Ansible modules such as `docker_container` to manage containerized applications and `aws_ec2` for AWS infrastructure management, demonstrating their integration and usage.

**Deliverable:**
- **Playbooks:** Playbooks showcasing the deployment and management of Docker containers and AWS EC2 instances.
- **Documentation:** Explanation of the benefits and configurations of these advanced modules.

#### Docker Container Module 
```yaml
- name: Docker Container Creation
  hosts: localhost

  tasks:
  - name: Create and start Docker container
    community.docker.docker_container:
      name: my_nginx
      image: nginx:latest
      state: started
      ports:
      - "8085:80"
      volumes:
      - /my/local/path:/usr/share/nginx/html
```
![alt text](<images/Screenshot from 2024-08-08 00-12-05.png>)
---


#### AWS ec2 Module
```yaml
- name: Launch an EC2 instance
  hosts: localhost
  tasks:

  - name: Create security group
    amazon.aws.ec2_security_group:
      name: "new-security-group"
      description: "Sec group for app"
      rules:                               
        - proto: tcp
          ports:
            - 22
          cidr_ip: 0.0.0.0/0
          rule_desc: allow all on ssh port
```
![alt text](<images/Screenshot from 2024-08-08 00-18-58.png>)
---