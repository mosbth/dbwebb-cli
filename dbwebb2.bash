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

        # Temporary to solve upgrades from v1.9.29 to v1.9.32
        unset DBW_SSH_KEY

    elif [ $first = "selfupdate" ]
    then

        # Temporary to solve upgrades from v1.9.29 to v1.9.32
        unset DBW_SSH_KEY

    elif [ $first = "create" ]
    then

        printf "I will now re-create the configuration file '$DBW_CONFIG_FILE_NAME' in your home directory: '$HOME'."

    fi


    if [[ ! $noInput ]]; then
        DBW_USER=${DBW_USER:-$USER}
        printf "\nWhat is your student acronym? [$DBW_USER] "
        read acronym
        unset DBW_BASEURL
    fi

    acronym=${acronym:-$DBW_USER}
    remoteHost=${DBW_HOST:-ssh.student.bth.se}
    sshKey=${DBW_SSH_KEY:-\$HOME/.ssh/dbwebb}
    remoteDir=${DBW_REMOTE_BASEDIR:-dbwebb-kurser}
    remoteWwwHost=${DBW_WWW_HOST:-http://www.student.bth.se/}
    remoteWww=${DBW_REMOTE_WWWDIR:-www/dbwebb-kurser}
    baseurl=${DBW_BASEURL:-http://www.student.bth.se/~$acronym/$remoteDir}
    laburl=${DBW_LABURL:-http://www.student.bth.se/~mosstud/kod-exempel/lab}

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
    local command="rsync -av $RSYNC_CHMOD --exclude README.md --ignore-existing \"$meDefault\" \"$me\""
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
    local message="to init the base dirs on the server."

    checkIfValidConfigOrExit
    executeCommand "$intro" "$command" "$message"
}



#
# Create default directory structure on the server for dbwebb-kurser/.
#
function dbwebb-init-structure-dbwebb-kurser()
{
    local intro="Ensuring that the directory structure exists on the server by syncing directory structure to dbwebb-kurser/ (will not overwrite existing files)."
    local command=
    local message="to init the directory structure on the server."

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM=""
    SUBDIR=""

    createUploadDownloadPaths

    command="rsync -av $RSYNC_CHMOD --exclude .git --exclude .gitignore --exclude literature --exclude tutorial --exclude .default --exclude example --include='*/' --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$WHAT' '$WHERE'"
    executeCommand "$intro" "$command" "$message"
}



#
# Create default directory structure on the server for dbwebb-kurser/.
#
function dbwebb-init-structure-www-dbwebb-kurser()
{
    local intro="Ensuring that the directory structure exists on the server by syncing the me/ directory structure to www/dbwebb-kurser (will not overwrite existing files)."
    local command=
    local message="to init the www-directory structure on the server."

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_WWW_DESTINATION"
    ITEM=""
    SUBDIR=""

    createUploadDownloadPaths

    command="rsync -av $RSYNC_CHMOD --exclude .git --exclude .gitignore --exclude literature --exclude tutorial --exclude .default --exclude example --include='*/' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$WHAT' '$WHERE'"
    executeCommand "$intro" "$command" "$message"
}



#
# Init course repo and directory structure at the server.
#
function dbwebb-init()
{    
    dbwebb-init-me
    dbwebb-init-server
    dbwebb-init-structure-dbwebb-kurser
    dbwebb-init-structure-www-dbwebb-kurser
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
    ssh-keygen -f "$sshkey" -N ''
    
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
    local command="git pull"
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
    printf "\nbash:               %s" "$( checkCommand bash )"
    printf "\ngit:                %s" "$( checkCommand git )"
    printf "\nssh:                %s" "$( checkCommand ssh )"
    printf "\nrsync:              %s" "$( checkCommand rsync )"
    printf "\nwget:               %s" "$( checkCommand wget )"
    printf "\ncurl:               %s" "$( checkCommand curl )"
    printf "\n"

    printf "\nDetails on the dbwebb-environment."
    printf "\n------------------------------------"
    printf "\nOperatingsystem:    $DBW_OS"
    printf "\nCommand issued:     $DBW_EXECUTABLE"
    printf "\nVersion of dbwebb:  $DBW_VERSION"
    printf "\nPath to executable: '$DBW_EXECUTABLE_DIR'"
    printf "\nConfig-file:        '$DBW_CONFIG_FILE'"
    printf "\nWorking directory:  '$DBW_CURRENT_DIR'"
    printf "\nLocal user:         '$USER'"
    printf "\nLocal homedir:      '$HOME'"
    printf "\nRemote user:        '$DBW_USER'"
    printf "\nRemote host:        '$DBW_HOST'"
    printf "\n"

    echo
    echo "Details on current course-repo."
    echo "------------------------------------"

    if [ "$DBW_COURSE_REPO_VALID" = "yes" ]; then
        echo "Current course-repo:   '$DBW_COURSE'"
        echo "Course directory:      '$DBW_COURSE_DIR'"
        echo "Course-repo version:   $( git describe --always )"
        echo "Latest update to course repo was:"
        echo 
        git log -1
        echo
    else 
        echo "This is not a valid course repo."
        echo
    fi

    if contains python "$@"; then
        echo "Details on Python installed utilities."
        echo "------------------------------------"
        echo "python3:            $( checkCommand python3 )"
        echo "pip3:               $( checkCommand pip3 )"
        echo 
    fi
}



#
# Create or re-create the config file.
#
function dbwebb-config()
{
    createConfig $1 $2
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
    #setChmod

    local intro="Uploading the directory '$WHAT' to '$WHERE'."
    local command="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
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
    local who="$2"

    if [ "$who" != "$DBW_USER" ]; then
        WHERE="${DBW_USER}@${DBW_HOST}:~$who/$DBW_REMOTE_BASEDIR/$DBW_COURSE"
    fi
    
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths

    local command=
    local overwrite=
    
    if [[ $OVERWRITE ]]; then
        command="$RSYNC_CMD $OVERWRITE '$WHERE' '$WHAT'"
        overwrite="WILL BE"
    else
        command="$RSYNC_DOWNLOAD_CMD '$WHERE' '$WHAT'"
        overwrite="WILL NOT BE"
    fi
    
    local intro="Downloading the directory '$WHERE' to '$WHAT'.\nExisting local files that are newer $overwrite overwritten."
    local message="to download data."
    executeCommand "$intro" "$command" "$message" "really?"
}


#
# Validate the uploaded files
#
function dbwebb-validate()
{
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    #setChmod

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""
    createUploadDownloadPaths

    local log="$HOME/.dbwebb-validate.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' for validation."
    local command1="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
    local command2="rsync -av $RSYNC_CHMOD $OVERWRITE --exclude .git --exclude .gitignore --exclude .default --exclude .solution --exclude .old --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/'"
    local command3="$SSH_CMD 'dbwebb-validate --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' 2>&1 | tee '$log';"
    local message="to validate course results.\nSaved a log of the output: less -R '$log'"
    executeCommand "$intro" "$command1; $command2; $command3" "$message"
}



#
# Publish the uploaded files
#
function dbwebb-publish()
{
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    #setChmod

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""
    createUploadDownloadPaths

    local log="$HOME/.dbwebb-publish.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' to validate and publish."
    local command1="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
    local command2="rsync -av $RSYNC_CHMOD $OVERWRITE --exclude .git --exclude .gitignore --exclude .default --exclude .solution --exclude .old --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/'"
    local command3="$SSH_CMD 'dbwebb-validate $PUBLISH_OPTIONS --publish --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" --publish-to \"$DBW_REMOTE_WWWDIR/$DBW_COURSE/$SUBDIR\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' 2>&1 | tee '$log';"
    local message="to validate and publish course results.\nSaved a log of the output: less -R '$log'"
    executeCommand "$intro" "$command1; $command2; $command3" "$message"

    if [ $? -eq 0 ]; then
        printf "Your files are now"
    else
        printf "Some of your files might be"
    fi
    printf " published on:\n $DBW_BASEURL/$DBW_COURSE/$SUBDIR\n"
}



#
# Publish the uploaded files without validation.
#
function dbwebb-fastpublish()
{
    PUBLISH_OPTIONS="--no-validate"
    dbwebb-publish "$1" "$2" "$3"
}

dbwebb-publishfast()
{
    dbwebb-fastpublish "$*"
}



#
# Publish the uploaded files
#
function dbwebb-purepublish()
{
    PUBLISH_OPTIONS="--no-validate --no-minification"
    dbwebb-publish "$1" "$2" "$3"
}

dbwebb-publishpure()
{
    dbwebb-purepublish "$*"
}



#
# Run command on remote server
#
function dbwebb-run()
{
    local cmd="$*"
    local cwd=
    
    # Prepare options
    if [[ ! $VERY_VERBOSE ]]; then
        SILENT="yes"
    fi

    if [[ $OPTION_CWD ]]; then
        cwd="cd $OPTION_CWD; "
    fi

    checkIfValidConfigOrExit
    
    # Create ssh-command for host
    local server=${OPTION_HOSTNAME:-$DBW_HOST}
    local ssh_cmd="ssh ${DBW_USER}@${server} $DBW_SSH_KEY_OPTION"
    
    local intro="I will now login to the server '$server' as '$DBW_USER' and execute the command '$cwd$cmd'."
    local command="$SSH_CMD -t \"$cwd$cmd\""
    local message="to run the command."
    
    executeCommand "$intro" "$command" "$message"
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
    local archive=

    checkIfValidConfigOrExit

    if [[ $3 ]]; then
        course="$1"
        forCourse=" in course '$course'"
        kmom="$2"
        who="$3"
        forWho=" for user '$who'"
        if [ "$who" != "$DBW_USER" ]; then
            archive="--archive $DBW_ARCHIVE"
        fi
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
    local command2="$SSH_CMD \"dbwebb-inspect $archive --publish-url $DBW_BASEURL --publish-to ~$DBW_USER/$DBW_REMOTE_WWWDIR --base-url $DBW_WWW_HOST~$inspecUser/$DBW_REMOTE_BASEDIR ~$inspecUser/$DBW_REMOTE_BASEDIR/$course $kmom\" 2>&1 | tee '$log';"
    local message="to inspect the course results.\nSaved a log of the output, review it as:\nless -R '$log'"

    # Upload only if
    if [[ $willUpload ]]; then
        checkIfValidCourseRepoOrExit
        #setChmod
        command1="$RSYNC_CMD $OVERWRITE '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/';"
    fi

    executeCommand "$intro" "$command1 $command2" "$message"
}



#
# Re-create a lab
#
dbwebb-recreate()
{
    dbwebb-create "$1" "save-answers"
}



#
# Support re-create a lab by saving the lab answer
#
moveLabAnswer()
{
    local where="$1"
    local postfixFrom="$2"
    local postfixTo="$3"

    for extension in php js py bash
    do
        from="$where/answer.$extension$postfixFrom"
        to="$where/answer.$extension$postfixTo"
        if [ -f "$from" ]; then
            echo "(moving answer.$extension$postfixFrom to answer.$extension$postfixTo)"
            mv "$from" "$to"
        fi
    done
}



#
# Create a lab
#
dbwebb-create()
{
    local myWget=
    local lab="$1"
    local save="$2"
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
    if [ -f "$where/answer.php" -o -f "$where/answer.js" -o -f "$where/answer.py" -o -f "$where/answer.bash" ]; then
        if [[ $save ]]; then
            moveLabAnswer "$where" "" "_$$"
        else
            printf "$MSG_FAILED You have already created lab-files at: '$where'\nRemove the files in the directory, then you can generate new files.\n"
            exit 2
        fi
    fi

    # Check for wget or curl
    myWget="wget -qO"
    #myWget="curl -so"

    # Get the lab bundle
    #http://localhost/git/lab/?action=bundle&key=a07e843ca67d647900e8259729119ddf
    #http://localhost/git/lab/?action=bundle&course=linux&lab=lab1&acronym=mos&doGenerate
    local bundleQuery="?action=bundle&acronym=$DBW_USER&course=$DBW_COURSE&lab=$lab&doGenerate=Submit"

    printf "Downloading and extracting lab bundle\n"
    [[ $VERY_VERBOSE ]] && echo " ($DBW_LABURL/$bundleQuery)"
    [[ $VERY_VERBOSE ]] && echo " ($myWget $where/bundle.tar '$DBW_LABURL/$bundleQuery')"
    $myWget "$where/bundle.tar" "$DBW_LABURL/$bundleQuery"
    tar -xmf "$where/bundle.tar" -C "$where"
    rm -f "$where/bundle.tar"
    if [[ $save ]]; then
        moveLabAnswer "$where" "_$$" ""
    fi
    printf "$MSG_DONE You can find the lab and all files here:\n"
    echo "'$where'"
    ls -lF "$where"
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
# Clone a repo
#
dbwebb-clone()
{
    local repo="$1"
    local saveas="$2"
    
    if [[ ! $repo ]]; then
        usageClone
        exit 0
    fi
    
    if ! contains "$repo" "${DBW_COURSE_REPOS[@]}"; then
        badUsageClone "$MSG_FAILED Not a valid course repo: '$repo'"
        exit 1
    fi
    
    local intro="Cloning course-repo for '$repo' from '$( createGithubUrl "$repo" )'."
    local cmd="git clone \"$( createGithubUrl "$repo" ).git\" $saveas"
    local message="to clone course repo."
    executeCommand "$intro" "$cmd" "$message"
}



#
# Link to a repo on GitHub
#
dbwebb-github()
{
    local repo="$1"
    
    if [[ ! $repo ]]; then
        usageGithub
        exit 0
    fi
    
    if ! contains "$repo" "${DBW_COURSE_REPOS[@]}"; then
        badUsageGithub "$MSG_FAILED Not a valid course repo: '$repo'"
        exit 1
    fi
    
    echo "The course repo '$repo' exists on GitHub:"
    echo "Repo:   $( createGithubUrl "$repo" )"
    echo "Issues: $( createGithubUrl "$repo" "/issues" )"
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

        --silent | -s)
            SILENT="yes"
            shift
        ;;

        --force | -f)
            OVERWRITE="--ignore-times"
            shift
        ;;

        --host | --hostname)
            OPTION_HOSTNAME="$2"
            shift
            shift
        ;;

        --cwd)
            OPTION_CWD="$2"
            shift
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
        | github       \
        | config       \
        | updateconfig \
        | selfupdate   \
        | sshkey       \
        | login        \
        | upload       \
        | download     \
        | validate     \
        | publish      \
        | publishfast  \
        | publishpure  \
        | fastpublish  \
        | purepublish  \
        | inspect      \
        | run          \
        | create       \
        | recreate     \
        | init         \
        | init-server  \
        | init-structure-dbwebb-kurser \
        | init-structure-www-dbwebb-kurser \
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
