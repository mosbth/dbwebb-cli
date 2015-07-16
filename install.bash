echo "[dbwebb] Downloading and installing dbwebb."
wget -O /tmp/$$ https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2 

if [ ! -d /usr/local/bin ]; then
    echo "[dbwebb] Creating directory structure for '/usr/local/bin'."
    sudo install -d /usr/local/bin
fi

echo "[dbwebb] Installing into '/usr/local/bin/dbwebb'."
sudo install dbwebb /usr/local/bin

echo "[dbwebb] Cleaning up."
rm /tmp/$$

echo "[dbwebb] Check what version we have."
dbwebb --version

echo "[dbwebb] Done. Execute 'dbwebb --help' to get an overview."
