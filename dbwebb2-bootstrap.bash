# --------------- DBWEBB BOOTSTRAP PHASE START ---------------

#
# Specify the utilities used
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


# Revise these
UPLOAD="$RSYNC -av --delete --exclude literature --exclude .git -e \"ssh $DBW_SSH_KEY_OPTION\" \"$SOURCE\" \"$DESTINATION\""
UPLOAD_MINIMAL="$RSYNC -av --delete --exclude me --exclude tutorial --exclude example --exclude literature --exclude .git -e \"ssh $DBW_SSH_KEY_OPTION\" \"$SOURCE\" \"$DESTINATION\""


# Settins
MSG_OK="\033[0;30;42mOK\033[0m"
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

# Where is the installation directory
#DBW_CLIDIR="dbwebb-cli"
#DBW_VERSION_FILE_NAME=".dbwebb.version"

#if [ -f "$DBW_EXECUTABLE_DIR/$DBW_VERSION_FILE_NAME" ]; then
#    DBW_INSTALL_DIR="$DBW_EXECUTABLE_DIR"
#elif [ -d "$DBWEBB_HOME" -a -d "$DBWEBB_HOME/$DBW_CLIDIR" ]; then
#    DBW_INSTALL_DIR="$DBWEBB_HOME/$DBW_CLIDIR"
#elif [ -d "$DBWEBB_CLI_HOME" ]; then
#    DBW_INSTALL_DIR="$DBWEBB_CLI_HOME"
#elif [ -d "$HOME/$DBW_BASEDIR/$DBW_CLIDIR" ]; then
#    DBW_INSTALL_DIR="$HOME/$DBW_BASEDIR/$DBW_CLIDIR"
#else 
#    $ECHO "$MSG_FAILED Could not determine the installation directory. I tried tried the environment variables \$DBWEBB_HOME and \$DBWEBB_CLI_HOME and looked in \$HOME/$DBW_BASEDIR/$DBW_CLIDIR.\n"
#    exit 1
#fi



# Get the current version installed as $DBW_VERSION
#DBW_VERSION_FILE="$DBW_INSTALL_DIR/$DBW_VERSION_FILE_NAME"
#if [ ! -f "$DBW_VERSION_FILE" ]; then
#    $ECHO "$MSG_FAILED Missing file $DBW_VERSION_FILE_NAME. The installation directory does not contain a valid installation.\n"
#    exit 1
#fi
#source "$DBW_VERSION_FILE"



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



# Where is the directory for the course repos, if any
#DBW_BASEDIR="dbwebb-kurser"
#if [ -d "$DBWEBB_HOME" ]; then
#    DBW_HOME="$DBW_BASEDIR"
#elif [ -d "$HOME/$DBW_BASEDIR" ]; then
#    DBW_HOME="$HOME/$DBW_BASEDIR"
#fi



# Get the name of the course as $DBW_COURSE
DBW_COURSE_FILE="$DBW_COURSE_DIR/$DBW_COURSE_FILE_NAME"
DBW_COURSE_REPO_VALID=""
if [ -f "$DBW_COURSE_FILE" ]; then
    DBW_COURSE_REPO_VALID="yes"
    source "$DBW_COURSE_FILE"
fi



# Where is the .dbwebb.config-file
DBW_CONFIG_DEFAULT_FILE="$DBW_INSTALL_DIR/dbwebb2-config-sample"
DBW_CONFIG_FILE_NAME=".dbwebb.config"
DBW_CONFIG_FILE="$HOME/$DBW_CONFIG_FILE_NAME"
if [ ! -f "$DBW_CONFIG_FILE" ]; then

    # If the command is to init-repo, then execute that and create a config-file
    if [ "$1" = "init-repo" ]; then
        createConfig
        exit 0
    fi
else
    source "$DBW_CONFIG_FILE"
fi

# Check OS
DBW_OS="$( uname -a )"

# Create the ssh-command with details from the config-file
SSH_CMD="$SSH ${DBW_USER}@${DBW_HOST} $DBW_SSH_KEY_OPTION"

# Create the basis for the upload command
RSYNC_CMD="$RSYNC -av --delete --exclude .git --exclude .gitignore -e \"ssh $DBW_SSH_KEY_OPTION\""
RSYNC_DOWNLOAD_CMD="$RSYNC -avu -e \"ssh $DBW_SSH_KEY_OPTION\""

DBW_REMOTE_DESTINATION="${DBW_USER}@${DBW_HOST}:$DBW_BASEDIR/$DBW_COURSE"



# --------------- DBWEBB BOOTSTRAP PHASE END ---------------
