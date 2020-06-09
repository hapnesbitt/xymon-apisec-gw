#!/bin/sh

   COLUMN=ITM-Custom	# Name of the column
   COLOR=green		# By default, everything is OK
   MSG="ITM-Custom on Linux"

   # Do whatever you need to test for something
IBDATAMAX=`cat /etc/my.cnf | grep ibdata | grep -o '......$' | sed 's/[^0-9]*//g' `
DISKSPACE=`df -mP /dev/mapper/vg00-lv_db | sed '1d' | awk '{print $5}' | cut -d'%' -f1`
DISKSPACE2=`df -mP /dev/mapper/vg00-lv_db | sed '1d' | awk '{print $3}' | cut -d'%' -f1`
DISKSPACE3=`df -mP /dev/mapper/vg00-lv_db | sed '1d' | awk '{print $4}' | cut -d'%' -f1`
DISKSPACE4=`df -mP /dev/mapper/vg00-lv_log | sed '1d' | awk '{print $5}' | cut -d'%' -f1`
DISKSPACE5=`bc <<<"scale=2; $DISKSPACE2 / $IBDATAMAX"`
DISKSPACE6=`bc <<<"$DISKSPACE5 * 100"`
DISKSPACE7=`bc <<<"$DISKSPACE6 / 1"`


# MySQL capacity 
IBDATAMAX=`cat /etc/my.cnf | grep ibdata | grep -o '......$' | sed 's/[^0-9]*//g' `

# Disk capacity threshold
ALERT=60
ALERT2=60
ALERT3=60
ALERT4=75
ALERT5=75
ALERT6=75

   # As an example, go green if diskspace used is less than alert threshold 
   if [ $DISKSPACE -lt $ALERT ] && [ $DISKSPACE4 -lt $ALERT2 ] && [ $DISKSPACE7 -lt $ALERT3 ]
   then
      COLOR=green
      echo "" > /tmp/diskstatus 
      echo "     0. Disk Alert " >> /tmp/diskstatus 
      echo "     1. Disk Report " >> /tmp/diskstatus 
      echo "     2. CPU Report" >> /tmp/diskstatus 
      echo "     3. Memory Report" >> /tmp/diskstatus 
      echo "     4. Network Report" >> /tmp/diskstatus 
      echo "     5. Environment Report" >> /tmp/diskstatus 
      echo "" >> /tmp/diskstatus 

      echo "     * 0. Disk Alert * " >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 

      echo "        If one of these three exceed 60% turn this page Yellow/Warn -- Over 75% turn Red/Panic" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 

      echo "        Current percentages used" >> /tmp/diskstatus 
      echo "             IBDATA is ${DISKSPACE7}% used" >> /tmp/diskstatus
      echo "             DB partition ${DISKSPACE}% used" >> /tmp/diskstatus
      echo "             Log partion ${DISKSPACE4}% used" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 

      echo "        DISK Info" >> /tmp/diskstatus 
      echo "             IBDATA MAX ${IBDATAMAX}M" >> /tmp/diskstatus
      echo "             ${DISKSPACE2}M of /var/lib/mysql used " >> /tmp/diskstatus
      echo "             ${DISKSPACE3}M of /var/lib/mysql available " >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 

      echo "        Threshold Info" >> /tmp/diskstatus 
      echo "             Global DISK threshold Default in Xymon: Turn Yellow at 90% and Red at 95%" >> /tmp/diskstatus
      echo "             Custom DISK threshold set in analysis.cfg for APISEC GW boxes: Turn Yellow at 70% and Red at 85%" >> /tmp/diskstatus
      echo "             Custom ITM-Custom threshold set in this ITM-Custom script for specific Disk partitions: Turn Yellow at 60% and Red at 75%" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 
      echo "" >> /tmp/diskstatus 

      echo "     * 1. Disk Report * " >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus 
      echo "         Disk Free" >> /tmp/diskstatus
      echo "           df -mP" >> /tmp/diskstatus
      df -mP >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Summary of Some Disk Statistics" >> /tmp/diskstatus
      echo "vmstat -D" >> /tmp/diskstatus
      vmstat -D >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus


      echo "     * 2. CPU Report *" >> /tmp/diskstatus 
      echo "" >> /tmp/diskstatus

      echo "top -b -n -1 " >> /tmp/diskstatus
      top -b -n 1 >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Top Five CPU Using Processes" >> /tmp/diskstatus
      echo "ps auxf | sort -nr -k 3 | head -6" >> /tmp/diskstatus
      ps auxf | sort -nr -k 3 | head -6 >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Process Tree" >> /tmp/diskstatus
      echo "pstree" >> /tmp/diskstatus
      pstree >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus


      echo "     * 3. Memory Report *" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Active and Inactive Memory five second delay thrice" >> /tmp/diskstatus
      echo "vmstat -a 5 3 " >> /tmp/diskstatus
      vmstat -a 5 3 >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Free Memory" >> /tmp/diskstatus
      echo "free -m " >> /tmp/diskstatus
      free -m >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Top Five Memory Using Processes" >> /tmp/diskstatus
      echo "ps auxf | sort -nr -k 4 | head -6" >> /tmp/diskstatus
      ps auxf | sort -nr -k 4 | head -6 >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Event Counters and Memory Statistics" >> /tmp/diskstatus
      echo "vmstat -s" >> /tmp/diskstatus
      vmstat -s >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Meminfo Statistics" >> /tmp/diskstatus
      echo "cat /proc/meminfo" >> /tmp/diskstatus
      cat /proc/meminfo >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "     * 4. Network Report *" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ss -s" >> /tmp/diskstatus
      ss -s >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ss -l" >> /tmp/diskstatus
      ss -l >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ip route" >> /tmp/diskstatus
      ip route >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ip -s lin" >> /tmp/diskstatus
      ip -s lin >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ip maddr" >> /tmp/diskstatus
      ip maddr ls >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ifconfig" >> /tmp/diskstatus
      ifconfig >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "ethtool eth0" >> /tmp/diskstatus
      ethtool eth0 >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "netstat -s" >> /tmp/diskstatus
      netstat -s >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "     * 5. Environment Report *" >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "id" >> /tmp/diskstatus
      id >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "env" >> /tmp/diskstatus
      env >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "Redhat Release" >> /tmp/diskstatus
      cat /etc/redhat-release >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "uptime" >> /tmp/diskstatus
      uptime >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      MSG="${MSG}
 
      `cat /tmp/diskstatus`
      "


   # As an example, go yellow if diskspace used is less than alert threshold 
   elif [ $DISKSPACE -lt $ALERT4 ] && [ $DISKSPACE4 -lt $ALERT5 ] && [ $DISKSPACE7 -lt $ALERT6 ]
   then
      COLOR=yellow
      echo "" >> /tmp/diskstatus
      echo -n "Your DB partition disk space is ${DISKSPACE}% used." > /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "" >> /tmp/diskstatus
      echo -n "Your LOG partition disk space is ${DISKSPACE4}% used." >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "" >> /tmp/diskstatus
      echo -n "Your IBDATA is ${DISKSPACE7}% used." >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      MSG="${MSG}


      `cat /tmp/diskstatus`
     This is an early warning sytem that turns Yellow at 60% used and Red at 75% used. 
     As a fire drill, the correct functioning of this Yellow Alert can be verified by temporarily setting the Alert threshold lower.
      "


   else
      COLOR=red

      echo "" >> /tmp/diskstatus
      echo -n "Your DB partition disk space is ${DISKSPACE}% used." > /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "" >> /tmp/diskstatus
      echo -n "Your LOG partition disk space is ${DISKSPACE4}% used." >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      echo "" >> /tmp/diskstatus
      echo -n "Your IBDATA is ${DISKSPACE7}% used." >> /tmp/diskstatus
      echo "" >> /tmp/diskstatus

      MSG="${MSG}


      `cat /tmp/diskstatus`
     This is an early warning sytem that turns Yellow at 60% used and Red at 75% used. 
     As a fire drill, the correct functioning of this Red Alert can be verified by temporarily setting the Alert threshold lower.

      "
   fi

   # Tell Xymon about it
   $XYMON $XYMSRV "status $MACHINE.$COLUMN $COLOR `date`

   ${MSG}
   "

   exit 0
