mkdir -p /tmp/oracle_backup
chmod 777 /tmp/oracle_backup

--sysdba

CREATE OR REPLACE DIRECTORY backup_dir AS '/tmp/oracle_backup';

GRANT READ, WRITE ON DIRECTORY backup_dir TO LOG_ARCHITECT;

expdp LOG_ARCHITECT/architect DIRECTORY=backup_dir DUMPFILE=log_backup_full.dmp LOGFILE=backup_log.log

-- as log architect test1
sqlplus LOG_ARCHITECT/architect

DROP TABLE Customers CASCADE CONSTRAINTS;
SELECT * FROM Customers;
EXIT;

-- recover only Customers table
impdp LOG_ARCHITECT/architect DIRECTORY=backup_dir DUMPFILE=log_backup_full.dmp TABLES=Customers

sqlplus LOG_ARCHITECT/architect
SELECT COUNT(*) FROM Customers;


--RMAN

--as sysdba

SHUTDOWN IMMEDIATE;

STARTUP MOUNT;

ALTER DATABASE ARCHIVELOG;

ALTER DATABASE OPEN;

ARCHIVE LOG LIST;

-- master

rman target /

RUN {
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK FORMAT '/tmp/oracle_backup/arc_%U';
  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL DELETE INPUT;
  RELEASE CHANNEL c1;
}

CROSSCHECK ARCHIVELOG ALL;
DELETE EXPIRED ARCHIVELOG ALL;

cat << 'EOF' > /home/oracle/backup_15min.sh
#!/bin/bash
source /home/oracle/.bash_profile
rman target / cmdfile=/home/oracle/backup_15min.rman log=/tmp/oracle_backup/rman_cron.log
EOF


echo "*/15 * * * * /home/oracle/backup_15min.sh" | crontab -

chmod +x /home/oracle/backup_15min.sh

crontab -l
cat /tmp/oracle_backup/rman_cron.log


ls -lh /tmp/oracle_backup/




