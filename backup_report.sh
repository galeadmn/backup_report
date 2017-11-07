#!/bin/bash
REPORT_FILE=/tmp/backup_report
echo Rsnapshot report for $(date +%F) > $REPORT_FILE
echo >> $REPORT_FILE
echo Errors from rsnapshot: >> $REPORT_FILE
grep ERROR /var/log/rsnapshot/* | grep $(date +%F) >> $REPORT_FILE
echo >> $REPORT_FILE
echo Warnings from rsnapshot: >> $REPORT_FILE
grep WARNING /var/log/rsnapshot/* | grep $(date +%F) >> $REPORT_FILE
echo >> $REPORT_FILE
echo Failures from rsnapshot: >> $REPORT_FILE
grep failed /var/log/rsnapshot/* | grep $(date +%F) >> $REPORT_FILE

# If there were no errors, the report should contain exactly seven lines
LINES=$(wc -l < /tmp/backup_report)
if [ $LINES == "7" ]; then
        echo "There were no errors." | mutt -s "Rsnapshot report for $(date +%F)" <your email here>
else
        mutt -s "Rsnapshot report for $(date +%F)" <your email here> < /tmp/backup_report
fi
