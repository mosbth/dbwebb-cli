# --------------- DBWEBB BOOTSTRAP PHASE START ---------------

#
# Specify the utilities used
# TODO Remove these, not really needed.
#
ECHO="printf"
GIT="git"
RSYNC="rsync"
SSH="ssh"
SED="sed"
WGET="wget"
CURL="curl"
BASH="bash"
FIND="find"

# Settins
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
DBW_EXECUTABLE="$( basename "$0" )"

# Where is the executable
DBW_EXECUTABLE_DIR="$( dirname "$0" )"

# What is the current directory
DBW_CURRENT_DIR="$( pwd )"



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
function sourceCourseRepoFile()
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



# Where is the .dbwebb.config-file
DBW_CONFIG_FILE_NAME=".dbwebb.config"
DBW_CONFIG_FILE="$HOME/$DBW_CONFIG_FILE_NAME"
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
SSH_CMD="$SSH ${DBW_USER}@${DBW_HOST} $DBW_SSH_KEY_OPTION"

# Create the basis for the upload command
RSYNC_CMD="$RSYNC -av --delete --exclude .git --exclude .gitignore -e \"ssh $DBW_SSH_KEY_OPTION\""
RSYNC_DOWNLOAD_CMD="$RSYNC -avu -e \"ssh $DBW_SSH_KEY_OPTION\""

DBW_REMOTE_DESTINATION="${DBW_USER}@${DBW_HOST}:$DBW_REMOTE_BASEDIR/$DBW_COURSE"



# --------------- DBWEBB BOOTSTRAP PHASE END ---------------
