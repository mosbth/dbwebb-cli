if [ "$EUID" -ne 0 ]
  then echo "Please run as root using sudo."
  exit
fi

TMP="/tmp/$$"

echo "[dbwebb] Downloading and installing dbwebb."
if hash wget 2> /dev/null; then
    echo "Using wget."
    wget -qO $TMP https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2 
elif hash curl 2> /dev/null; then
    echo "Using curl."
    curl -so $TMP https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2 
else
    echo "Failed. Did not find wget nor curl. Please install either wget or curl."
    exit 1    
fi;

if [ ! -d /usr/local/bin ]; then
    echo "[dbwebb] Creating directory structure for '/usr/local/bin'."
    install -d /usr/local/bin
fi

echo "[dbwebb] Installing into '/usr/local/bin/dbwebb'."
install $TMP /usr/local/bin/dbwebb
ls -l /usr/local/bin/dbwebb

echo "[dbwebb] Cleaning up."
rm $TMP

echo "[dbwebb] Check what version we have."
dbwebb --version

echo "[dbwebb] Done. Execute 'dbwebb --help' to get an overview."
