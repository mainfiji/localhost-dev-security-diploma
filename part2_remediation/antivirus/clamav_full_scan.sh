#!/bin/bash
LOGFILE="/var/log/clamav/clamav_scan_$(date +%Y%m%d).log"
echo "Starting full system scan at $(date)" >> $LOGFILE
clamscan -r / --exclude-dir=/sys --exclude-dir=/proc --exclude-dir=/dev --exclude-dir=/run --exclude-dir=/mnt --exclude-dir=/media --exclude-dir=/var/log/clamav -l $LOGFILE
echo "Scan finished at $(date)" >> $LOGFILE
