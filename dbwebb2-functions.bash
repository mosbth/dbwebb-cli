#
# Print usage of script
#
dbwebb2PrintShortUsage()
{
    $ECHO "\nUtility $DBW_EXECUTABLE $DBW_VERSION by Mikael Roos (mos@dbwebb.se), to work with dbwebb course repositories."
    $ECHO "\n"
    $ECHO "\nFor overview of the command, execute:"
    $ECHO "\n$DBW_EXECUTABLE help"
    $ECHO "\n"
    $ECHO "\n"
}



#
# Print usage of script
#
dbwebb2PrintUsage()
{
    $ECHO "\nUtility $DBW_EXECUTABLE $DBW_VERSION by Mikael Roos (mos@dbwebb.se), to work with dbwebb course repositories."
    $ECHO "\n"
    $ECHO "\nUsage: $DBW_EXECUTABLE [options] <command> [arguments]"
    $ECHO "\n"
    $ECHO "\nOptions:"
    $ECHO "\n"
    $ECHO "\n  -h         Print this message and exit."
    $ECHO "\n  -i         Prints help with commands for inspect."
    $ECHO "\n  -v         Very verbose, print out whats happening."
    $ECHO "\n  -y         Do not wait for my input, just proceed."
    $ECHO "\n"
    $ECHO "\nCommand:"
    $ECHO "\n"
    $ECHO "\n  help           Print this message."
    $ECHO "\n  version        Print the version of this program and exit."
    $ECHO "\n  env            Check and print out details on the environment."
    $ECHO "\n  config, create-config Create, or re-create the config file."
    $ECHO "\n  selfupdate     Update dbwebb-cli installation."
    $ECHO "\n  sshkey         Create and install ssh-keys to avoid using password."
    $ECHO "\n  login          Login to the remote server using ssh and sshkeys if available."
    $ECHO "\n  init-server    Init the server by creating a directory structure on it."
    $ECHO "\n"
    $ECHO "\nCommands to manage course repos:"
    $ECHO "\n"
    $ECHO "\n  ls             List all locally installed course repos within \$DBWEBB_HOME."
    $ECHO "\n  repo           List all supported remote course repos."
    $ECHO "\n  clone repo     Clone and locally install a remote course repo."
    $ECHO "\n"
    $ECHO "\nCommands for a valid course repo:"
    $ECHO "\n"
    #$ECHO "\n  init-repo      Init the repo for the first time and create a config-file."
    $ECHO "\n  init-me        Init the directory me/ by copying files and directories from default/."
    $ECHO "\n  update         Update the courserepo with latest updates from the master repo."
    $ECHO "\n"
    $ECHO "\n  validate [part] Validate (and upload) your files using the remote server."
    $ECHO "\n"
    $ECHO "\n  ~upload        Upload current directory to the the server."
    $ECHO "\n  ~download      Download current directory from the server."
    $ECHO "\n"
    $ECHO "\n  ~push [part]   Upload all or a specific part of the course repo to the server."
    $ECHO "\n  ~pull [part]   Download all or a specific part of the course repo from the server."
    $ECHO "\n"
    $ECHO "\n  inspect        Inspect a kmom for yourself or a specific user, needs teacher privilegies"
    $ECHO "\n                 to check another students kmom."
    $ECHO "\n"
    $ECHO "\n  TBD"
    $ECHO "\n  create       Create a laboration, use additional argument for naming what lab to create."
    $ECHO "\n  publish      Upload, Validate and Publish your course results to the web."
    $ECHO "\n               Send in kmom01, kmom02, etc to publish only one kmom."
    $ECHO "\n               Default is to publish all."
    $ECHO "\n"
    $ECHO "\n  Obsolete?"
    $ECHO "\n  init         Init the remote server and create a destination directory."
    $ECHO "\n"
    $ECHO "\n"
}



#
# Print usage of script
#
dbwebb2PrintUsageInspect()
{
    $ECHO "\nCommands useful at the server with respect to dbwebb inspect, needs extra privilegies."
    $ECHO "\n"
    $ECHO "\nOpen up for inspect by setting group and chmod for directories and files."
    $ECHO "\nsudo /usr/local/sbin/setpre-dbwebb-kurser.bash acronym"
    $ECHO "\n"
    $ECHO "\nAdd or delete as member of the dbwebb-group (execute on all servers)"
    $ECHO "\nsudo update-dbwebb-kurser.bash -a acronym"
    $ECHO "\nsudo update-dbwebb-kurser.bash -d acronym"
    $ECHO "\n"
    $ECHO "\nExecute command as the user dbwebb."
    $ECHO "\nsudo -u dbwebb script"
    $ECHO "\n"
    $ECHO "\n"
}



#
# Create the config file .dbwebb.config in the root directory of the current course repo.
#
createConfig()
{
    FIRST=$1
    NO_INPUT=$2

    if [ -z $FIRST ]
    then

        $ECHO "The config-file '$DBW_CONFIG_FILE_NAME' will now be created in your home directory: '$HOME'"

    elif [ $FIRST = "update" ]
    then

        $ECHO "Your config file will be automatically updated. Then re-run your command.\n"

    elif [ $FIRST = "upgrade" ]
    then

        $ECHO "Your config file will be automatically updated."

    elif [ $FIRST = "create" ]
    then

        $ECHO "I will now re-create the configuration file '$DBW_CONFIG_FILE_NAME' in your home directory: '$HOME'."

    fi


    if [ -z "$NO_INPUT" ]
    then

        DBW_USER=${DBW_USER:-$USER}
        $ECHO "\nWhat is your student acronym? [$DBW_USER] "
        read ACRONYM

    fi

    ACRONYM=${ACRONYM:-$DBW_USER}

    cat "$DBW_CONFIG_DEFAULT_FILE" | $SED s/DEFAULT_USER/$ACRONYM/g > "$DBW_CONFIG_FILE"

    $ECHO "\nThe config file '$DBW_CONFIG_FILE' is now up-to-date."
    $ECHO "\n\n"
}



#
# Update the config-file if needed
#
updateConfigIfNeeded()
{
    WHAT=$1

    if [ -z "$DBW_VERSION_CONFIG" -o ! "$DBW_VERSION" = "$DBW_VERSION_CONFIG" ]
    then
        createConfig "$WHAT" "no-user-input"
        exit 2
    fi
}



#
# Display information on the environment
#
environment()
{
    $ECHO "\nDetails on installed utilities."
    $ECHO "\n------------------------------------"
    $ECHO "\n"
    $ECHO "\nbash:                  %s" "$( checkCommand $BASH )"
    $ECHO "\ngit:                   %s" "$( checkCommand $GIT )"
    $ECHO "\nssh:                   %s" "$( checkCommand $SSH )"
    $ECHO "\nrsync:                 %s" "$( checkCommand $RSYNC )"
    $ECHO "\nwget:                  %s" "$( checkCommand $WGET )"
    $ECHO "\ncurl:                  %s" "$( checkCommand $CURL )"
    $ECHO "\n"
    $ECHO "\n"

    $ECHO "\nDetails on the dbwebb-environment."
    $ECHO "\n------------------------------------"
    $ECHO "\n"
    $ECHO "\nOperatingsystem:       $DBW_OS"
    $ECHO "\nCommand issued:        $DBW_EXECUTABLE"
    $ECHO "\nVersion of dbwebb is:  $DBW_VERSION"
    $ECHO "\nLatest commit:         $( cd $DBW_INSTALL_DIR; $GIT describe --always )"
    $ECHO "\nPath to executable:    '$DBW_EXECUTABLE_DIR'"
    $ECHO "\nInstall dir:           '$DBW_INSTALL_DIR'"
    $ECHO "\nConfig-file:           '$DBW_CONFIG_FILE'"
    $ECHO "\nWorking directory:     '$DBW_CURRENT_DIR'"
    $ECHO "\nLocal user:            '$USER'"
    $ECHO "\nLocal homedir:         '$HOME'"
    $ECHO "\nRemote user:           '$DBW_USER'"
    $ECHO "\nRemote host:           '$DBW_HOST'"
    $ECHO "\n"
    $ECHO "\n"

    $ECHO "\nDetails on home for course-repos."
    $ECHO "\n------------------------------------"
    $ECHO "\n"

    if [ -d "$DBW_HOME" ]; then
        $ECHO "\nHome of course repos:  '$DBW_HOME'"
        $ECHO "\n"
        $ECHO "\nContent of directory is:"
        $ECHO "\n"
        ls -lF "$DBW_HOME"
    else 
        $ECHO "\nThere is no specific home defined for the course repos."
    fi

    $ECHO "\n"
    $ECHO "\n"

    $ECHO "\nDetails on current course-repo."
    $ECHO "\n------------------------------------"
    $ECHO "\n"

    if [ "$DBW_COURSE_REPO_VALID" = "yes" ]; then
        $ECHO "\nCurrent course-repo:   '$DBW_COURSE'"
        $ECHO "\nCourse directory:      '$DBW_COURSE_DIR'"
        $ECHO "\nCourse-repo version:   $( $GIT describe --always )"
        $ECHO "\n\nLatest update to course repo was:"
        $ECHO "\n"
        $GIT log -1
    else 
        $ECHO "\nThis is not a valid course repo."
    fi
    $ECHO "\n"
    $ECHO "\n"

}



#
# Check for installed commands
#
checkCommand()
{
    COMMAND=$1
    #$ECHO "\nChecking $COMMAND"

    if ! hash "$COMMAND" 2>/dev/null; then
        $ECHO "Command $COMMAND not found"
    else 
        $ECHO $( which $COMMAND )
    fi
}



#
# ls $DBWEBB_HOME
#
lsHome()
{
    if [ -d "$DBWEBB_HOME" ]; then
        cd "$DBWEBB_HOME"
        $ECHO $( pwd )
        $ECHO "\n"
        ls -lF
    else 
        $ECHO "\nYou have not set \$DBWEBB_HOME nor do you have a directory \$HOME/$DBW_BASEDIR."
    fi
}



#
# List all available remote repos
#
reposList()
{
    $ECHO "\nThe following remote course repos are supported."
    $ECHO "\n"
    $ECHO "\n python       https://github.com/mosbth/python"
    $ECHO "\n javascript1  https://github.com/mosbth/javascript1"
    $ECHO "\n linux        https://github.com/mosbth/linux"
    $ECHO "\n webapp       https://github.com/mosbth/webapp"
    $ECHO "\n htmlphp      https://github.com/mosbth/htmlphp"
    $ECHO "\n"
    $ECHO "\n"
}



#
# Clone a remote repos
#
reposClone()
{
    local repo="$1"
    local repos=(python javascript1 linux webapp htmlphp)

    if [ ! -d "$DBWEBB_HOME" ]; then
        $ECHO "\nYou have not set \$DBWEBB_HOME nor do you have a directory \$HOME/$DBW_BASEDIR."
    else
        ok=0
        for i in ${repos[@]}; do
            if [ "$repo" == "${i}" ]; then
                
                ok=1
                if [ -d "$DBWEBB_HOME/$repo" ]; then
                    $ECHO "\n$MSG_FAILED to clone. There seem to exist a directory with this name already."
                    $ECHO "\n"
                else
                    cmd="$GIT clone https://github.com/mosbth/$repo"
                    $ECHO "\nCloning remote course repo and making a local installation."
                    $ECHO "\nMoving to '$DBWEBB_HOME'"
                    $ECHO "\n$cmd"
                    cd "$DBWEBB_HOME"
                    $cmd
                fi
            fi
        done

        if [ $ok -eq 0 ]; then
            $ECHO "\n$MSG_FAILED to clone remote repo, unknown repo '$repo'. Use '$DBW_EXECUTABLE repos' to get a list of supported repos."
            $ECHO "\n"
            dbwebb2PrintShortUsage
        fi
    fi
}



#
# Selfupdate
#
selfUpdate()
{
    INTRO="Selfupdating dbwebb-cli from https://github.com/mosbth/dbwebb-cli.\nInstallation directory is: '$DBW_INSTALL_DIR'."
    COMMAND="cd '$DBW_INSTALL_DIR'; $GIT pull"
    MESSAGE="to update dbwebb-cli installation directory."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Execute a command in a controlled manner
#
executeCommand()
{
    INTRO=$1

    if [ $SKIP_READLINE = "no" ]
    then
        $ECHO "\n$INTRO"
        $ECHO "\nPress a key to continue..."
        read void
    fi

    REALLY=$4
    if [ ! -z $REALLY ]
    then
        $ECHO "\nAre you really sure? [yN] "
        read answer
        default="n"
        answer=${answer:-$default}

        if [ ! "$answer" = "y" -o "$answer" = "Y" ]
        then
            $ECHO "Exiting...\n"
            exit 0
        fi
    fi

    COMMAND=$2

    if [ $VERY_VERBOSE = "yes" ]
    then
        $ECHO "\nExecuting command:"
        $ECHO "\n$COMMAND"
        $ECHO "\n-----------------------------------------"
        $ECHO "\n"
    fi

    bash -c "$COMMAND"
    STATUS=$?

    if [ $VERY_VERBOSE = "yes" ]
    then
        $ECHO "\n-----------------------------------------"
    fi

    MESSAGE=$3
    if [ $STATUS = 0 ]
    then
        $ECHO "\n$MSG_OK $MESSAGE"
    else
        $ECHO "\n$MSG_FAILED $MESSAGE"
    fi
    $ECHO "\n"
    $ECHO "\n"

    return $STATUS
}



#
# Create default files.
#
createDefaultFiles()
{
    ME_DEFAULT="$DBW_COURSE_DIR/.default/"
    ME="$DBW_COURSE_DIR/me/"

    INTRO="Initiating the directory 'me/' by copying directory structure and files from the directory '.default/' (will not overwrite existing files)."
    COMMAND="$RSYNC -av --exclude README.md --ignore-existing \"$ME_DEFAULT\" \"$ME\""
    MESSAGE="to init the directory 'me/'."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Init directory structure at the server.
#
initServer()
{
    INTRO="Intiating the remote server '$DBW_HOST' by connecting as '$DBW_USER' and creating directories (if needed) where all uploaded files will reside."
    # TBD Should use DBW_BASEDIR 
    COMMAND="$SSH_CMD 'sh -c \"if [ ! -d dbwebb-kurser ]; then mkdir dbwebb-kurser; fi; chmod 700 dbwebb-kurser; echo; echo \"dbwebb-kurser:\"; ls -l dbwebb-kurser; if [ ! -d www/dbwebb-kurser ]; then mkdir www/dbwebb-kurser; fi; chmod 755 www/dbwebb-kurser; echo; echo \"www/dbwebb-kurser:\"; ls -l www/dbwebb-kurser\"'"
    MESSAGE="to init the server."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Test the connection to the server
#
#testConnection()
#{
#    INTRO="I will now try to establish a connection with the server '$DBW_HOST' by connecting to it and logging in as user '$DBW_USER'. I will use ssh-keys if available."
#    COMMAND="$SSH_CMD cat /etc/motd"
#    MESSAGE="to establish the connection."
#    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
#}



#
# Login to the server
#
loginToServer()
{
    INTRO="I will now login to the server '$DBW_HOST' as '$DBW_USER' using ssh-keys if available."
    COMMAND="$SSH_CMD"
    MESSAGE="to establish the connection."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Inspect uploaded files
#
inspectResults()
{
    WHAT=$1
    WHO=$2
    INTRO="I will now inspect the choosen kmom for the choosen user, if you have privilegies to do that."
    LOG="$HOME/$BASEDIR/.dbwebb-inspect.log"
    COMMAND="$SSH_CMD 'cd $DBW_BASEDIR/$DBW_COURSE; bin/dbwebb-inspect $WHAT $WHO' | tee $LOG; "
    MESSAGE="to inspect the course results. Saved a log of the output, review it as:\nless -R $LOG"

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



#
# Upload results to the server
#
updateFromMaster()
{
    INTRO="Update course-repo with latest changes from its master at GitHub."
    COMMAND="$GIT pull"
    MESSAGE="to update course repo."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"

    # ? really needed
    source "$DBW_VERSION_FILE"
    updateConfigIfNeeded "upgrade"
}



#
# Set proper rights for files and directories
#
setChmod()
{
    if [ $VERY_VERBOSE = "yes" ]; then
        $ECHO "\nEnsuring that all files and directories are readable for all, below $DBW_COURSE_DIR."
    fi

    $FIND "$DBW_COURSE_DIR" -type d -exec chmod u+rwx,go+rx {} \;  
    $FIND "$DBW_COURSE_DIR" -type f -exec chmod u+rw,go+r {} \;   
}



#
# Push/upload results to the server
#
pushToServer()
{
    WHAT="$1"
    WHERE="$2"
    ITEM="$3"

    if [ -z "$WHAT" -o -z "$WHERE" ]; then
        $ECHO "$MSG_FAILED Missing argument for source or destination. Perhaps re-create the config-file?"
        $ECHO "\n\n"
        exit 1
    fi

    echo "Item: $ITEM"

    INTRO="Pushing (uploading) the directory '$WHAT/' to '$WHERE/'."
    COMMAND="$RSYNC_CMD $WHAT/ $WHERE/"
    MESSAGE="to upload data."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Pull/download from the server
#
pullFromServer()
{
    INTRO="You will now download the content of youre me-directory FROM the server. Existing local files that are newer will not be overwritten."
    COMMAND="rsync -avu --exclude default -e \"ssh $SSH_KEY_OPTION\" \"$DESTINATION/me/\" \"$SOURCE/me/\""
    MESSAGE="to download the me-directory from the server."
    echo executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
}



#
# Upload results to the server
#
uploadToServer()
{
    subdir=${DBW_CURRENT_DIR#"$DBW_COURSE_DIR/"}

    INTRO="Your current working directory '$DBW_CURRENT_DIR' will now be uploaded to remote server."
    COMMAND="$RSYNC_CMD $DBW_CURRENT_DIR/ $DBW_REMOTE_DESTINATION/$subdir/"
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
    COMMAND="$RSYNC_CMD $DBW_REMOTE_DESTINATION/$subdir/ $DBW_CURRENT_DIR/"
    MESSAGE="to download files."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE" "REALLY?"
}



#
# Create and use ssh-keys to login.
#
installSshKeys()
{
    SSH_KEY="$HOME/.ssh/dbwebb"

    if [ ! -d "$HOME/.ssh" ]
    then
        mkdir "$HOME/.ssh"
    fi

    INTRO="First we need to create a ssh key and store it locally."
    COMMAND="ssh-keygen -t dsa -f '$SSH_KEY' -N ''"
    MESSAGE="to create the ssh key."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"

    # Bug (?) om Cygwin & win 8
    #echo $IS_CYGWIN
    if [ $IS_CYGWIN = "yes" ]
    then
        chgrp -vR "$CYGWIN_DEFAULT_GROUP" "$HOME/.ssh"
    fi

    chmod 700 "$HOME/.ssh"
    chmod 600 "$SSH_KEY" "$SSH_KEY.pub"

    INTRO="I will now install the ssh-key at the remote server."
    COMMAND="cat '$SSH_KEY.pub' | ssh $DBW_USER@$DBW_HOST 'sh -c \"if [ ! -d .ssh ]; then mkdir .ssh; fi; chmod 700 .ssh; touch .ssh/authorized_keys; cat >> .ssh/authorized_keys\"'"
    MESSAGE="to install the ssh-keys."
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



#
# Validate the uploaded files
#
validateUploadedResults()
{
    WHAT=$1
    LOG="$HOME/$BASEDIR/.dbwebb-validate.log"
    INTRO="I will now upload files to the remote server and validate them."
    COMMAND="$SSH 'cd $BASEDIR/$PROJECT; bin/dbwebb-validate -n $IGNORE_FAULTS $WHAT' | tee $LOG;"
    MESSAGE="to validate course results. Saved a log of the output, review it as:\nless -R $LOG"
    executeCommand "$INTRO" "$UPLOAD; $COMMAND" "$MESSAGE"
}



#
# Validate and Publish the uploaded files
#
publishResults()
{
    WHAT=$1
    LOG="$HOME/$BASEDIR/.dbwebb-publish.log"
    INTRO="I will now try to init the remote server and create a directory where all uploaded files will reside."
    COMMAND="$SSH 'cd $BASEDIR/$PROJECT; bin/dbwebb-validate $IGNORE_FAULTS $WHAT' | tee $LOG;"
    MESSAGE="to validate and publish all course results. Saved a log of the output, review it as:\nless -R $LOG"
    executeCommand "$INTRO" "$UPLOAD; $COMMAND" "$MESSAGE"

    if [ $? -eq 0 ]
    then
        $ECHO "Your files are now"
    else
        $ECHO "Some of your files might be"
    fi
    $ECHO " published on $BASEURL"
    $ECHO "\n"
}



