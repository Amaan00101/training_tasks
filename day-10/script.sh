#!/bin/bash

Report="/home/einfochips/day-10"
Alert_CPU=75   
Alert_memory=40  
Service_Status=("nginx" "mysql")
External_Service=("google.com" "mysql://db.testing.com")

CPU_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')

System_Metrics() {
    echo -e "\n CPU Usage: "
    echo "CPU_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")"
    echo "memory_usage=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')"
    echo "DISK_SPACE=$(df -h / | awk '/\//{print $(NF-1)}')"

    echo -e "\n Network Statistics: "
    echo "NETWORK_STATS=$(netstat -i)"

    echo -e "\n Top Processes: "
    echo "TOP_PROCESSES=$(top -bn 1 | head -n 10)"
}

Log_analysis() {
    echo -e "\Recent Critical Events: "
    echo "CRITICAL_EVENTS=$(tail -n 200 /var/log/syslog | grep -iE 'error|critical')"

    echo -e "\n Recent Logs: "
    echo "RECENT_LOGS=$(tail -n 20 /var/log/syslog)"
}

Health_check() {
    echo -e "\n Service Status: "
    for service in "${Service_Status[@]}"; do
        systemctl is-active --quiet "$service"
        if [ $? -eq 0 ]; then
            echo "   $service is running."
        else
            echo "   Alert: $service is not running."
        fi
    done

    echo -e "\n Connectivity Check: "
    for service in "${External_Service[@]}"; do
        ping -c 1 "$service" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "   Connectivity to $service is okay." 
        else
            echo "   Alert: Unable to connect to $service."
        fi
    done

}

if (( $(echo "$CPU_usage >= $Alert_CPU" | bc -l) )); then
    echo "High CPU Usage Alert: $CPU_usage%"
fi

if (( $(echo "$memory_usage >= $Alert_memory" | bc -l) )); then
    echo "High Memory Usage Alert: $memory_usage%"
fi


mkdir -p "$Report"
New_Report="$Report/report_$(date +'%Y-%m-%d_%H-%M-%S').txt"
echo "System Report $(date)" >> "$New_Report"
System_Metrics >> "$New_Report"
Log_analysis>> "$New_Report"
Health_check >> "$New_Report"

echo "Select an option:
1. Check system metrics
2. View logs
3. Check service status
4. Exit"

read choice

case $choice in
    1) System_Metrics
       ;;
    2) Log_analysis
       ;;
    3) Health_check
       ;;
    4) exit ;;
    *) echo "Invalid option";;
esac