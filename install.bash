#
# Download and install dbwebb-cli.
#
# Execute as:
# bash -c "$(cat install.bash)"
# bash -c "$(wget -qO- https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/install.bash)"
#



#
# Basic settings
#
TARGET="https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2"
PATH1="/usr/local/bin"
PATH2="/usr/bin"
WHERE="$PATH1/dbwebb"
TMP="/tmp/$$"

ECHO="echo -e"
ECHON="echo -n"
MSG_DOING="\033[1;37;40m[dbwebb-cli install]\033[0m"
#MSG_DONE="\033[0;30;42m[OK]\033[0m"
MSG_DONE=""
MSG_OK="\033[0;30;42m[SUCCESS]\033[0m"
#MSG_WARNING="\033[43mWARNING\033[0m"
MSG_FAILED="\033[0;37;41m[FAILED]\033[0m"



#
# Check if all tools are available
#
function checkTool() {
    $ECHON "$1 "
    if ! hash $1 2> /dev/null; then
        $ECHO "\n$MSG_FAILED Missing $1, install it $2"
        exit -1
    fi
}

$ECHO "$MSG_DOING Checking precondition..."

checkTool "wget"   "using your packet manager."
checkTool "ssh"    "using your packet manager."
checkTool "rsync"  "using your packet manager."
checkTool "git"    "https://dbwebb.se/labbmiljo/git"

$ECHO "\n$MSG_DONE"



#
# Download
#
$ECHO "$MSG_DOING Downloading dbwebb-cli..."

wget -qO $TMP $TARGET

if [[ $? != 0 ]]; then
    rm -f $TMP
    $ECHO "$MSG_FAILED downloading dbwebb-cli."
    $ECHO "I could not download the script from GitHub."
    $ECHO "Do you have a network connection to GitHub http://github.com?"
    exit 1
fi

ls -l $TMP

$ECHO "$MSG_DONE"



#
# Installing dbwebb-cli into path
#
$ECHO "$MSG_DOING Installing dbwebb-cli..."

if [ ! -d "$PATH1" ]; then
    WHERE="$PATH2/dbwebb"
fi

$ECHO "Installing into '$WHERE'."
install -v -m 0755 $TMP $WHERE

if [[ $? != 0 ]]; then
    rm $TMP
    $ECHO "$MSG_FAILED installing into '$WHERE'."
    $ECHO "Try re-run the installation-command as root using 'sudo'."
    $ECHO "Or, install using the manual procedure, as explained here:"
    $ECHO " https://dbwebb.se/dbwebb-cli#steg"
    exit 1
fi

ls -l $WHERE

$ECHO "$MSG_DONE"



#
# Cleaning up
#
$ECHO "$MSG_DOING Cleaning up..."

rm $TMP

$ECHO "$MSG_DONE"



#
# Execute the command to check version
#
$ECHO "$MSG_DOING Check what version we have..."

dbwebb --version

if [[ $? != 0 ]]; then
    $ECHO "$MSG_FAILED checking the version of dbwebb-cli."
    $ECHO "Try re-running the installation script or post the output of the installation procedure to the forum and ask for help."
    exit 1
fi

$ECHO "$MSG_DONE"



#
# Done
#
$ECHO "$MSG_DOING Done with success!"
$ECHO "$MSG_OK"
$ECHO "Execute 'dbwebb --help' to get an overview of the command."
$ECHO "Read the manual: https://dbwebb.se/dbwebb-cli"
