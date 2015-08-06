TMP="/tmp/$$"
TARGET="https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2"
WHERE="/usr/local/bin/dbwebb"

echo "[dbwebb] Downloading and installing dbwebb."
if hash wget 2> /dev/null; then
    echo "Using wget."
    wget -qO $TMP $TARGET 
elif hash curl 2> /dev/null; then
    echo "Using curl."
    curl -so $TMP $TARGET
else
    echo "Failed. Did not find wget nor curl. Please install either wget or curl."
    exit 1    
fi;

echo "[dbwebb] Installing into '/usr/local/bin/dbwebb' (you may need to provide root password)."
sudo install -v --mode=0755 -D $TMP $WHERE
ls -l $WHERE

echo "[dbwebb] Cleaning up."
rm $TMP

echo "[dbwebb] Check what version we have."
dbwebb --version

echo "[dbwebb] Done. Execute 'dbwebb --help' to get an overview."
