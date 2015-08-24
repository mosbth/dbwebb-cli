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
fi

echo "[dbwebb] Installing into '/usr/local/bin/dbwebb'."
install --verbose --mode=0755 -D $TMP $WHERE

if [[ $? != 0 ]]; then
    echo "[dbwebb] FAILED. Could not successfully execute the install command."
    echo "Try re-run the installation-command as root using 'sudo'."
    echo "Or, execute the following command, as root or using sudo, to move 'dbwebb' into its place in $WHERE."
    echo " install --verbose --mode=0755 -D $TMP $WHERE"
    echo "Or, install using the manual procedure, as explained here:"
    echo " http://dbwebb.se/dbwebb-cli#steg"
    exit 1
fi

ls -l $WHERE

echo "[dbwebb] Cleaning up."
rm $TMP

echo "[dbwebb] Check what version we have."
dbwebb --version

echo "[dbwebb] Done. Execute 'dbwebb --help' to get an overview."
