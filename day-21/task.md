## Project 01: System Monitoring and Log Management

## Project Overview

This capstone project aims to integrate shell scripting with system monitoring and log management practices. The primary objectives are to automate log management tasks, monitor system performance using Prometheus and Node Exporter, and generate insights using PromQL queries.

## Project Deliverables

### 1. Shell Scripts for Basic Operations

**Task:** Write shell scripts to perform basic system operations, such as checking disk usage, memory usage, and CPU load.

**Deliverable:**
- A collection of scripts that output system performance metrics.
- Scripts include error handling and logging.
```
#!/bin/bash
LOGFILE="system_metrics.log"
log_message() {
    echo "$1" | tee -a "$LOGFILE"
}
check_disk_usage() {
    log_message "Disk Usage:"
    df -h | tee -a "$LOGFILE"
}
check_memory_usage() {
    log_message "Memory Usage:"
    free -h | tee -a "$LOGFILE"
}
check_cpu_load() {
    log_message "CPU Load:"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
}
check_disk_usage
check_memory_usage
check_cpu_load
# Error handling
if [ $? -ne 0 ]; then
    log_message "Error occurred while collecting system metrics."
    exit 1
fi
log_message "System metrics collection completed successfully."
```

![alt text](<images/Screenshot from 2024-08-09 15-46-39.png>)
---


### 2. Log Management Script

**Task:** Develop a script to automate log management tasks such as log rotation and archiving.

**Deliverable:**
- A shell script that performs log rotation based on predefined conditions (e.g., log size, log age).
- A report detailing which logs were rotated, compressed, or deleted.

```
#!/bin/bash
LOGFILE="log_report.txt"
check_log() {
    echo "logs are shown below :-"
    cat /var/log/syslog | tail -n 4
    echo
}

if [ -n "$LOGFILE" ]; then
    {
        check_log
    } > "$LOGFILE" 
    echo "Report saved to $LOGFILE"
fi
```
![alt text](<images/Screenshot from 2024-08-09 15-47-57.png>)
---


### 3. Advanced Shell Scripting

**Task:** Refactor previous scripts to include loops, conditionals, and functions for modularity. Implement error handling.

**Deliverable:**
- Modular shell scripts that use functions for repeatable tasks.
- Error-handling mechanisms for scenarios like missing files and insufficient permissions.
- Logs tracking script execution and errors encountered.
```
#!/bin/bash

OUTPUT_FILE="log_report2.txt"
# Functions Of disk_usage , Check Memory and check CPU load
check_log() {
    echo "logs are shown below :-"
    cat /var/log/syslog | tail -n 5
    echo
}

if [ -n "$OUTPUT_FILE" ]; then
    {
        check_log
    } > "$OUTPUT_FILE" 
    echo "Report saved to $OUTPUT_FILE"
fi
```
![alt text](<images/Screenshot from 2024-08-09 23-59-07.png>)
---


### 4. Log Checking and Troubleshooting

**Task:** Write a script to read through system and application logs, identify common issues, and provide troubleshooting steps.

**Deliverable:**
- A script that parses logs for errors or warnings and outputs possible root causes.
- Documentation on types of logs checked and issues identified.
- A troubleshooting guide based on common errors found in logs.
```
#!/bin/bash

SYSLOG_FILE="/var/log/syslog"
AUTH_LOG_FILE="/var/log/auth.log"

check_logs() {
    local file=$1
    local keyword=$2
    echo "Checking $file for '$keyword'..."
    grep "$keyword" "$file" | tail -n 10
}
echo "Starting log check..."
echo "System Log Errors"
check_logs $SYSLOG_FILE "error"
echo "Authentication Failures"
check_logs $AUTH_LOG_FILE "authentication failure"
echo "Log check completed."
```
![alt text](<images/Screenshot from 2024-08-09 15-54-32.png>)
---


### 5. Installation and Setup of Prometheus and Node Exporter

**Task:** Install and configure Prometheus and Node Exporter on the system.

**Deliverable:**
- Documented installation and configuration process for Prometheus and Node Exporter.
- A running instance of Prometheus scraping metrics from Node Exporter.

### Steps to install Prometheus

+ First download the zip file from
```
wget https://github.com/prometheus/prometheus/releases/download/v2.53.1/prometheus-2.53.1.linux-amd64.tar.gz
```

+ then to unzip it run
```
tar -xvf prometheus-2.53.1.linux-amd64.tar.gz
```
![alt text](<images/Screenshot from 2024-08-08 18-25-37.png>)
---

+ And try to run Prometheus
```
./prometheus 
```
![alt text](<images/Screenshot from 2024-08-08 18-26-12.png>)

![alt text](<images/Screenshot from 2024-08-08 18-26-39.png>)
---

### Steps to install Node-Exporter

+ First Download the Zip

```
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
```

+ Unzip the file using:
```
tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz
```
![alt text](<images/Screenshot from 2024-08-08 18-27-47.png>)
---


+ And try to run Node Exporter
```
./node_exporter 
```
![alt text](<images/Screenshot from 2024-08-08 18-28-38.png>)

![alt text](<images/Screenshot from 2024-08-08 18-29-28.png>)
---


### 6. Prometheus Query Language (PromQL) Basic Queries

**Task:** Create PromQL queries to monitor system performance metrics.

**Deliverable:**
- A set of PromQL queries for monitoring CPU usage, memory usage, and disk I/O.
- A dashboard setup guide or configuration to visualize these metrics in Prometheus or Grafana.

#### add a sample node_exporter job
```
  # sample node_exporter job
  - job_name: "node"
    static_configs:
      - targets: ["localhost:9100"]
```

#### Run the Query

+ Output for CPU usage

![alt text](<images/Screenshot from 2024-08-08 20-42-28.png>)
![alt text](<images/Screenshot from 2024-08-08 21-48-32.png>)


+ Output for Memory usage

![alt text](<images/Screenshot from 2024-08-08 20-43-28.png>)
![alt text](<images/Screenshot from 2024-08-08 21-48-21.png>)