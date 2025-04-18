#!/bin/bash

print_section() {
  echo -e "\n\e[1;34m=== $1 ===\e[0m"
}

echo -e "\e[1;33m====== System Information ======\e[0m"

print_section "OS Version"
grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'

print_section "Uptime"
uptime

print_section "Total CPU Usage"
top -bn1 | grep "Cpu(s)" | awk '{usage = 100 - $8} END {printf "CPU Usage: %.2f%%\n", usage}'

print_section "Memory Usage"
free -m | awk '/Mem:/ {
  total=$2; used=$3; free=$4;
  printf "Total: %d MB\nUsed: %d MB (%.2f%%)\nFree: %d MB (%.2f%%)\n", 
  total, used, used/total*100, free, free/total*100
}'

print_section "Disk Usage"
df -h --total | awk '/total/ {
  total=$2; used=$3; free=$4; percent=$5;
  printf "Total: %s\nUsed: %s (%s)\nFree: %s (%.2f%%)\n", 
  total, used, percent, free, (100 - percent+0)
}'

print_section "Top 5 Processes by CPU Usage"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | column -t

print_section "Top 5 Processes by Memory Usage"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | column -t
