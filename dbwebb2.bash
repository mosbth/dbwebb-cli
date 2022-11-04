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

    # Check if run as sudo, use SUDO_USER as HOME
    # (useful for selfupdate through sudo)
    local home="$HOME"
    if [[ $SUDO_USER ]]; then
        home=$( eval echo "~$SUDO_USER" )
    fi

    if [ -z $first ]
    then

        printf "The config-file '$DBW_CONFIG_FILE_NAME' will now be created in your home directory: '$home'"

    elif [ $first = "update" ]
    then

        printf "Your config file will be automatically updated. Then re-run your command.\n"

    elif [ $first = "upgrade" ]
    then

        printf "Your config file will be automatically updated."

        # # Temporary to solve upgrades from v1.9.29 to v1.9.32
        # unset DBW_SSH_KEY
        # To change lab url when upgrading to v2.2.1
        unset DBW_LABURL

    elif [ $first = "selfupdate" ]
    then

        # # Temporary to solve upgrades from v1.9.29 to v1.9.32
        # unset DBW_SSH_KEY
        # To change lab url when upgrading to v2.2.1
        unset DBW_LABURL
        # To fix upgrade with wrong DBW_SSH_KEY, fix in v2.3.0
        unset DBW_SSH_KEY

    elif [ $first = "create" ]
    then

        printf "I will now re-create the configuration file '$DBW_CONFIG_FILE_NAME' in your home directory: '$home'.\n"

    fi


    if [[ ! $noInput ]]; then
        DBW_USER=${DBW_USER:-$USER}
        printf "\nWhat is your student acronym? [$DBW_USER] "
        read acronym
        unset DBW_BASEURL
    else
        DBW_USER=${DBW_USER:-noname}
    fi

    acronym=${acronym:-$DBW_USER}
    sshKey=${DBW_SSH_KEY:-$home/.ssh/dbwebb}
    remoteHost=${DBW_HOST:-ssh.student.bth.se}
    remoteDir=${DBW_REMOTE_BASEDIR:-dbwebb-kurser}
    remoteWwwHost=${DBW_WWW_HOST:-http://www.student.bth.se/}
    remoteWww=${DBW_REMOTE_WWWDIR:-www/dbwebb-kurser}
    baseurl=${DBW_BASEURL:-http://www.student.bth.se/~$acronym/$remoteDir}
    laburl=${DBW_LABURL:-https://lab.dbwebb.se}

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
    checkIfValidCourseRepoOrExit

    local mapFile="$DBW_COURSE_DIR/.dbwebb.map"
    if [ -f "$mapFile" ]; then
        local intro="Creating and initiating the directory structure in 'me/' (will not overwrite existing files)."
        local command="createDirsInMeFromMapFile"
        local message="to init the directory 'me/'."
        executeCommandInSubShell "$intro" "$command" "$message"
        return
    fi

    local meDefault="$DBW_COURSE_DIR/.default/"
    local me="$DBW_COURSE_DIR/me/"

    local intro="Creating and initiating the directory 'me/' by copying directory structure and files from the directory '.default/' (will not overwrite existing files)."
    local command="rsync -av $RSYNC_CHMOD --exclude README.md --ignore-existing \"$meDefault\" \"$me\""
    local message="to init the directory 'me/'."

    executeCommand "$intro" "$command" "$message"
}



#
# Troubleshoot an installation and check part by part.
#
function dbwebb-trouble()
{
    printf "### Lets check the installed commands:\nbash git ssh rsync wget curl.\n"
    pressEnterToContinue

    cmd="bash"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd --version | head -1 )"

    cmd="git"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd --version | head -1 )"

    cmd="ssh"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd -V | head -1 )"

    cmd="rsync"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd --version | head -1 )"

    cmd="wget"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd --version | head -1 )"

    cmd="curl"
    printf "# %s " "$cmd"
    printf "%s " "$( which $cmd )"
    printf "%s \n" "$( $cmd --version | head -1 )"

    printf "\n### Lets check who you are.\n"
    pressEnterToContinue

    printf "whoami: '%s'\n" "$( whoami )"
    printf "\$HOME: '%s'\n" "$HOME"
    printf "\$HOMEPATH (win): '%s'\n" "$HOMEPATH"
    printf "\$USERPROFILE (win): '%s'\n" "$USERPROFILE"

    printf "\n### Lets check the dbwebb.config file.\n"
    pressEnterToContinue

    checkIfValidConfigOrExit
    printf "\$DBW_CONFIG_FILE: '%s'\n" "$DBW_CONFIG_FILE"
    printf "ls -l \$DBW_CONFIG_FILE: '%s'\n" "$( ls -l $DBW_CONFIG_FILE )"
    printf "file \$DBW_CONFIG_FILE: '%s'\n" "$( file $DBW_CONFIG_FILE )"
    printf "cat \$DBW_CONFIG_FILE: \n%s\n" "$( cat $DBW_CONFIG_FILE )"

    printf "\n### Check if we can ping bth.se.\n"
    pressEnterToContinue

    printf "ping -c 1 bth.se: \n'%s'\n" "$( ping -c 1 bth.se )"

    printf "\n### Try login to the student server and execute a command.\n"
    pressEnterToContinue

    printf "ssh ${DBW_USER}@${DBW_HOST} 'pwd && ls -ld dbwebb-kurser && ls -l dbwebb-kurser':\n"
    ssh ${DBW_USER}@${DBW_HOST} 'pwd && ls -ld dbwebb-kurser && ls -l dbwebb-kurser'

    printf "\n### Try login to the student server using ssh-keys.\n"
    pressEnterToContinue

    printf "\$DBW_SSH_KEY: '%s'\n" "$DBW_SSH_KEY"
    printf "\$DBW_SSH_KEY_OPTION: '%s'\n" "$DBW_SSH_KEY_OPTION"
    printf "ls -ld $HOME/.ssh: '%s'\n" "$( ls -ld $HOME/.ssh )"
    printf "ls -l $HOME/.ssh:'%s'\n" "$( ls -l $HOME/.ssh)"
    printf "\$SSH_CMD: '%s'\n" "$SSH_CMD"
    eval $SSH_CMD pwd

    printf "\n### Lets do some checks with your course repo. You must 'cd' into a valid course repo, for example python or htmlphp.\n"
    pressEnterToContinue

    checkIfValidCourseRepoOrExit
    printf "\$DBW_COURSE_DIR: '%s'\n" "$DBW_COURSE_DIR"
    printf "ls -ld $DBW_COURSE_DIR/..: \n%s\n" "$( ls -ld $DBW_COURSE_DIR/.. )"
    printf "ls -l $DBW_COURSE_DIR/..: \n%s\n" "$( ls -l $DBW_COURSE_DIR/..)"

    printf "\n### Lets init the course repo, step by step.\n"
    pressEnterToContinue
    VERY_VERBOSE="yes"

    printf "dbwebb-init-me:\n"
    pressEnterToContinue
    dbwebb-init-me

    printf "dbwebb-init-server:\n"
    pressEnterToContinue
    dbwebb-init-server

    printf "dbwebb-init-structure-dbwebb-kurser:\n"
    pressEnterToContinue
    dbwebb-init-structure-dbwebb-kurser

    printf "dbwebb-init-structure-www-dbwebb-kurser:\n"
    pressEnterToContinue
    dbwebb-init-structure-www-dbwebb-kurser
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

    command="rsync -av $RSYNC_CHMOD --exclude example $RSYNC_INCLUDE $RSYNC_EXCLUDE --include='*/' --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$WHAT' '$WHERE'"
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

    command="rsync -av $RSYNC_CHMOD --exclude example $RSYNC_INCLUDE $RSYNC_EXCLUDE --include='*/' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$WHAT' '$WHERE'"
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
    local key hostname

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

    # Add the public keys of SSH servers to known_hosts if needed.
    for key in "${DBW_HOST_KEYS[@]}"; do
        hostname="$(echo "$key"|awk '{print $1}')"
        if ! ssh-keygen -F "$hostname" >/dev/null 2>&1; then
            echo "Adding known public key for $hostname."
            echo "$key" >>"$HOME/.ssh/known_hosts"
        fi
    done

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
    local command="git pull --rebase"
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
        echo "Remote origin:         $( cd $DBW_COURSE_DIR && git config --get remote.origin.url )"
        echo "Course-repo version:   $( cd $DBW_COURSE_DIR && git describe --always )"
        echo "Latest update to course repo was:"
        echo
        (cd "$DBW_COURSE_DIR" && git log -1)
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
    createUploadDownloadPaths ignoreSubdir
    #setChmod

    local intro="Uploading the directory '$WHAT' to '$WHERE'."
    local command="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
    local message="to upload data."
    executeCommand "$intro" "$command" "$message"
}



#
# Ping the server with a message
#
function dbwebb-ping()
{
    local what="$1"
    local action="$2"
    local extra="$3"
    local url="http://www.student.bth.se/~mosstud/dbwebb-ping/"
    local subdir=
    local where=
    local res=
    local qs=
    local timer=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    subdir="$( mapCmdToDir $what )"
    where="$DBW_COURSE_DIR/$subdir"

    checkIfValidCombination "$subdir" "$what"
    checkIfSubdirExistsOrProposeInit "$where"

    timer=$( timeScript )
    qs="course=$DBW_COURSE&acronym=$DBW_USER&what=$what&subdir=$subdir&action=$action&extra=$extra&timer=$timer"
    qs=${qs// /+}
    url="${OPTION_BASE_URL:-$url}?$qs"

    veryVerbose "dbwebb-ping to: $url"
    res=$( getUrlToStdout "$url" )
    veryVerbose "dbwebb-ping response: $res"
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
    local really="really?"

    if [ "$who" != "$DBW_USER" ]; then
        WHERE="${DBW_USER}@${DBW_HOST}:~$who/$DBW_REMOTE_BASEDIR/$DBW_COURSE"
    fi

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    createUploadDownloadPaths

    local command=
    local overwrite=

    if [[ $OVERWRITE ]]; then
        command="$RSYNC_DOWNLOAD_DELETE_CMD $OVERWRITE '$WHERE' '$WHAT'"
        overwrite="WILL BE"
    else
        command="$RSYNC_DOWNLOAD_CMD '$WHERE' '$WHAT'"
        overwrite="WILL NOT BE"
    fi

    [[ $YES ]] && really=

    local intro="Downloading the directory '$WHERE' to '$WHAT'. Existing local files that are newer $overwrite overwritten."
    local message="to download data."
    executeCommand "$intro" "$command" "$message" "$really"
}


#
# Validate the uploaded files
#
function dbwebb-validate()
{
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    #setChmod

    local dry=

    [[ $OPTION_DRY ]] && dry="--dry"

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""
    createUploadDownloadPaths ignoreSubdir

    local log="$HOME/.dbwebb-validate.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' for validation."
    local command1="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
#    local command2="rsync -av $RSYNC_CHMOD $OVERWRITE --exclude .git --exclude .gitignore --exclude .default --exclude .solution --exclude .old --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/'"
    local command3="$SSH_CMD 'dbwebb-validate1 $dry --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' 2>&1 | tee '$log'; test \${PIPESTATUS[0]} -eq 0"
    local message="to validate course results.\nSaved a log of the output: less -R '$log'"
    #executeCommand "$intro" "$command1; $command2; $command3" "$message"
    executeCommand "$intro" "$command1; $command3" "$message"
}



#
# Publish the uploaded files
#
function dbwebb-publish()
{
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit
    #setChmod

    [[ $OPTION_DRY ]] && dry="--dry"

    WHAT="$DBW_COURSE_DIR"
    WHERE="$DBW_REMOTE_DESTINATION"
    ITEM="$1"
    SUBDIR=""
    createUploadDownloadPaths ignoreSubdir

    local log="$HOME/.dbwebb-publish.log"
    local intro="Uploading the directory '$WHAT' to '$WHERE' to validate and publish."
    local command1="$RSYNC_CMD $OVERWRITE '$WHAT' '$WHERE'"
#    local command2="rsync -av $RSYNC_CHMOD $OVERWRITE --exclude .git --exclude .gitignore --exclude .default --exclude .solution --exclude .old --include='.??*' --exclude='*' -e \"ssh $DBW_SSH_KEY_OPTION\" '$DBW_COURSE_DIR/' '$DBW_REMOTE_DESTINATION/'"
    local command3="$SSH_CMD 'dbwebb-validate1 $dry $PUBLISH_OPTIONS --publish --course-repo \"$DBW_REMOTE_BASEDIR/$DBW_COURSE\" --publish-to \"$DBW_REMOTE_WWWDIR/$DBW_COURSE/$SUBDIR\" --publish-root \"$DBW_REMOTE_WWWDIR/$DBW_COURSE\" \"$DBW_REMOTE_BASEDIR/$DBW_COURSE/$SUBDIR\"' 2>&1 | tee '$log'; test \${PIPESTATUS[0]} -eq 0"
    local message="to validate and publish course results.\nSaved a log of the output: less -R '$log'"
    #executeCommand "$intro" "$command1; $command2; $command3" "$message"
    executeCommand "$intro" "$command1; $command3" "$message"

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
    local yes=
    local useVersion=
    local noValidate=

    checkIfValidConfigOrExit

    if [[ $3 ]]; then
        course="$1"
        forCourse=" in course '$course'"
        kmom="$2"
        who="$3"
        forWho=" for user '$who'"
        if [ "$who" != "$DBW_USER" -a -z "$OPTION_NOARCHIVE" ]; then
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
        willUpload=" I will start by uploading the course repo to the remote server."
    else
        usageInspect
        exit 0
    fi

    inspecUser=${who:=$DBW_USER}
    [[ $YES ]] && yes="--yes"
    [[ $PORT ]] && port="--port $PORT"
    [[ $USE_VERSION ]] && useVersion="--useVersion $USE_VERSION"
    [[ $NO_VALIDATE ]] && noValidate="--no-validate"

    local intro="I will now inspect '$kmom'${forCourse}${forWho}.$willUpload"
    local log="$HOME/.dbwebb-inspect.log"
    local command1=
    local command2="$SSH_CMD_INTERACTIVE \"dbwebb-inspect1 $yes $noValidate $port $useVersion $archive --publish-url $DBW_BASEURL --publish-to ~$DBW_USER/$DBW_REMOTE_WWWDIR --base-url $DBW_WWW_HOST~$inspecUser/$DBW_REMOTE_BASEDIR ~$inspecUser/$DBW_REMOTE_BASEDIR/$course $kmom\" 2>&1 | tee '$log'; test \${PIPESTATUS[0]} -eq 0"
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
    dbwebb-create "$1" "$2" "save-answers"
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
    local version="$2"
    local save="$3"
    local subdir="$( mapCmdToDir $lab )"
    local where="$DBW_COURSE_DIR/$subdir"

    if [ -z "$subdir" ]; then
        printf "$MSG_FAILED Not a valid combination of '$DBW_COURSE' and '$lab'.\n"
        exit 2
    fi

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    # If no lab version supplied, read it from course repo if available
    if [ -z "$version" -a -f "$DBW_COURSE_DIR/.dbwebb/lab.version" ]; then
        version=$( cat "$DBW_COURSE_DIR/.dbwebb/lab.version" )
    fi

    local lab_version=
    [[ $version ]] && lab_version=" ($version)"

    printf "Creating $DBW_COURSE $lab${lab_version} in '$where'.\n"

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
    local bundleQuery="?action=bundle&acronym=$DBW_USER&course=$DBW_COURSE&lab=$lab&version=$version&doGenerate=Submit"

    printf "Downloading and extracting lab bundle\n"
    [[ $VERY_VERBOSE ]] && echo " ($DBW_LABURL/$bundleQuery)"
    [[ $VERY_VERBOSE ]] && echo " ($myWget $where/bundle.tar '$DBW_LABURL/$bundleQuery')"

    $myWget "$where/bundle.tar" "$DBW_LABURL/$bundleQuery"
    [[ $? > 0 ]] && printf "$MSG_FAILED Failed to download lab bundle.\n" && exit 1

    tar -xmf "$where/bundle.tar" -C "$where"
    [[ $? > 0 ]] && printf "$MSG_FAILED The downloaded lab bundle is not a tar archive. You may cat it to check for errors.\n" && exit 1

    rm -f "$where/bundle.tar"
    if [[ $save ]]; then
        moveLabAnswer "$where" "_$$" ""
    fi
    printf "$MSG_DONE You can find the lab and all files here:\n"
    echo "'$where'"
    ls -lF "$where"
}



#
# Deal with gui inspect
#
dbwebb-gui()
{
    local action="${1:-run}"

    case "$action" in
        help)
            usageGui
            exit 0
        ;;

        config)
            dbwebb-gui-config
            exit 0
        ;;

        install \
        | selfupdate)
            dbwebb-gui-install
            exit 0
        ;;

        run)
            dbwebb-gui-run
            exit 0
        ;;

        version)
            dbwebb-gui-version
            exit 0
        ;;

        *)
            badUsageGui "$MSG_FAILED gui subcommand not recognized."
            exit 2
         ;;
     esac
}



#
# Maintain the user config file for dbwebb gui
#
dbwebb-gui-config()
{
    local script=

    script="$( which dbwebb-inspect-gui )"

    if [[ -x "$script" ]]; then
        verbose "Execute command for gui bash '$script'..."
        bash "$script" config
    else
        die "dbwebb gui is not installed, check 'dbwebb gui help'."
    fi
}



#
# Run gui inspect
#
dbwebb-gui-run()
{
    local script=

    script="$( which dbwebb-inspect-gui )"

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    if [[ -x "$script" ]]; then
        verbose "Execute command for gui bash '$script'..."
        bash "$script"
    else
        die "dbwebb gui is not installed, check 'dbwebb gui help'."
    fi
}



#
# Install/update gui inspect
#
dbwebb-gui-install()
{
    local url="https://raw.githubusercontent.com/dbwebb-se/inspect-gui/master/gui.bash"
    local target="/usr/local/bin"
    local what="dbwebb-inspect-gui"

    printf "Installing (selfupdating) '%s' to '%s' from\n %s\n" "$what" "$target" "$url"

    getUrlToFile "$url" "$target/$what" "overwrite-if-exists" \
        || die "Failed to download/install '$what' to '$target' (perhaps sudo?)."
    chmod 755 "$target/$what"

    printf "The updated version is now: "
    dbwebb-gui-version
}



#
# Check the version of gui inspect
#
dbwebb-gui-version()
{
    local script=

    script="$( which dbwebb-inspect-gui )"

    if [[ -x "$script" ]]; then
        verbose "Execute command for gui bash '$script'..."
        bash "$script" version
    else
        die "dbwebb gui is not installed, check 'dbwebb gui help'."
    fi
}



#
# Deal with exams
#
dbwebb-exam()
{
    local action="$1"
    local what="$2"
    local version="$3"

    case "$action" in
        help)
            usageExam
            exit 0
        ;;

        list \
        | ls)
            dbwebb-exam-list
            exit 0
        ;;

        receipt \
        | r)
            dbwebb-exam-receipt "$what"
            exit 0
        ;;

        start  \
        | checkout \
        | c)
            dbwebb-exam-start "$what" "$version"
            exit 0
        ;;

        stop  \
        | seal \
        | s)
            dbwebb-exam-stop "$what"
            exit 0
        ;;

        correct)
            dbwebb-exam-correct "$what"
            exit 0
        ;;

        *)
            badUsageExam "$MSG_FAILED exam subcommand not recognized."
            exit 2
         ;;
     esac
}



#
# Show list of active, planned and passed exams.
#
dbwebb-exam-list()
{
    local url=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    url="${OPTION_BASE_URL:-$DBW_LABURL}"
    url="${url%/}"
    url="$url/?action=exam-list&course=$DBW_COURSE"

    verbose "Prepare to list exams..."
    getUrlToStdout "$url" \
        || die "Failed to download information on exams."
}



#
# Generate file containing all files.
#
dbwebb-exam-helper-generate-file-list()
{
    local ts
    local target="$1/.dbwebb/exam/file/"

    ts=$(date +"%Y%m%d%H%M%S")
    install -d "$target"

    cd "$1" && echo $ts > "$target/$ts.txt" && find . -type d -not -path "./vendor" -not -path "./node_modules" -not -path "./build" -exec echo {} \; -exec ls -Al {} \; >> "$target/$ts.txt"
}



#
# Get the exam id.
#
dbwebb-exam-helper-get-exam-id()
{
    local receipt="$1/.dbwebb/exam/id.md"

    [[ -f $receipt ]] \
        || die "There is no id file in '$1'."
    awk '/ID:/{print $NF}' "$receipt"
}



#
# Checkout and start an exam.
#
dbwebb-exam-start()
{
    local what="$1"
    local version="${2:-$( readLabVersionFromConfig )}"
    local url="${OPTION_BASE_URL:-$DBW_LABURL}"
    local subdir=
    local where=
    local tarfile="dbwebb_exam_bundle.tar"
    local active=
    local signature=
    local examId=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    subdir="$( mapCmdToDir $what )"
    where="$DBW_COURSE_DIR/$subdir"

    checkIfValidCombination "$subdir" "$what"
    checkIfSubdirExistsOrProposeInit "$where"

    url="${url%/}"
    url="$url/?action=exam-checkout&course=$DBW_COURSE&version=$version&acronym=$DBW_USER&target=$what"

    verbose "Prepare to checkout and start the exam $DBW_COURSE:$what into '${where#$DBW_COURSE_DIR/}'..."
    veryVerbose "Using version $version."

    # Check if exam is already there
    if [ -f "$where/exam.py" ]; then
        printf "$MSG_WARNING An 'exam.py' already exists, I will keep that file and not update it.\n"
        mv "$where/exam.py" "$where/exam.py_$$" || exit 2
    fi

    active=$( getUrlToStdout "$url&checkIfActive" )
    veryVerbose "$active"
    [[ $active == ACTIVE:* ]] \
        || die "Failed to verify that an active exam exists."

    verbose "There is an active exam:\n $active"
    printf "Before we can proceed, supply some personal details.\n"
    signature=$( input " Your real name" "your name" )
    email=$( input " Your email" "your@email.se" )
    printf "Thank you, '$signature ($email)'.\n"

    getUrlToFile "$url&signature=$signature+($email)" "$where/$tarfile" \
        || die "Failed to checkout the exam tar bundle."

    tar -xmf "$where/$tarfile" -C "$where" \
        || die "The downloaded file seems not to be a tar archive. You may cat it to check for errors."

    rm -f "$where/$tarfile"
    [[ -f "$where/exam.py_$$" ]] && mv "$where/exam.py_$$" "$where/exam.py"

    dbwebb-exam-helper-generate-file-list "$where"
    examId=$( dbwebb-exam-helper-get-exam-id "$where" )
    dbwebb-ping "$what" "exam-start" "$examId"

    verboseDone "You can find the files here:"
    verbose "'$where'"
    [[ $SILENT ]] || ls -lF "$where"
}



#
# Seal and stop an exam.
#
dbwebb-exam-stop()
{
    local what="$1"
    local url="${OPTION_BASE_URL:-$DBW_LABURL}"
    local subdir=
    local where=
    local tarfile="dbwebb_exam_bundle.tar"
    local examId=
    local signature=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    subdir="$( mapCmdToDir $what )"
    where="$DBW_COURSE_DIR/$subdir"

    checkIfValidCombination "$subdir" "$what"
    checkIfSubdirExistsOrProposeInit "$where"

    examId=$( dbwebb-exam-helper-get-exam-id "$where" )

    url="${url%/}"
    url="$url/?action=exam-seal&acronym=$DBW_USER&examId=$examId"

    verbose "Prepare to seal the exam $DBW_COURSE:$what into '${where#$DBW_COURSE_DIR/}'..."

    printf "Before we can proceed, supply some personal details.\n"
    signature=$( input " Your real name" "your name" )
    email=$( input " Your email" "your@email.se" )
    printf "Thank you, '$signature ($email)'.\n"

    getUrlToFile "$url&signature=$signature+($email)" "$where/$tarfile" \
        || die "Failed to seal and checkout the exam tar bundle."

    tar -xmf "$where/$tarfile" -C "$where" \
        || die "The downloaded file seems not to be a tar archive. You may cat it to check for errors."

    rm -f "$where/$tarfile"
    dbwebb-exam-helper-generate-file-list "$where"
    verboseDone "The exam is sealed."

    dbwebb-upload "$what"
    dbwebb-ping "$what" "exam-stop" "$examId"

    verboseDone "The exam is sealed, uploaded and the teacher is notificated."
}



#
# Get the reciept for an exam.
#
dbwebb-exam-receipt()
{
    local what="$1"
    local url="${OPTION_BASE_URL:-$DBW_LABURL}"
    local subdir=
    local where=
    local examId=
    local target=".dbwebb/exam/receipt/"
    local ts

    ts=$(date +"%Y%m%d%H%M%S")

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    subdir="$( mapCmdToDir $what )"
    where="$DBW_COURSE_DIR/$subdir"

    checkIfValidCombination "$subdir" "$what"
    checkIfSubdirExistsOrProposeInit "$where"

    examId=$( dbwebb-exam-helper-get-exam-id "$where" )

    url="${url%/}"
    url="$url/?action=exam-receipt&acronym=$DBW_USER&examId=$examId"

    verbose "Getting the receipt from the exam $DBW_COURSE:$what..."

    #getUrlToStdout "$url" \
    getUrlToFile "$url" "$where/$target/$ts.md" \
        || die "Failed to get receipt."

    cat "$where/$target/$ts.md"
    verboseDone "Review your receipt."

    dbwebb-exam-helper-generate-file-list "$where"
}



#
# Get the reciept for an exam.
#
dbwebb-exam-correct()
{
    local what="$1"
    local subdir=
    local where=
    local correct=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    subdir="$( mapCmdToDir $what )"
    where="$DBW_COURSE_DIR/$subdir"

    checkIfValidCombination "$subdir" "$what"
    checkIfSubdirExistsOrProposeInit "$where"

    verbose "Correcting the exam $DBW_COURSE:$what..."

    correct="$where/.dbwebb/correct.bash"
    if [ -f "$correct" ]; then
        if "$correct"; then
            verboseDone "The exam is corrected and graded as passed :-)"
        else
            verboseWarning "The exam is corrected, but was graded as NOT passed :-|"
            exit 1
        fi
    else
        verboseFail "There is no auto correcting facility for '$what'."
        exit 1
    fi

    dbwebb-exam-helper-generate-file-list "$where"
}



#
# Run the dbwebb test command.
#
dbwebb-test()
{
    local what="$1"
    local subdir=
    local where=
    local correct=

    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    run="$DBW_COURSE_DIR/.dbwebb/test/run.bash"
    [[ $VERY_VERBOSE ]] \
        && verbose "Executing test command '$run' for '$DBW_COURSE'.\n Using arguments: '$@'"

    if [ -f "$run" ]; then
        bash "$run" "$DBW_COURSE_DIR" "$DBW_COURSE" "$DBW_USER" "$@"
    else
        verboseFail "There is no file '$run'."
        exit 1
    fi
}



#
# Selfupdate
#
dbwebb-selfupdate()
{
    local version="$1"
    selfupdate dbwebb "$version"
    dbwebb updateconfig
}



#
# Clone a repo
#
dbwebb-clone()
{
    local repo="$1"
    local saveas="${2:-$repo}"

    if [[ ! $repo ]]; then
        usageClone
        exit 0
    fi

    if ! contains "$repo" "${DBW_COURSE_REPOS[@]}"; then
        badUsageClone "$MSG_FAILED Not a valid course repo: '$repo'"
        exit 1
    fi

    local intro="Cloning course-repo for '$repo' from '$( createGithubUrl "$repo" )' as '$saveas'."
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



#
# Display the current version od this script
#
dbwebb-version()
{
    version
    exit 0
}



#
# Show the usage text and exit
#
dbwebb-help()
{
    usage
    exit 0
}



#
# Support testing procedure of course repo
#
dbwebb-testrepo()
{
    checkIfValidConfigOrExit
    checkIfValidCourseRepoOrExit

    local base="$DBW_COURSE_DIR"
    local me="$base/me"
    local testsuite="$base/.dbwebb.tests"
    local prompt="==="
    local silent=

    if [ ! -f "$testsuite" ]; then
        printf "$MSG_FAILED There is no testsuite file '.dbwebb.tests' in this course repo. This courese repo does not (yet) support automated tests.\n"
        exit 2
    fi

    if [ -d "$me" -a -z "$OVERWRITE" ]; then
        printf "$MSG_FAILED The me-directory is already here. You can not run tests with an existing me-directory. Remove the me-directory so it can be recreated by the test procedure.\n"
        exit 2
    fi

    if [[ $SILENT ]]; then
        silent=" &> /dev/null"
    fi

    echo "$prompt Beginning testsuite"
    if [[ $OPTION_LOCAL ]]; then
        echo "$prompt Test locally, using dbwebb-validate"
    fi
    cd "$base"

    local lineNum=0
    local assertions=0
    local fail=0

    while IFS= read -r line <&3
    do
        ((lineNum++))
        printf "%s %s: %s\n" "$prompt" "$lineNum" "$line"

        if [ -z "$line" -o "${line:0:1}" == "#" ]; then
            continue;
        fi

        if [[ $OPTION_LOCAL ]]; then
            line=$( echo "$line" | sed 's/dbwebb validate /make dbwebb-validate what=/')
        fi

        if [[ $SILENT ]]; then
            line=$( echo "$line" | sed 's/;/ \&> \/dev\/null;/' )
        fi

        if [[ $VERY_VERBOSE ]]; then
            printf "$prompt $lineNum: $line $silent\n"
        fi

        ((assertions++))
        ( bash -c "$line $silent 3<&-" )
        if [ $? != 0 ]; then
            printf "$prompt $lineNum: $MSG_FAILED\n"
            ((fail++))
        fi

    done 3< <(grep "" "$testsuite")

    echo "$prompt Done with $assertions assertions and $fail failure(s)."
    if [[ $fail = 0 ]]; then
        printf "$prompt $MSG_OK All tests passed.\n"
    else
        printf "$prompt $MSG_FAILED $fail assertion(s) failed.\n"
        exit 1
    fi
}



# --------------- DBWEBB MAIN START HERE ------------------------------
#
# Process options
#
while (( $# ))
do
    case "$1" in

        --baseurl)
            OPTION_BASE_URL="$2"
            shift
            shift
        ;;

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

        --yes | -y)
            YES="yes"
            shift
        ;;

        --port | -p)
            PORT="$2"
            shift
            shift
        ;;

        --useVersion | -u)
            USE_VERSION="$2"
            shift
            shift
        ;;

        --no-archive)
            OPTION_NOARCHIVE="yes"
            shift
        ;;

        --no-validate)
            NO_VALIDATE="yes"
            shift
        ;;

        --local | -l)
            OPTION_LOCAL="yes"
            shift
        ;;

        --dry)
            OPTION_DRY="yes"
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

        --with-curl)
            if ! hash curl 2>/dev/null; then
                badUsage "$MSG_FAILED Trying to use 'curl' which is not installed."
                exit 2
            fi
            OPTION_WITH_WGET_ALT="curl"
            shift
        ;;

        --with-lynx)
            if ! hash lynx 2>/dev/null; then
                badUsage "$MSG_FAILED Trying to use 'lynx' which is not installed."
                exit 2
            fi
            OPTION_WITH_WGET_ALT="lynx"
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
        | exam         \
        | github       \
        | gui          \
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
        | test         \
        | testrepo     \
        | version      \
        | help         \
        | trouble      \
        | init         \
        | init-server  \
        | init-structure-dbwebb-kurser \
        | init-structure-www-dbwebb-kurser \
        | init-me)
            command=$1
            shift
            dbwebb-$command $*
            exit
        ;;

        *)
            badUsage "$MSG_FAILED Option/command not recognized."
            exit 2
        ;;

    esac
done

badUsage
exit 1
