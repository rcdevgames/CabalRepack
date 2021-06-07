#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'

clear
echo "Loading..."
sleep 1
clear

echo "  ___   _   ___   _   _    "    
echo " / __| /_\ | _ ) /_\ | |   "   
echo "| (__ / _ \| _ \/ _ \| |__ " 
echo " \___/_/ \_\___/_/ \_\____|"

echo -e "\nX-Pasa 6.7.3 Server Installation"

echo -e "${RED}\nWARNING: Your old server files will be removed!"
echo -e "${NC}Do you want to continue [Y/n]?"
read ready

if [[ -z $ready || $ready == "n" || $ready == "N" ]]; then
  exit
fi

echo -e "${RED}==> ${NC}Preparing..."
sleep 1

echo -e "${RED}==> ${NC}Checking for old installations..."
sleep 1

if [ -d /etc/cabal ]; then
  echo "Found! Cleaning up..."
  rm -rf /etc/cabal
  rm -rf /home/cabal
  rm -rf /var/log/cabal
  rm -rf /usr/bin/AgentShop*
  rm -rf /usr/bin/AuthDBAgent
  rm -rf /usr/bin/CashDBAgent
  rm -rf /usr/bin/ChatNode*
  rm -rf /usr/bin/DBAgent*
  rm -rf /usr/bin/EventDBAgent
  rm -rf /usr/bin/EventMgrSvr
  rm -rf /usr/bin/GlobalDBAgent
  rm -rf /usr/bin/GlobalMgrSvr
  rm -rf /usr/bin/LoginSvr*
  rm -rf /usr/bin/PartySvr*
  rm -rf /usr/bin/PCBangDBAgent
  rm -rf /usr/bin/RockAndRollITS
  rm -rf /usr/bin/WorldSvr*
fi

echo -e "${RED}==> ${NC}Updating your system..."
sleep 1
yum update

echo -e "${RED}==> ${NC}Installing dependencies..."
sleep 1
yum install glibc.i686 libgcc.i686 libstdc++.i686 openssl-devel.i686 -y

echo -e "${RED}==> ${NC}Creating symlinks for dependencies..."
sleep 1
if [ ! -f /usr/lib/libcrypto.so ]; then
  echo "${RED}Fatal error! Couldn't find libcrypto.so library. Exiting..."
  exit
fi

if [ ! -f /usr/lib/libcrypto.so.4 ]; then
  ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.4
fi

if [ ! -f /usr/lib/libcrypto.so.6 ]; then
  ln -s /usr/lib/libcrypto.so /usr/lib/libcrypto.so.6
fi

echo -e "${RED}==> ${NC}Unpacking Database archive..."
sleep 1
mkdir -p /var/opt/mssql/backup
sleep 1
tar xzf ./database.tar.gz -C /var/opt/mssql/backup

echo -e "${RED}==> ${NC}Restoring Database..."
echo -e "${RED}==> ${NC}Insert password SQLServer user SA"
echo -e "${NC}Password : "
read sqlpass

sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [Account] FROM DISK = N'/var/opt/mssql/backup/Account.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [Authentication] FROM DISK = N'/var/opt/mssql/backup/Authentication.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [CabalCash] FROM DISK = N'/var/opt/mssql/backup/CabalCash.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [CabalGuild] FROM DISK = N'/var/opt/mssql/backup/Cabalguild.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [Cashshop] FROM DISK = N'/var/opt/mssql/backup/Cashshop.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [DWConfiguration] FROM DISK = N'/var/opt/mssql/backup/DWConfiguration.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [DWDiagnostics] FROM DISK = N'/var/opt/mssql/backup/DWDiagnostics.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [DWQueue] FROM DISK = N'/var/opt/mssql/backup/DWQueue.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [EventData] FROM DISK = N'/var/opt/mssql/backup/EventData.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [MWeb] FROM DISK = N'/var/opt/mssql/backup/MWeb.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [NetCafeBilling] FROM DISK = N'/var/opt/mssql/backup/Netcafebilling.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [Server01] FROM DISK = N'/var/opt/mssql/backup/Server01.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [WebiNext] FROM DISK = N'/var/opt/mssql/backup/WebiNext.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1
sqlcmd -S localhost -U SA -P $sqlpass -Q "RESTORE DATABASE [WebLT_SHOP] FROM DISK = N'/var/opt/mssql/backup/WebLT_SHOP.bak' WITH FILE = 1, NOUNLOAD, REPLACE, STATS = 5"
sleep 1


echo -e "${RED}==> ${NC}Unpacking Server archive..."
sleep 1
tar xzf ./cabal_ep8.tar.gz -C /

echo -e "${RED}==> ${NC}Setting up permissions and creating symlinks..."
sleep 1
ln -s /etc/cabal/Template/sh/cabal_config.sh /usr/bin/cabal_config
ln -s /etc/cabal/Template/sh/cabal_create.sh /usr/bin/cabal_create
ln -s /etc/cabal/Template/sh/cabal_restart.sh /usr/bin/cabal_restart
ln -s /etc/cabal/Template/sh/cabal_start.sh /usr/bin/cabal_start
ln -s /etc/cabal/Template/sh/cabal_status.sh /usr/bin/cabal_status
ln -s /etc/cabal/Template/sh/cabal_stop.sh /usr/bin/cabal_stop
ln -s /etc/cabal/Template/sh/cabal_reload.sh /usr/bin/cabal_reload

chmod +x /usr/bin/cabal_config
chmod +x /usr/bin/cabal_create
chmod +x /usr/bin/cabal_restart
chmod +x /usr/bin/cabal_start
chmod +x /usr/bin/cabal_status
chmod +x /usr/bin/cabal_stop
chmod +x /usr/bin/cabal_reload

echo "Done! Now create servers and channels with cabal_create."
echo "Example: cabal_create -s 2"
echo "This will create 2 servers."
