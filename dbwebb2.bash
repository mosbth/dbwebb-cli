#!/bin/bash

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



#
# Find my environment, before any work can be done
#

# For early error messages, also exists in .dbwebb.config
MSG_FAILED="\033[0;37;41mFAILED.\033[0m"

# What was the command issued?
DBW_EXECUTABLE="$( basename "$0" )"

# Where is the executable
DBW_EXECUTABLE_DIR="$( dirname "$0" )"

# Where is the installation directory
DBW_BASEDIR="dbwebb-kurser"
DBW_CLIDIR="dbwebb-cli"
DBW_VERSION_FILE_NAME=".dbwebb.version"

if [ -f "$DBW_EXECUTABLE_DIR/$DBW_VERSION_FILE_NAME" ]; then
    DBW_INSTALL_DIR="$DBW_EXECUTABLE_DIR"
elif [ -d "$DBWEBB_HOME" -a -d "$DBWEBB_HOME/$DBW_CLIDIR" ]; then
    DBW_INSTALL_DIR="$DBWEBB_HOME/$DBW_CLIDIR"
elif [ -d "$DBWEBB_CLI_HOME" ]; then
    DBW_INSTALL_DIR="$DBWEBB_CLI_HOME"
elif [ -d "$HOME/$DBW_BASEDIR/$DBW_CLIDIR" ]; then
    DBW_INSTALL_DIR="$HOME/$DBW_BASEDIR/$DBW_CLIDIR"
else 
    $ECHO "$MSG_FAILED Could not determine the installation directory. I tried tried the environment variables \$DBWEBB_HOME and \$DBWEBB_CLI_HOME and looked in \$HOME/$DBW_BASEDIR/$DBW_CLIDIR.\n"
    exit 1
fi



# Get the current version installed as $DBW_VERSION
DBW_VERSION_FILE="$DBW_INSTALL_DIR/$DBW_VERSION_FILE_NAME"
if [ ! -f "$DBW_VERSION_FILE" ]; then
    $ECHO "$MSG_FAILED Missing file $DBW_VERSION_FILE_NAME. The installation directory does not contain a valid installation.\n"
    exit 1
fi
source "$DBW_VERSION_FILE"



# Include the functions needed
DBW_FUNCTIONS_FILE="$DBW_INSTALL_DIR/dbwebb2-functions.bash"
source "$DBW_FUNCTIONS_FILE"



# What is the current directory
DBW_CURRENT_DIR="$( pwd )"



# What is the directory of the current course repo, find recursivly up the tree
DBW_COURSE_FILE_NAME=".dbwebb.course"

dir="$DBW_CURRENT_DIR/."
while [ "$dir" != "/" ]; do 
    dir=$( dirname "$dir" )
    found="$( find "$dir" -maxdepth 1 -name $DBW_COURSE_FILE_NAME )"
    if [ "$found" ]; then 
        DBW_COURSE_DIR="$( dirname $found )"
        break
    fi
done



# Where is the directory for the course repos, if any
if [ -d "$DBWEBB_HOME" ]; then
    : # Ok
elif [ -d "$HOME/$DBW_BASEDIR" ]; then
    DBWEBB_HOME="$HOME/$DBW_BASEDIR"
fi



# Get the name of the course as $DBW_COURSE
DBW_COURSE_FILE="$DBW_COURSE_DIR/$DBW_COURSE_FILE_NAME"
DBW_COURSE_REPO_VALID="no"
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



#
# Main, start by checking basic usage
#
if [ $# -lt 1 ]
then
    dbwebb2PrintShortUsage
    exit 0
fi



# 
# Try for commands that does not use or update the config file.
#
CMD=$1
case $CMD in

    help)
        dbwebb2PrintUsage
        exit 0
        ;;

    create-config)
        createConfig
        exit 0
        ;;

    env|environment|status)
        environment # Partly needs config
        exit 0
        ;;

    version)
        $ECHO "$VERSION\n"
        exit 0
        ;;

    ls)
        lsHome
        exit 0
        ;;

    repo|repos)
        reposList
        exit 0
        ;;

    clone)
        if [ -z "$2" ]; then
            $ECHO "\n$MSG_FAILED missing argument for repo name."
            $ECHO "\n"
            dbwebb2PrintShortUsage
            exit 1
        fi
        reposClone "$2"
        exit 0
        ;;
esac
    elif [ -z "$repo" ]; then



#
# Get options
#
SKIP_READLINE="no"
IGNORE_FAULTS="-i"
VERY_VERBOSE="no"

while getopts "hivwy" opt
do
    case $opt in
        h)
            dbwebb2PrintUsage
            exit 0
            ;;

        i)
            dbwebb2PrintUsageInspect
            exit 0
            ;;

        v)
            VERY_VERBOSE="yes"
            ;;

        y)
            SKIP_READLINE="yes"
            ;;

        \?)
            dbwebb2PrintShortUsage
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))


# Check if config file is up to date
updateConfigIfNeeded "update"



# 
# Try for commands that does not need to be executed within a valid course repo.
#
CMD=$1
case $CMD in

    config)
        createConfig "create"
        exit 0
        ;;

    login)
        loginToServer
        exit 0
        ;;

    selfupdate|self-update)
        selfUpdate
        exit 0
        ;;

    sshkey)
        installSshKeys
        exit 0
        ;;
esac



#if [ "$DBW_COURSE_REPO_VALID" != "yes" ]; then

#    $ECHO "$MSG_FAILED Could not find file $DBW_COURSE_FILE_NAME, this is not a valid course repo."
#    $ECHO "\nThis command must be executed within a course repo."
#    $ECHO "\n"
#    exit 1
#fi

#$ECHO "$MSG_FAILED Missing the file $DBW_CONFIG_FILE_NAME. This does NOT appear to be a valid course repo.\nHave you initiated this as a course repo? Run the following command in the root of the course repo:\n$DBW_EXECUTABLE init-repo\n\n"
#exit 1


#
# Execute command
#
CMD=$1
case $CMD in

    init-repo)
        createConfig
        ;;

    init-me)
        createDefaultFiles
        ;;

    init-server)
        initServer
        ;;

    push)
        pushToServer "$DBW_COURSE_DIR" "$DBW_REMOTE_DESTINATION" "$2"
        ;;

    pull)
        pullFromServer
        ;;

    init)
        initServer
        createDefaultFiles
        #uploadToServer
        ;;

    update)
        updateFromMaster
        ;;

    upload)
        setChmod
        uploadToServer
        ;;

    download)
        downloadFromServer
        ;;

    create)
        LAB="$2"
        if [ -z "$LAB" ]
        then
            echo "Missing name for lab, perhaps use lab1, lab2 or lab3?"
            exit 1
        fi
        createLab "$LAB"
        ;;

    validate)
        WHICH=$2
        validateUploadedResults ${WHICH:=all}
        ;;

    publish)
        WHICH=$2
        publishResults ${WHICH:=all}
        ;;

    inspect)
        WHICH=$2
        WHO=$3
        inspectResults ${WHICH:=all} ${WHO:=$USER}
        ;;

    *)
        dbwebb2PrintShortUsage
        exit 1
        ;;
esac


