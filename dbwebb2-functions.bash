# --------------- DBWEBB FUNCTIONS PHASE START ---------------

#
# Set correct mode on published file and dirs
#
publishChmod()
{
    local dir="$1"

    if [ -d "$dir" ]; then
        find "$dir" -type d -name 'cache' -exec chmod -R a+rw {} \;
        find "$dir" -type d -name 'db' -exec chmod a+rwx {} \;

        find "$dir" -type f -name '*.conf' -exec chmod go-r {} \;
        find "$dir" -type f -name '*.py' -exec chmod go-r {} \;
        find "$dir" -type f -name 'log.txt' -exec chmod go-r {} \;
        find "$dir" -type f -name '*.sh' -exec chmod go-r {} \;
        find "$dir" -type f -name '*.bash' -exec chmod go-r {} \;
        find "$dir" -type f -name '*.cgi' -exec chmod a+rx {} \;
        find "$dir" -type f -name '*.sqlite' -exec chmod a+rw {} \;
        find "$dir" -type f -name '*.sql' -exec chmod go+r {} \;

        case "$DBW_COURSE" in
            phpmvc)
                find "$dir" -type d -path '*/css/anax-grid' -exec chmod o+w {} \;
                find "$dir" -type f -path '*/css/anax-grid/style.css' -exec chmod o+w {} \;
                find "$dir" -type f -path '*/css/anax-grid/style.less.cache' -exec chmod o+w {} \;
            ;;
            linux)
                find "$dir" -type f -not -path '*/me/redovisa/*' -not -path '*/mysite/*' -name '*.js' -exec chmod go-r {} \;
                find "$dir" -type f -name 'mazerunner' -exec chmod go-r {} \;
                find "$dir" -type f -name '*.txt' -exec chmod go-r {} \;
                find "$dir" -type f -name '*.json' -exec chmod go-r {} \;
            ;;
        esac
    fi
}



#
# Does key exists in array?
#
function exists() {
    if [ "$2" != in ]; then
        echo "Incorrect usage."
        echo "Correct usage: exists {key} in {array}"
        return
    fi
    eval '[ ${'$3'[$1]+muahaha} ]'
}



#
# Check if array contains a value
#
function contains() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}



#
# Join elements with separator
# join , a "b c" d #a,b c,d
# join / var local tmp #var/local/tmp
# join , "${FOO[@]}" #a,b,c
#
function join()
{
    local IFS="$1";
    shift;
    echo "$*";
}



#
# Get the url to GitHub for a repo
#
function createGithubUrl(){
    echo "https://github.com/mosbth/$1$2"
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
#function wget {
#  if command wget -h &>/dev/null
#  then
#    command wget "$@"
#  else
#    set "${*: -1}"
#    lynx -source "$1" > "${1##*/}"
#  fi
#}



#
# Press enter to continue
#
pressEnterToContinue()
{
    printf "\nPress enter to continue..."
    read void
}



#
# Execute a command in a controlled manner
#
executeCommand()
{
    INTRO="$1"

    echo "$INTRO"

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
    if [[ ! $SILENT ]]; then
        if [ $STATUS = 0 ]
        then
            printf "$MSG_DONE $MESSAGE"
        else
            printf "$MSG_FAILED $MESSAGE"
        fi
        printf "\n"
    fi

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
# OBSOLETE to be replaced by rsync --chmod
#
setChmod()
{
    if [[ $VERY_VERBOSE ]]; then
        printf "Ensuring that all files and directories are readable for all, below $DBW_COURSE_DIR.\n"
    fi

    find "$DBW_COURSE_DIR" -type d -exec chmod u+rwx,go+rx {} \;
    find "$DBW_COURSE_DIR" -type f -exec chmod u+rw,go+r {} \;
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
        lib)        RES="me/lib" ;;
        solution)   RES=".solution" ;;
        solution/me)   RES=".solution/me" ;;
        tutorial)   RES="tutorial" ;;
        me)         RES="me" ;;
        redovisa)   RES="me/redovisa" ;;
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
                me1)        RES="me/kmom01/me1" ;;
                me2)        RES="me/kmom02/me2" ;;
                me3)        RES="me/kmom03/me3" ;;
                me4)        RES="me/kmom04/me4" ;;
                me5)        RES="me/kmom05/me5" ;;
                me6)        RES="me/kmom06/me6" ;;

                multi)      RES="me/kmom03/multi" ;;
                stylechooser) RES="me/kmom04/stylechooser" ;;
                jetty)      RES="me/kmom05/jetty" ;;
                bmo)        RES="me/kmom10/bmo" ;;

                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;
                lab3)       RES="me/kmom04/lab3" ;;
                lab4)       RES="me/kmom05/lab4" ;;
                lab5)       RES="me/kmom06/lab5" ;;
            esac
            ;;

        oophp)
            case "$CMD" in
                lab1)       RES="me/kmom02/lab1" ;;
                #lab2)       RES="me/kmom03/lab2" ;;
                #lab3)       RES="me/kmom04/lab3" ;;
                #lab4)       RES="me/kmom05/lab4" ;;
                #lab5)       RES="me/kmom06/lab5" ;;
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
                baddie4)    RES="me/kmom05/baddie4" ;;
                #baddie5)    RES="me/kmom06/baddie5" ;;
            esac
            ;;

        linux)
            case "$CMD" in
                install)    RES="me/kmom01/install" ;;
                vhost)      RES="me/kmom02/vhost" ;;
                mysite)     RES="me/kmom02/mysite" ;;
                irc)        RES="me/kmom03/irc" ;;
                script)     RES="me/kmom03/script" ;;
                javascripting) RES="me/kmom04/javascripting" ;;
                server)     RES="me/kmom04/server" ;;
                maze)       RES="me/kmom05/maze" ;;
                gomoku)     RES="me/kmom06/gomoku" ;;
                bthappen)   RES="me/kmom10/bthappen" ;;

                lab1)       RES="me/kmom02/lab1" ;; # for testing
                lab2)       RES="me/kmom04/lab2" ;; # for testing
            esac
            ;;

        webapp)
            case "$CMD" in
                me1)        RES="me/kmom01/me1" ;;
                me2)        RES="me/kmom02/me2" ;;
                me3)        RES="me/kmom03/me3" ;;
                me4)        RES="me/kmom04/me4" ;;
                me5)        RES="me/kmom05/me5" ;;
                me6)        RES="me/kmom06/me6" ;;

                meapp)      RES="me/kmom01/meapp" ;;
                ajax)       RES="me/kmom03/ajax" ;;
                jq)         RES="me/kmom03/jq" ;;
                mithril)    RES="me/kmom04/mithril" ;;
                pizza)      RES="me/kmom05/pizza" ;;
                cordova)    RES="me/kmom06/cordova" ;;
                proj)       RES="me/kmom10/proj" ;;
            esac
            ;;

        webgl)
            case "$CMD" in
                sandbox)    RES="me/kmom01/sandbox" ;;
                sandbox2)   RES="me/kmom01/sandbox2" ;;
                sandbox3)   RES="me/kmom02/sandbox3" ;;

                lab1)       RES="me/kmom02/lab1" ;;
                lab2)       RES="me/kmom03/lab2" ;;

                point)      RES="me/kmom01/point" ;;
                tri)        RES="me/kmom02/tri" ;;
                world)      RES="me/kmom03/world" ;;
                proj)       RES="me/kmom05/proj" ;;
            esac
            ;;

        oopython)
            case "$CMD" in
                flask)      RES="me/kmom01/flask" ;;
                minizoo)    RES="me/kmom02/minizoo" ;;
                test)       RES="me/kmom02/test" ;;
                uml)        RES="me/kmom02/uml" ;;

                lab1)       RES="me/kmom01/lab1" ;;
                lab2)       RES="me/kmom02/lab2" ;;
            esac
            ;;
    esac

    echo "$RES"
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

    #if [ -d "$DBW_CURRENT_DIR/$ITEM" ]; then
    #    SUBDIR="${ITEM%/}"
    #elif [ ! -z "$ITEM" -a -z "$SUBDIR" ]; then
    if [ ! -z "$ITEM" -a -z "$SUBDIR" ]; then
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
# Selfupdate
#
selfupdate()
{
    local what="$1"
    local target="$DBW_EXECUTABLE_PATH"
    local remote=
    local silent="--quiet"
    local repo="https://raw.githubusercontent.com/mosbth/dbwebb-cli"

    if [[ $VERY_VERBOSE ]]; then
        silent=""
    fi

    case $what in
        dbwebb)
            remote="$repo/master/dbwebb2"
        ;;

        dbwebb-validate)
            remote="$repo/master/dbwebb2-validate"
        ;;

        dbwebb-inspect)
            remote="$repo/master/dbwebb2-inspect"
        ;;
    esac

    printf "Your current version is: "
    $what --version

    echo "Selfupdating '$what' from $repo"

    # Downloading
    # printf '\nDownloading... '; wget $silent $remote -O /tmp/$$;
    if hash wget 2> /dev/null; then
        local dli="Downloading using wget... "
        local dlc="wget $silent $remote -O /tmp/$$"
    elif hash curl 2> /dev/null; then
        local dli="Downloading using curl... "
        local dlc="curl -so /tmp/$$ $remote"
    else
        echo "Failed. Did not find wget nor curl. Please install either wget or curl."
        exit 1
    fi
    local dlm="to download."
    executeCommand "$dli" "$dlc" "$dlm"

    # Installing
    # printf '\nInstalling... '; install /tmp/$$ $target;
    local ini="Installing... "
    local inc="install /tmp/$$ $target"
    local inm="to install."
    executeCommand "$ini" "$inc" "$inm"
    local ins=$?

    # Cleaning up
    # printf '\nCleaning up... '; rm /tmp/$$;
    local cli="Cleaning up... "
    local clc="rm /tmp/$$"
    local clm="to clean up."
    executeCommand "$cli" "$clc" "$clm"

    if [ $ins != 0 ]; then
        exit 1
    fi

    printf "The updated version is now: "
    $what --version
}



#
# Perform an assert
#
function assert()
{
    EXPECTED=$1
    TEST=$2
    MESSAGE=$3
    ASSERTS=$(( $ASSERTS + 1 ))
    local onlyExitStatus=$4
    local error=
    local status=

    bash -c "$TEST" &> "$TMPFILE"
    status=$?

    if [ \( -z "$onlyExitStatus" \) -o \( ! $status -eq $EXPECTED \) ]; then
        error=$( cat "$TMPFILE" )
    fi
    rm -f "$TMPFILE"

    if [ \( ! $status -eq $EXPECTED \) -o \( ! -z "$error" \) ]; then
        FAULTS=$(( $FAULTS + 1 ))

        printf "\n\n$MSG_WARNING $MESSAGE\n"
        [ -z "$error" ] || printf "$error\n\n"
    fi

    return $status
}



#
# Perform an assert on exit value returned
# TODO Check if this is really needed by python inspect
#
assertExit()
{
    EXPECTED=$1
    TEST=$2
    MESSAGE=$3
    ASSERTS=$(( $ASSERTS + 1 ))

    bash -c "$TEST" &> "$TMPFILE"
    STATUS=$?
    ERROR=$( cat "$TMPFILE" )
    rm -f "$TMPFILE"

    if [ $STATUS -ne $EXPECTED ]; then
        FAULTS=$(( $FAULTS + 1 ))

        printf "\n$TEST"
        printf "\n\n$MSG_FAILED $MESSAGE\n"
        [ -z "$ERROR" ] || printf "$ERROR\n\n"

        return 1
    fi

    return 0

}




#
# Clean up and output results from asserts
#
function assertResults()
{
    if [ $FAULTS -gt 0 ]
        then
        printf "\n\n$MSG_FAILED"
        printf " Asserts: $ASSERTS Faults: $FAULTS\n\n"
        exit 1
    fi

    printf "\n$MSG_OK"
    printf " Asserts: $ASSERTS Faults: $FAULTS\n"
    exit 0
}



# --------------- DBWEBB FUNCTIONS PHASE END ---------------
