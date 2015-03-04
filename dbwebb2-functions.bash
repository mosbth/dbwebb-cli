# --------------- DBWEBB FUNCTIONS PHASE START ---------------

#
# Create the config file .dbwebb.config.
#
function createConfig()
{
    local first=$1
    local noInput=$2
    local acronym
    local remoteHost

    if [ -z $first ]
    then

        printf "The config-file '$DBW_CONFIG_FILE_NAME' will now be created in your home directory: '$HOME'"

    elif [ $first = "update" ]
    then

        printf "Your config file will be automatically updated. Then re-run your command.\n"

    elif [ $first = "upgrade" ]
    then

        printf "Your config file will be automatically updated."

    elif [ $first = "create" ]
    then

        printf "I will now re-create the configuration file '$DBW_CONFIG_FILE_NAME' in your home directory: '$HOME'."

    fi


    if [[ ! $noInput ]]; then
        DBW_USER=${DBW_USER:-$USER}
        printf "\nWhat is your student acronym? [$DBW_USER] "
        read acronym
    fi

    acronym=${acronym:-$DBW_USER}
    remoteHost=${remoteHost:-ssh.student.bth.se}

    echo "DBW_USER='$acronym'"         > "$DBW_CONFIG_FILE"
    echo "DBW_HOST='$remoteHost'"     >> "$DBW_CONFIG_FILE"

    printf "$MSG_OK The config file '$DBW_CONFIG_FILE' is now up-to-date.\n"
}



#
# Check for installed commands
#
function checkCommand()
{
    local COMMAND="$1"

    if ! hash "$COMMAND" 2>/dev/null; then
        printf "Command $COMMAND not found."
    else 
        printf "$( which $COMMAND )"
    fi
}



#
# Execute a command in a controlled manner
#
function wget {
  if command wget -h &>/dev/null
  then
    command wget "$@"
  else
    set "${*: -1}"
    lynx -source "$1" > "${1##*/}"
  fi
}



#
# Execute a command in a controlled manner
#
executeCommand()
{
    INTRO="$1"

    if [ $SKIP_READLINE = "no" ]
    then
        printf "$INTRO"
        printf "\nPress enter/return to continue..."
        read void
    fi

    REALLY="$4"
    if [ ! -z $REALLY ]
    then
        printf "\nAre you really sure? [yN] "
        read answer
        default="n"
        answer=${answer:-$default}

        if [ ! \( "$answer" = "y" -o "$answer" = "Y" \) ]
        then
            printf "Exiting...\n"
            exit 0
        fi
    fi

    COMMAND=$2

    if [ $VERY_VERBOSE = "yes" ]
    then
        printf "\nExecuting command:"
        printf "\n$COMMAND"
        printf "\n-----------------------------------------"
        printf "\n"
    fi

    bash -c "$COMMAND"
    STATUS=$?

    if [ $VERY_VERBOSE = "yes" ]
    then
        printf "\n-----------------------------------------"
    fi

    MESSAGE=$3
    if [ $STATUS = 0 ]
    then
        printf "\n$MSG_OK $MESSAGE"
    else
        printf "\n$MSG_FAILED $MESSAGE"
    fi
    printf "\n"

    return $STATUS
}



#
# Check if within a valid course repo or exit
#
function checkIfValidCourseRepoOrExit()
{
    if [ "$DBW_COURSE_REPO_VALID" != "yes" ]; then
        printf "$MSG_FAILED Could not find file '$DBW_COURSE_FILE_NAME', this is not a valid course repo."
        printf "\nThis command must be executed within a valid course repo."
        printf "\n"
        exit 1
    fi
}



#
# Set proper rights for files and directories
#
setChmod()
{
    if [ $VERY_VERBOSE = "yes" ]; then
        printf "\nEnsuring that all files and directories are readable for all, below $DBW_COURSE_DIR."
    fi

    $FIND "$DBW_COURSE_DIR" -type d -exec chmod u+rwx,go+rx {} \;  
    $FIND "$DBW_COURSE_DIR" -type f -exec chmod u+rw,go+r {} \;   
}



#
# Convert course specific module to path on disk
#
mapCmdToDir()
{
    local CMD="$1"
    local RES=""

    if [ -z "$CMD" ]; then 
        return
    fi 

    case "$CMD" in
        example)    RES="example" ;;
        tutorial)   RES="tutorial" ;;
        me)         RES="me" ;;
        kmom01)     RES="me/kmom01" ;;
        kmom02)     RES="me/kmom02" ;;
        kmom03)     RES="me/kmom03" ;;
        kmom04)     RES="me/kmom04" ;;
        kmom05)     RES="me/kmom05" ;;
        kmom06)     RES="me/kmom06" ;;
        kmom10)     RES="me/kmom10" ;;
    esac

    if [ ! -z $RES ]; then 
        printf "$RES"
        return
    fi 

    case "$DBW_COURSE" in
        htmlphp)
            case "$CMD" in
                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom05/lab4" ;;
                lab5)       RES="me/kmom06/lab5" ;;
            esac
            ;;

        python)
            case "$CMD" in
                hello)      RES="me/kmom01/hello" ;;
                plane)      RES="me/kmom01/plane" ;;

                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom05/lab4" ;;
                lab5)       RES="me/kmom06/lab5" ;;
                lab6)       RES="me/kmom06/lab6" ;;

                marvin1)    RES="me/kmom02/marvin1" ;;
                marvin2)    RES="me/kmom03/marvin2" ;;
                marvin3)    RES="me/kmom04/marvin3" ;;
                marvin4)    RES="me/kmom05/marvin4" ;;
                marvin5)    RES="me/kmom06/marvin5" ;;

                game1)      RES="me/kmom04/game1" ;;
                game2)      RES="me/kmom05/game2" ;;
                game3)      RES="me/kmom06/game3" ;;

                adventure)  RES="me/kmom10/adventure" ;;
            esac
            ;;

        javascript1)
            case "$CMD" in
                sandbox)      RES="me/kmom01/sandbox" ;;
                hangman)      RES="me/kmom06/hangman" ;;
                intelligence) RES="me/kmom10/intelligence" ;;

                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom04/lab4" ;;
                lab5)       RES="me/kmom05/lab5" ;;

                flag1)      RES="me/kmom02/flag1" ;;
                flag2)      RES="me/kmom03/flag2" ;;
                flag3)      RES="me/kmom04/flag3" ;;
                flag4)      RES="me/kmom05/flag4" ;;
                flag5)      RES="me/kmom06/flag5" ;;

                baddie1)    RES="me/kmom02/baddie1" ;;
                baddie2)    RES="me/kmom03/baddie2" ;;
                baddie3)    RES="me/kmom04/baddie3" ;;
                #baddie4)    RES="me/kmom05/baddie4" ;;
                #baddie5)    RES="me/kmom06/baddie5" ;;
            esac
            ;;

        linux)
            case "$CMD" in
                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom05/lab4" ;;
                lab5)       RES="me/kmom06/lab5" ;;
            esac
            ;;

        webapp)
            case "$CMD" in
                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom05/lab4" ;;
                lab5)       RES="me/kmom06/lab5" ;;
            esac
            ;;
    esac

    printf "$RES"
    return
}



#
# Get path to dir to check, use both parts of courses and fallback
# to absolute and relative paths.
#
function getPathToDirectoryFor()
{
    local dir="$( mapCmdToDir $1 )" 
    
    if [ -z "$command" ]; then
        echo "$DBW_CURRENT_DIR"
    elif [ -z "$dir" -a -d "$command" ]; then
        echo "$command"
    elif [ -z "$dir" -a -d "$DBW_CURRENT_DIR/$command" ]; then
        echo "$DBW_CURRENT_DIR/$command"
    elif [ -d "$DBW_COURSE_DIR" -a -d "$DBW_COURSE_DIR/$dir" ]; then
        echo "$DBW_COURSE_DIR/$dir"
    else 
        printf "\n$MSG_FAILED The item '$command' was mapped to directory '$dir' which is not a valid directory."
        printf "\n"
        exit 1
    fi
}



#
# Validate the uploaded files
#
createUploadDownloadPaths()
{
    SUBDIR="$( mapCmdToDir $ITEM )"

    if [ -z "$WHAT" -o -z "$WHERE" ]; then
        printf "$MSG_FAILED Missing argument for source or destination. Perhaps re-create the config-file?"
        printf "\n\n"
        exit 1
    fi

    if [ ! -z "$ITEM" -a -z "$SUBDIR" ]; then
        printf "\n$MSG_FAILED Not a valid combination  course: '$DBW_COURSE' and item: '$ITEM'."
        printf "\n\n"
        exit 1
    fi

    if [ ! -z "$SUBDIR" ]; then
        WHAT="$WHAT/$SUBDIR/"
        WHERE="$WHERE/$SUBDIR/"
    else
        WHAT="$WHAT/"
        WHERE="$WHERE/"
    fi

    if [ ! -d "$WHAT" ]; then
        printf "\n$MSG_FAILED Target directory is not a valid directory: '$WHAT'"
        printf "\n\n"
        exit 1
    fi
}



#
# Validate and Publish the uploaded files
#
publishResults()
{
    WHAT="$1"
    WHERE="$2"
    ITEM="$3"
    SUBDIR=""

    createUploadDownloadPaths

    local LOG="$HOME/.dbwebb-publish.log"
    local INTRO="I will now try to init the remote server and create a directory where all uploaded files will reside."
    local COMMAND1="$RSYNC_CMD '$WHAT' '$WHERE'"
    local COMMAND2="$SSH_CMD 'cd $DBW_BASEDIR/$DBW_COURSE; dbwebb-validate $IGNORE_FAULTS $WHAT' | tee '$LOG';"
    local MESSAGE="to validate and publish all course results. Saved a log of the output, review it as:\nless -R $LOG"
    executeCommand "$INTRO" "$COMMAND1; $COMMAND2" "$MESSAGE"

    if [ $? -eq 0 ]
    then
        printf "Your files are now"
    else
        printf "Some of your files might be"
    fi
    printf " published on $DBW_BASEURL"
    printf "\n"
}



#
# Inspect uploaded files
#
inspectResults()
{
    WHAT=$1
    WHO=$2
    INTRO="I will now inspect the choosen kmom for the choosen user, if you have privilegies to do that."
    LOG="$HOME/.dbwebb-inspect.log"
    COMMAND="$SSH_CMD 'cd $DBW_BASEDIR/$DBW_COURSE; bin/dbwebb-inspect $WHAT $WHO' | tee '$LOG'; "
    MESSAGE="to inspect the course results. Saved a log of the output, review it as:\nless -R '$LOG'"

    #COMMAND="$SSH_CMD 'cd $DBW_BASEDIR/$DBW_COURSE; bin/dbwebb-inspect $WHAT $WHO'"
    #MESSAGE="to inspect the course results."

    #if [ "$USER" = "$WHO" ]
    #then
        #upload="$UPLOAD"
    #else
        #upload="$UPLOAD_MINIMAL"
    #fi

    #executeCommand "$INTRO" "$upload; $COMMAND" "$MESSAGE"
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



# --------------------- To be validated -------------------------------


#
# Create a lab
#
createLab()
{
    LAB="$1"
    INTRO="Create laboration $LAB."
    COMMAND="bin/dbwebb-create \"$LAB\""
    MESSAGE="to create the lab."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}




# -----------------------PERHAPS USE THES LATER ON BUT NOT FOR NOW -----------------------

#
# Upload results to the server
#
uploadToServer()
{
    subdir=${DBW_CURRENT_DIR#"$DBW_COURSE_DIR/"}

    INTRO="Your current working directory '$DBW_CURRENT_DIR' will now be uploaded to remote server."
    COMMAND="$RSYNC_CMD '$DBW_CURRENT_DIR/' '$DBW_REMOTE_DESTINATION/$subdir/'"
    MESSAGE="to upload files."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Download from the server
#
downloadFromServer()
{
    subdir=${DBW_CURRENT_DIR#"$DBW_COURSE_DIR/"}

    INTRO="WARNING: Downloading remote '$DBW_REMOTE_DESTINATION/$subdir/\n         to the current working directory '$DBW_CURRENT_DIR/'.\nWARNING: Local files MAY BE overwritten."
    COMMAND="$RSYNC_CMD '$DBW_REMOTE_DESTINATION/$subdir/' '$DBW_CURRENT_DIR/'"
    MESSAGE="to download files."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE" "REALLY?"
}


#------------------------- HERE ARE THE MAIN COMMANDS -------------------------------


#
# Create default files.
#
function dbwebb-init-me()
{
    local meDefault="$DBW_COURSE_DIR/.default/"
    local me="$DBW_COURSE_DIR/me/"

    local intro="Initiating the directory 'me/' by copying directory structure and files from the directory '.default/' (will not overwrite existing files)."
    local command="$RSYNC -av --exclude README.md --ignore-existing \"$meDefault\" \"$me\""
    local message="to init the directory 'me/'."

    checkIfValidCourseRepoOrExit
    executeCommand "$intro" "$command" "$message"
}



#
# Init directory structure at the server.
#
function dbwebb-init-server()
{    
    local intro="Intiating the remote server '$DBW_HOST' by connecting as '$DBW_USER' and creating directories (if needed) where all uploaded files will reside."
    # TODO Should use DBW_BASEDIR 
    local command="$SSH_CMD 'sh -c \"if [ ! -d dbwebb-kurser ]; then mkdir dbwebb-kurser; fi; chmod 700 dbwebb-kurser; echo; echo \"dbwebb-kurser:\"; ls -l dbwebb-kurser; if [ ! -d www/dbwebb-kurser ]; then mkdir www/dbwebb-kurser; fi; chmod 755 www/dbwebb-kurser; echo; echo \"www/dbwebb-kurser:\"; ls -l www/dbwebb-kurser\"'"
    local message="to init the server."

    checkIfValidCourseRepoOrExit
    executeCommand "$intro" "$command" "$message"
}



#
# Create and use ssh-keys to login.
#
function dbwebb-sshkey()
{
    local sshkey="$HOME/.ssh/dbwebb"

    if [ ! -d "$HOME/.ssh" ]
    then
        mkdir "$HOME/.ssh"
    fi

    local intro="First we need to create a ssh key and store it locally."
    local command="ssh-keygen -t dsa -f '$sshkey' -N ''"
    local message="to create the ssh key."
    executeCommand "$intro" "$command" "$message"

    # Bug (?) om Cygwin & win 8
    # TODO refactor 
    if [ $IS_CYGWIN = "yes" ]
    then
        chgrp -vR "$CYGWIN_DEFAULT_GROUP" "$HOME/.ssh"
    fi

    chmod 700 "$HOME/.ssh"
    chmod 600 "$sshkey" "$sshkey.pub"

    intro="I will now install the ssh-key at the remote server."
    command="cat '$sshkey.pub' | ssh $DBW_USER@$DBW_HOST 'sh -c \"if [ ! -d .ssh ]; then mkdir .ssh; fi; chmod 700 .ssh; touch .ssh/authorized_keys; cat >> .ssh/authorized_keys\"'"
    message="to install the ssh-keys."    
    executeCommand "$intro" "$command" "$message"
}



#
# Login to the server
#
function dbwebb-login()
{
    local intro="I will now login to the server '$DBW_HOST' as '$DBW_USER' using ssh-keys if available."
    local command="$SSH_CMD"
    local message="to establish the connection."
    
    executeCommand "$intro" "$command" "$message"
}



#
# Update course repo to latest version
#
function dbwebb-update()
{
    local intro="Update course-repo with latest changes from its master at GitHub."
    local command="$GIT pull"
    local message="to update course repo."
    
    checkIfValidCourseRepoOrExit
    executeCommand "$intro" "$command" "$message"
}



#
# Display information on the environment
#
function dbwebb-check()
{
    printf "Details on installed utilities."
    printf "\n------------------------------------"
    printf "\nbash:                  %s" "$( checkCommand $BASH )"
    printf "\ngit:                   %s" "$( checkCommand $GIT )"
    printf "\nssh:                   %s" "$( checkCommand $SSH )"
    printf "\nrsync:                 %s" "$( checkCommand $RSYNC )"
    printf "\nwget:                  %s" "$( checkCommand $WGET )"
    printf "\ncurl:                  %s" "$( checkCommand $CURL )"
    printf "\n"

    printf "\nDetails on the dbwebb-environment."
    printf "\n------------------------------------"
    printf "\nOperatingsystem:       $DBW_OS"
    printf "\nCommand issued:        $DBW_EXECUTABLE"
    printf "\nVersion of dbwebb is:  $DBW_VERSION"
    printf "\nPath to executable:    '$DBW_EXECUTABLE_DIR'"
    printf "\nConfig-file:           '$DBW_CONFIG_FILE'"
    printf "\nWorking directory:     '$DBW_CURRENT_DIR'"
    printf "\nLocal user:            '$USER'"
    printf "\nLocal homedir:         '$HOME'"
    printf "\nRemote user:           '$DBW_USER'"
    printf "\nRemote host:           '$DBW_HOST'"
    printf "\n"

    printf "\nDetails on current course-repo."
    printf "\n------------------------------------"

    if [ "$DBW_COURSE_REPO_VALID" = "yes" ]; then
        printf "\nCurrent course-repo:   '$DBW_COURSE'"
        printf "\nCourse directory:      '$DBW_COURSE_DIR'"
        printf "\nCourse-repo version:   $( $GIT describe --always )"
        printf "\n\nLatest update to course repo was:"
        printf "\n"
        $GIT log -1
    else 
        printf "\nThis is not a valid course repo."
    fi
    printf "\n"
    printf "\n"
}



#
# Create or re-create the config file.
#
function dbwebb-config()
{
    createConfig
}



#
# Push/upload results to the server
#
function dbwebb-upload()
{
    #pushToServer "" "$" "$2"
    
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths
    setChmod

    local intro="Uploading the directory '$WHAT' to '$WHERE'."
    local command="$RSYNC_CMD '$WHAT' '$WHERE'"
    local message="to upload data."
    executeCommand "$intro" "$command" "$message"
}



#
# Pull/download from the server
#
function dbwebb-download()
{
    #pullFromServer "$DBW_COURSE_DIR" "$DBW_REMOTE_DESTINATION" "$2"
    
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths

    local intro="Downloading the directory '$WHERE' to '$WHAT'.\nExisting local files that are newer will not be overwritten."
    local command="$RSYNC_DOWNLOAD_CMD '$WHERE' '$WHAT'"
    local message="to download data."
    executeCommand "$intro" "$command" "$message" "really?"
}



#
# Validate the uploaded files
#
function dbwebb-validate()
{
    WHAT="$1"
    WHERE="$2"
    ITEM="$3"
    SUBDIR=""

    createUploadDownloadPaths
    setChmod

    local LOG="$HOME/.dbwebb-validate.log"
    local INTRO="I will now upload files to the remote server and validate them."
    local COMMAND1="$RSYNC_CMD '$WHAT' '$WHERE'"
    local COMMAND2="$SSH_CMD 'cd $DBW_BASEDIR/$DBW_COURSE; dbwebb-validate -n $IGNORE_FAULTS $WHAT' | tee '$LOG';"
    local MESSAGE="to validate course results. Saved a log of the output, review it as:\nless -R '$LOG'"
    executeCommand "$INTRO" "$COMMAND1; $COMMAND2" "$MESSAGE"
}



#
# Selfupdate
#
dbwebb-selfupdate()
{
    local INTRO="Selfupdating dbwebb-cli from https://github.com/mosbth/dbwebb-cli."
    local COMMAND="wget https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2 -O /tmp/$$; install /tmp/$$ /usr/local/bin/dbwebb; rm /tmp/$$"
    local MESSAGE="to update dbwebb installation."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
    
    printf "\nCurrent version is:\n"
    dbwebb --version
}



# --------------- DBWEBB FUNCTIONS PHASE END ---------------
