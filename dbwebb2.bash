#------------------------- HERE ARE THE MAIN COMMANDS -----------------------


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
    remoteWwwHost=${remoteWwwHost:-http://www.student.bth.se/}
    remoteWww=${remoteWww:-www/dbwebb-kurser}
    baseurl=${baseurl:-http://www.student.bth.se/~$acronym/$remoteDir}
    laburl=${laburl:-http://www.student.bth.se/~mosstud/kod-exempel/lab}

    echo "DBW_USER='$acronym'"               > "$DBW_CONFIG_FILE"
    echo "DBW_HOST='$remoteHost'"           >> "$DBW_CONFIG_FILE"
    echo "DBW_WWW_HOST='$remoteWwwHost'"    >> "$DBW_CONFIG_FILE"
    echo "DBW_SSH_KEY=\"$sshKey\""          >> "$DBW_CONFIG_FILE"
    echo "DBW_REMOTE_BASEDIR='$remoteDir'"  >> "$DBW_CONFIG_FILE"
    echo "DBW_REMOTE_WWWDIR='$remoteWww'"   >> "$DBW_CONFIG_FILE"
    echo "DBW_BASEURL='$baseurl'"           >> "$DBW_CONFIG_FILE"
    echo "DBW_LABURL='$laburl'"             >> "$DBW_CONFIG_FILE"

    printf "$MSG_DONE The config file '$DBW_CONFIG_FILE' is now up-to-date.\n"
}



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
# Inspect uploaded files
#
function dbwebb-inspect()
{
    local course=
    local kmom=
    local who=
    local forWho=" for user '$DBW_USER'"
    local forCourse=
    local willUpload=

    checkIfValidConfigOrExit

    if [[ $3 ]]; then
        course="$1"
        forCourse=" in course '$course'"
        kmom="$2"
        who="$3"
        forWho=" for user '$who'"
    elif [[ $2 ]]; then
        course="$1"
        forCourse=" in course '$course'"
        kmom="$2"
    elif [[ $1 ]]; then
        course="$DBW_COURSE"
        kmom="$1"
        forCourse=" in course repo '$course'"
        willUpload="\nI will start by uploading the course repo to the remote server."
    else
        usageInspect
        exit 0
    fi    

    inspecUser=${who:=$DBW_USER}

    local intro="I will now inspect '$kmom'${forCourse}${forWho}.$willUpload"
    local log="$HOME/.dbwebb-inspect.log"
    local command1=
    local command2="$SSH_CMD \"dbwebb-inspect --archive /home/saxon/students/dbwebb/archive/ --publish-url $DBW_BASEURL --publish-to ~$DBW_USER/$DBW_REMOTE_WWWDIR --base-url $DBW_WWW_HOST~$inspecUser/$DBW_REMOTE_BASEDIR ~$inspecUser/$DBW_REMOTE_BASEDIR/$course $kmom\" | tee '$log';"
    local message="to inspect the course results.\nSaved a log of the output, review it as:\nless -R '$log'"

    # Upload only if
    if [[ $willUpload ]]; then
        checkIfValidCourseRepoOrExit
        setChmod
        command1="$RSYNC_CMD '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/';"
    fi

    executeCommand "$intro" "$command1 $command2" "$message"
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
    selfupdate dbwebb
    dbwebb updateconfig
}



#
# Selfupdate
#
dbwebb-clone()
{
    local repo="$1"
    local github=
    
    if [[ ! $repo ]]; then
        usageClone
        exit 0
    fi
    
    case "$repo" in
        python)      github="https://github.com/mosbth/python.git";;
        javascript1) github="https://github.com/mosbth/javascript1.git";;
        linux)       github="https://github.com/mosbth/linux.git";;
        webapp)      github="https://github.com/mosbth/webapp.git";;
        htmlphp)     github="https://github.com/mosbth/htmlphp.git";;
    esac
    
    if [[ ! $github ]]; then
        badUsageClone "$MSG_FAILED Not a valid course repo: '$repo'"
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



# --------------- DBWEBB MAIN START HERE ------------------------------
#
# Process options
#
while (( $# ))
do
    case "$1" in
        
        --inspect | -i)
            inspectUsage
            exit 0
        ;;

        --verbose | -v)
            VERY_VERBOSE="yes"
            shift
        ;;

        --yes | -y)
            SKIP_READLINE="yes"
            shift
        ;;

        --help | -h)
            usage
            exit 0
        ;;
        
        --version)
            version
            exit 0
        ;;
                
        #--course)
        #    DBW_COURSE=$2
        #    shift
        #    shift
        #;;
                
        update         \
        | check        \
        | clone        \
        | config       \
        | updateconfig \
        | selfupdate   \
        | sshkey       \
        | login        \
        | upload       \
        | download     \
        | validate     \
        | publish      \
        | inspect      \
        | create       \
        | init         \
        | init-server  \
        | init-me)
            command=$1
            shift
            dbwebb-$command $*
            exit 0
        ;;
        
        *)
            badUsage "$MSG_FAILED Option/command not recognized."
            exit 2
        ;;
        
    esac
done

badUsage
exit 1
