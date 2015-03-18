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
    sshKey=${sshKey:-\$HOME/.ssh/dbwebb}
    remoteDir=${remoteDir:-dbwebb-kurser}
    remoteWww=${remoteWww:-www/dbwebb-kurser}
    baseurl=${baseurl:-http://www.student.bth.se/~$acronym/$remoteDir}
    laburl=${laburl:-http://www.student.bth.se/~mosstud/kod-exempel/lab}

    echo "DBW_USER='$acronym'"               > "$DBW_CONFIG_FILE"
    echo "DBW_HOST='$remoteHost'"           >> "$DBW_CONFIG_FILE"
    echo "DBW_SSH_KEY=\"$sshKey\""          >> "$DBW_CONFIG_FILE"
    echo "DBW_REMOTE_BASEDIR='$remoteDir'"  >> "$DBW_CONFIG_FILE"
    echo "DBW_REMOTE_WWWDIR='$remoteWww'"   >> "$DBW_CONFIG_FILE"
    echo "DBW_BASEURL='$baseurl'"           >> "$DBW_CONFIG_FILE"
    echo "DBW_LABURL='$laburl'"             >> "$DBW_CONFIG_FILE"

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

    if [[ ! $SKIP_READLINE ]]
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

    COMMAND="$2"

    if [[ $VERY_VERBOSE ]]
    then
        printf "\nExecuting command:"
        printf "\n$COMMAND"
        printf "\n-----------------------------------------"
        printf "\n"
    fi

    bash -c "$COMMAND"
    STATUS=$?

    if [[ $VERY_VERBOSE ]]
    then
        printf "\n-----------------------------------------"
        printf "\n"
    fi

    MESSAGE=$3
    if [ $STATUS = 0 ]
    then
        printf "$MSG_DONE $MESSAGE"
    else
        printf "$MSG_FAILED $MESSAGE"
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
# Check if config file or exit
#
function checkIfValidConfigOrExit()
{
    if [ ! -f "$DBW_CONFIG_FILE" ]; then
        printf "$MSG_FAILED Could not find the configuration file '$DBW_CONFIG_FILE', this is needed for this operation."
        printf "\n"
        exit 1
    fi
}



#
# Set proper rights for files and directories
#
setChmod()
{
    if [[ $VERY_VERBOSE ]]; then
        printf "Ensuring that all files and directories are readable for all, below $DBW_COURSE_DIR.\n"
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

    if [ -d "$DBW_CURRENT_DIR/$ITEM" ]; then
        SUBDIR="${ITEM%/}"
    elif [ ! -z "$ITEM" -a -z "$SUBDIR" ]; then
        printf "\n$MSG_FAILED Not a valid combination course: '$DBW_COURSE' and item: '$ITEM'."
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



#------------------------- HERE ARE THE MAIN COMMANDS -------------------------------


#
# Create default files.
#
function dbwebb-init-me()
{
    local meDefault="$DBW_COURSE_DIR/.default/"
    local me="$DBW_COURSE_DIR/me/"

    local intro="Creating and initiating the directory 'me/' by copying directory structure and files from the directory '.default/' (will not overwrite existing files)."
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
    local command="$SSH_CMD 'sh -c \"if [ ! -d \"$DBW_REMOTE_BASEDIR\" ]; then mkdir \"$DBW_REMOTE_BASEDIR\"; fi; chmod 700 \"$DBW_REMOTE_BASEDIR\"; echo; echo \"$DBW_REMOTE_BASEDIR:\"; ls -lF \"$DBW_REMOTE_BASEDIR\"; if [ ! -d \"$DBW_REMOTE_WWWDIR\" ]; then mkdir \"$DBW_REMOTE_WWWDIR\"; fi; chmod 755 \"$DBW_REMOTE_WWWDIR\"; echo; echo \"$DBW_REMOTE_WWWDIR:\"; ls -lF \"$DBW_REMOTE_WWWDIR\"\"'"
    local message="to init the server."

    checkIfValidConfigOrExit
    executeCommand "$intro" "$command" "$message"
}



#
# Init course repo and directory structure at the server.
#
function dbwebb-init()
{    
    dbwebb-init-me
    dbwebb-init-server
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

    printf "First we need to create a ssh key and store it locally."
    printf "\nPress enter/return to continue..."
    read void
    ssh-keygen -t dsa -f "$sshkey" -N ''
    
    # Bug (?) om Cygwin & win 8
    # TODO refactor 
    #if [ $IS_CYGWIN = "yes" ]; then
    #    chgrp -vR "$CYGWIN_DEFAULT_GROUP" "$HOME/.ssh"
    #fi

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
    
    checkIfValidConfigOrExit
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
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidConfigOrExit
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
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidConfigOrExit
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
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths
    setChmod

    local log="$HOME/.dbwebb-validate.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' for validation."
    local command1="$RSYNC_CMD '$WHAT' '$WHERE'"
    #local command2="$SSH_CMD 'cd \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\"; dbwebb-validate \"$SUBDIR\"' | tee '$log';"
    local command2="$SSH_CMD 'dbwebb-validate --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' | tee '$log';"
    local message="to validate course results.\nSaved a log of the output: less -R '$log'"
    executeCommand "$intro" "$command1; $command2" "$message"
}



#
# Publish the uploaded files
#
function dbwebb-publish()
{
    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths
    setChmod

    local log="$HOME/.dbwebb-publish.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' to validate and publish."
    local command1="$RSYNC_CMD '$WHAT' '$WHERE'"
    local command2="$SSH_CMD 'dbwebb-validate --publish --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" --publish-to \"$DBW_REMOTE_WWWDIR/$DBW_COURSE/$SUBDIR\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' | tee '$log';"
    local message="to validate and publish course results.\nSaved a log of the output: less -R '$log'"
    executeCommand "$intro" "$command1; $command2" "$message"

    if [ $? -eq 0 ]; then
        printf "Your files are now"
    else
        printf "Some of your files might be"
    fi
    printf " published on $DBW_BASEURL/$DBW_COURSE/$SUBDIR\n"
}



#
# Create a lab
#
dbwebb-create()
{
    local lab="$1"
    local subdir="$( mapCmdToDir $lab )"
    local where="$DBW_COURSE_DIR/$subdir"
    
    if [ -z "$subdir" ]; then
        printf "$MSG_FAILED Not a valid combination of '$DBW_COURSE' and '$lab'.\n"
        exit 2
    fi

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    printf "Creating $DBW_COURSE $lab in '$where'.\n"

    # Check if init was run?
    if [ ! -d "$where" ]; then
        printf "$MSG_FAILED The directory '$where' is missing.\nDid you run the command 'dbwebb init'?\n"
        exit 2
    fi

    # Check if lab is already there
    if [ -f "$where/answer.php" -o -f "$where/answer.js" -o -f "$where/answer.py" ]; then
        printf "$MSG_FAILED You have already created lab-files at: '$where'\nRemove the files in the directory, then you can generate new files.\n"
        exit 2
    fi

    # Check for wget
    local myWget

    if hash wget 2> /dev/null; then
        myWget="wget -qO"
    elif hash curl 2> /dev/null; then
        myWget="curl -so"
    else
        printf "$MSG_FAILED Missing wget and curl, can not create a lab without both.\n"
        exit 2
    fi

    # Create the key
    local getKey="action=only-key&acronym=$DBW_USER&course=$DBW_COURSE&doGenerate=Submit"
    local key="$( ${myWget}- "$DBW_LABURL/?$getKey&lab=$lab" )"

    # The lab description
    local getLab="lab.php?lab"
    printf " instruction.html"
    $myWget "$where/instruction.html" "$DBW_LABURL/$getLab&key=$key"

    # The lab documents
    case "$DBW_COURSE" in
        
        htmlphp)
            printf "\n answer.php"
            $myWget "$where/answer.php" "$DBW_LABURL/lab.php?answer-php&key=$key"

            printf "\n CDbwebb.php"
            $myWget "$where/CDbwebb.php" "$DBW_LABURL/lab.php?answer-php-assert&key=$key"

            printf "\n answer.json"
            $myWget "$where/answer.json" "$DBW_LABURL/lab.php?answer-json&key=$key"
        ;;
        
        javascript1)
            printf "\n answer.html"
            $myWget "$where/answer.html" "$DBW_LABURL/lab.php?answer-html&key=$key"

            printf "\n answer.js"
            $myWget "$where/answer.js" "$DBW_LABURL/lab.php?answer-js&key=$key"
        ;;

        python)
            printf "\n answer.py"
            $myWget "$where/answer.py" "$DBW_LABURL/lab.php?answer-py&key=$key"
            chmod 755 "$where/answer.py"

            printf "\n Dbwebb.py"
            $myWget "$where/Dbwebb.py" "$DBW_LABURL/lab.php?answer-py-assert&key=$key"

            printf "\n answer.json"
            $myWget "$where/answer.json" "$DBW_LABURL/lab.php?answer-json&key=$key"
        ;;

    esac

    # Extras
    local getAnswerExtra="lab.php?answer-extra"
    printf "\n (extras)"
    $myWget "$where/extra.tar" "$DBW_LABURL/$getAnswerExtra&key=$key"
    tar -xvf "$where/extra.tar" -C "$where"
    rm -f "$where/extra.tar"

    printf "\n$MSG_DONE You can find the lab and all files here: '$where'\n"
}



#
# Selfupdate
#
dbwebb-selfupdate()
{
    local intro="Selfupdating dbwebb-cli from https://github.com/mosbth/dbwebb-cli."
    local cmd="wget https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2 -O /tmp/$$; install /tmp/$$ /usr/local/bin/dbwebb; rm /tmp/$$"
    local message="to update dbwebb installation."
    executeCommand "$intro" "$cmd" "$message"
        
    dbwebb updateconfig
    
    printf "Current version is: "
    dbwebb --version
}



#
# Selfupdate
#
dbwebb-clone()
{
    local repo="$1"
    local github=
    
    if [[ $repo ]]; then
        case "$repo" in
            python)      github="https://github.com/mosbth/python.git";;
            javascript1) github="https://github.com/mosbth/javascript1.git";;
            linux)       github="https://github.com/mosbth/linux.git";;
            webapp)      github="https://github.com/mosbth/webapp.git";;
            htmlphp)     github="https://github.com/mosbth/htmlphp.git";;
            *)           printf "$MSG_FAILED Not a valid course rep: '$repo'\n"
        esac
    fi
    
    if [[ ! $github ]]; then
        printf "Available course repos are: python, javascript1, linux, webapp or htmlphp.\n"
        printf "Usage: dbwebb clone python\n"
        exit 1
    fi
    
    local intro="Cloning course-repo for '$repo' from '$github'."
    local cmd="git clone \"$github\""
    local message="to clone course repo '$repo' from '$github'."
    executeCommand "$intro" "$cmd" "$message"
}



#
# Update config during selfupdate
#
dbwebb-updateconfig()
{
    createConfig "selfupdate" "no"
}



# --------------- DBWEBB FUNCTIONS PHASE END ---------------
