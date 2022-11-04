# --------------- DBWEBB BOOTSTRAP PHASE START ---------------

#START_TIMER=$( date +%s.%N )
START_TIMER=$( date +%s )

# Messages
MSG_OK="\033[0;30;42mOK\033[0m"
MSG_DONE="\033[1;37;40mDONE\033[0m"
MSG_WARNING="\033[43mWARNING\033[0m"
MSG_FAILED="\033[0;37;41mFAILED\033[0m"

# For asserts
ASSERTS=0
FAULTS=0
TMPFILE="/tmp/dbwebb-error-{$USER}-$$"



#
# Find my environment, before any work can be done
#


# What was the command issued?
DBW_EXECUTABLE_PATH="$0"
DBW_EXECUTABLE="$( basename "$0" )"

# Where is the executable
DBW_EXECUTABLE_DIR="$( dirname "$0" )"

# What is the current directory
DBW_CURRENT_DIR="$( pwd )"



#
# Known public keys of SSH servers.
#
DBW_HOST_KEYS=(
    "ssh.student.bth.se ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBER6Y1R4EmZZfJD9L//cHo/PEVgBOg/jEwgwdPmL9pBc4e6QtHT1Lgnp5sAi+OgA2P0uQU4UJ0qVAhNAUA8SCLE="
)



# What is the directory of the current course repo, find recursivly up the tree
DBW_COURSE_FILE_NAME=".dbwebb.course"

dir="$DBW_CURRENT_DIR/."
while [ "$dir" != "/" ]; do
    dir=$( dirname "$dir" )
    found="$( find "$dir" -maxdepth 1 -name $DBW_COURSE_FILE_NAME )"
    if [ "$found" ]; then
        DBW_COURSE_DIR="$( dirname "$found" )"
        break
    fi
done



#
# Get the name of the course as $DBW_COURSE
#
function sourceCourseRepoFile
{
    DBW_COURSE_FILE="$DBW_COURSE_DIR/$DBW_COURSE_FILE_NAME"
    DBW_COURSE_REPO_VALID=""
    if [ -f "$DBW_COURSE_FILE" ]; then
        DBW_COURSE_REPO_VALID="yes"
        source "$DBW_COURSE_FILE"
    fi
}

# Get the name of the course as $DBW_COURSE
sourceCourseRepoFile



#
# Get the name of the course as $DBW_COURSE
#
function sourceDbwebbVersionFile
{
    DBW_VERSION_FILE="$DBW_COURSE_DIR/$DBW_VERSION_FILE_NAME"
    DBW_VERSION_REQUIREMENT=""
    if [ -f "$DBW_VERSION_FILE" ]; then
        DBW_VERSION_REQUIREMENT=$(< "$DBW_VERSION_FILE" )
    fi
}

# Get the proposed minimum version for dbwebb-cli in current course repo
DBW_VERSION_FILE_NAME=".dbwebb/cli.version"
sourceDbwebbVersionFile



# Where is the .dbwebb.config-file
DBW_CONFIG_FILE_NAME=".dbwebb.config"

# Check if run as sudo, use SUDO_USER as HOME (only for selfupdate)
if [[ $SUDO_USER ]]; then
    DBW_CONFIG_FILE=$( eval echo "~$SUDO_USER/$DBW_CONFIG_FILE_NAME" )
else
    DBW_CONFIG_FILE="$HOME/$DBW_CONFIG_FILE_NAME"
fi

if [ -f "$DBW_CONFIG_FILE" ]; then
    source "$DBW_CONFIG_FILE"
fi



# Detect if ssh-key is available
DBW_SSH_KEY_OPTION=""
if [ -f "$DBW_SSH_KEY" ]
then
    DBW_SSH_KEY_OPTION="-i '$DBW_SSH_KEY'"
fi



# Check OS
DBW_OS="$( uname -a )"

# Create the ssh-command with details from the config-file
SSH_CMD="ssh ${DBW_USER}@${DBW_HOST} $DBW_SSH_KEY_OPTION"
SSH_CMD_INTERACTIVE="ssh ${DBW_USER}@${DBW_HOST} $DBW_SSH_KEY_OPTION"

# Default chmod for rsync-command
RSYNC_CHMOD="--chmod=Du+rwx,Dgo+rx,Fu+rw,Fgo+r"

# Prefer using file to exclude from
RSYNC_EXCLUDE="$DBW_COURSE_DIR/.dbwebb/upload.exclude"
if [ -f "$RSYNC_EXCLUDE" ]; then
    RSYNC_EXCLUDE="--exclude-from='$RSYNC_EXCLUDE'"
else
    RSYNC_EXCLUDE="--exclude .git --exclude .gitignore --exclude literature --exclude tutorial --exclude slide --exclude .solution --exclude old --exclude .default --exclude platforms/ --exclude coverage/ --exclude .DS_Store --exclude npm-debug.log"
fi

# Use filt to include from, if available
RSYNC_INCLUDE="$DBW_COURSE_DIR/.dbwebb/upload.include"
if [ -f "$RSYNC_INCLUDE" ]; then
    RSYNC_INCLUDE="--include-from='$RSYNC_INCLUDE'"
else
    RSYNC_INCLUDE=
fi

# Create the basis for the upload command
RSYNC_CMD="rsync -av $RSYNC_CHMOD $RSYNC_INCLUDE $RSYNC_EXCLUDE --delete --delete-excluded -e \"ssh $DBW_SSH_KEY_OPTION\""
RSYNC_DOWNLOAD_DELETE_CMD="rsync -avc $RSYNC_CHMOD --delete --delete-excluded -e \"ssh $DBW_SSH_KEY_OPTION\""
RSYNC_DOWNLOAD_CMD="rsync -avuc $RSYNC_CHMOD -e \"ssh $DBW_SSH_KEY_OPTION\""

DBW_REMOTE_DESTINATION="${DBW_USER}@${DBW_HOST}:$DBW_REMOTE_BASEDIR/$DBW_COURSE"
DBW_REMOTE_WWW_DESTINATION="${DBW_USER}@${DBW_HOST}:$DBW_REMOTE_WWWDIR/$DBW_COURSE"

DBW_WWW="https://dbwebb.se/"
DBW_VALIDATE_CONFIGFILE="/home/saxon/students/dbwebb/dbwebb-general-config"
#DBW_INSPECT_CONFIGFILE="/home/saxon/students/dbwebb/dbwebb-general-config"
DBW_ARCHIVE="/home/saxon/students/dbwebb/archive/"


# Ass arrays not supporter on mac bash v3.
#declare -A DBW_REPOS
#DBW_REPOS[python]="https://github.com/mosbth/python"
#DBW_REPOS[javascript1]="https://github.com/mosbth/javascript1"
#DBW_REPOS[linux]="https://github.com/mosbth/linux"
#DBW_REPOS[webapp]="https://github.com/mosbth/webapp"
#DBW_REPOS[htmlphp]="https://github.com/mosbth/htmlphp"
DBW_COURSE_REPOS=( 'python' 'javascript1' 'linux' 'webapp' 'oopython' 'htmlphp' 'design' 'oophp' 'phpmvc' 'javascript' 'webgl' 'dbjs' 'ramverk1' 'ramverk2' 'databas' 'matmod' 'exjobbd' 'jsramverk' 'vlinux' 'devops' 'itsec' 'unix' 'js' 'mvc' 'pattern' 'webtec')
DBW_REPO="dbwebb-cli"


# --------------- DBWEBB BOOTSTRAP PHASE END ---------------
