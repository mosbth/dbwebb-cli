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
            databas)
                find "$dir" -type d -path '*/me/kmom*' -exec chmod -R go-r {} \;
            ;;
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
            oopython \
            | matmod)
                find "$dir" -type f -path '*/db/*.json' -exec chmod go+w {} \;
                find "$dir" -type f -name '*.py' -exec chmod go+r {} \;
                #find "$dir" -type f -name '*.py' -path '*/flask/*' -exec chmod go+r {} \;
                #find "$dir" -type f -name '*.py' -path '*/my_app/*' -exec chmod go+r {} \;
            ;;
        esac
    fi
}



#
# realpath -f dows not work on Mac OS
#
function get_realpath()
{
    # failure : file does not exist.
    [[ ! -e "$1" ]] && return 1

    # do symlinks.
    [[ -n "$no_symlinks" ]] && local pwdp='pwd -P' || local pwdp='pwd'

    # Path to dir, without eventual filename
    local path="$( cd "$( echo "${1%/*}" )" 2>/dev/null; $pwdp )"

    if [ -d "$1" ]; then
        path="$( cd "$( echo "$1" )" 2>/dev/null; $pwdp )"
    elif [ -f "$1" ]; then
        path="$path/${1##*/}"
    fi

    echo "$path"
    return 0
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
    echo "https://github.com/dbwebb-se/$1$2"
}



#
# Check for installed commands
#
function checkCommand
{
    local COMMAND="$1"

    if ! hash "$COMMAND" 2>/dev/null; then
        printf "Command $COMMAND not found."
    else
        printf "$( which $COMMAND )"
    fi
}



#
# Check command and version of it with nice string as result
#
function checkCommandWithVersion
{
    local what="$1"
    local version="$2"
    local options="$3"

    if ! hash "$what" 2>/dev/null; then
        printf "%-10s Command '%s' not found." "-" "$what"
    else
        if [ ! -z "$version" ]; then
            printf "%-10s %s" "$( eval $what $version $options )" "$( which $what )"
        else
            printf "%-10s %s" "?" "$( which $what )"
        fi
    fi
}




#
# Use command (wget, curl, lynx) to download url and output to stdout.
#
function getUrlToStdout
{
    local cmd=
    local url="$1"
    local filename="/tmp/dbwebb.curl.$$"
    local exitCode=

    veryVerbose "Saving url in '$filename'."
    getUrlToFile "$url" "$filename"
    exitCode=$?

    cat "$filename" \
        || die "Failed to echo content from downloaded file."
    rm -f "$filename"

    ( exit $exitCode )
}



#
# Use command (wget, curl, lynx) to download url and output to file.
#
function getUrlToFile
{
    local cmd=
    local verbose=
    local url="$1"
    local filename="$2"

    if hash curl 2>/dev/null; then
        [[ $VERY_VERBOSE ]] && verbose="--verbose"
        cmd="curl --fail --silent $verbose \"$url\" -o \"$filename\""
    elif hash wget 2>/dev/null; then
        verbose="--quiet"
        [[ $VERY_VERBOSE ]] && verbose="--verbose" 
        cmd="wget $verbose -O \"$filename\" \"$url\""
    elif hash lynx 2>/dev/null; then
        cmd="lynx -source \"$url\" > \"$filename\""
    fi

    veryVerbose "Command: $cmd"
    if [ -f "$filename" ]; then
        die "The file '$filename' already exists, please remove it before you download a new."
    fi
    [[ $OPTION_DRY ]] || bash -c "$cmd"
}



#
# Press enter to continue
#
pressEnterToContinue()
{
    if [[ ! $YES ]]; then
        printf "\nPress enter to continue..."
        read void
    fi
}



#
# Answer yes or no to proceed
#
answerYesOrNo()
{
    local answer="y"
    local default="$1"

    if [[ ! $YES ]]; then
        read answer
        answer=${answer:-$default}
    fi

    echo "$answer"
}



##
# Print confirmation message with default values.
#
# @param string $1 the message to display or use default.
# @param string $2 the default value for the response.
#
confirm()
{
    [[ $YES ]] && return 0

    read -r -p "${1:-Are you sure? [yN]} "
    case "${REPLY:-$2}" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}



##
# Read input from user supporting a default value for reponse.
#
# @param string $1 the message to display.
# @param string $1 the default value.
#
input()
{
    read -r -p "$1 [$2]: "
    echo "${REPLY:-$2}"
}



#
# Execute a command in a controlled manner
#
function executeCommandInSubShell
{
    executeCommand "$1" "$2" "$3" "$4" "subshell"
}



#
# Execute a command in a controlled manner
#
function executeCommand
{
    local introText="$1"
    local subshell="$5"
    
    # Introduction text for the command
    echo "$introText"

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

    if [ "$subshell" = "subshell" ]; then
        ( "$COMMAND" )
    else
        bash -c "$COMMAND"
    fi
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
# Convert version to a compareble string
# Works for 1.0.0 and v1.0.0
#
function getSemanticVersion
{
    #local version=${1:1}
    local version=$( echo $1 | sed s/^[vV]// )
    echo "$version" | awk -F. '{ printf("%03d%03d%03d\n", $1,$2,$3); }'
}



#
# Check if current version of dbwebb-cli matches minimum required version.
#
function checkMinimumVersionRequirementOrExit
{
    if [[ $DBW_VERSION_REQUIREMENT ]]; then
        local required current
        required=$( getSemanticVersion $DBW_VERSION_REQUIREMENT )
        current=$( getSemanticVersion $DBW_VERSION )
        if [ "$current" -lt "$required" ]; then
            printf "$MSG_FAILED You need to upgrade dbwebb-cli to work with this course repo.\nDo a 'dbwebb selfupdate'.\n"
            printf "Your current version is:     %s\n" "$DBW_VERSION"
            printf "Minimum required version is: %s\n" "$DBW_VERSION_REQUIREMENT"
            exit 1
        fi
    fi
}



#
# Check if within a valid course repo or exit
#
function checkIfValidCourseRepoOrExit
{
    if [ "$DBW_COURSE_REPO_VALID" != "yes" ]; then
        printf "$MSG_FAILED Could not find file '%s', this is not a valid course repo." "$DBW_COURSE_FILE_NAME"
        printf "\nThis command must be executed within a valid course repo."
        printf "\n"
        exit 1
    fi

    checkMinimumVersionRequirementOrExit
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
# Check if valid combination of course and target.
#
function checkIfValidCombination()
{
    local res="$1"
    local target="$2"

    if [ -z "$res" ]; then
        printf "$MSG_FAILED Not a valid combination of '$DBW_COURSE' and target '$target'.\n"
        exit 2
    fi
}



#
# Check if subdir to me/ exists or propose to run init.
#
checkIfSubdirExistsOrProposeInit()
{
    local dir="$1"

    if [ ! -d "$dir" ]; then
        printf "$MSG_FAILED The target directory '$dir' is missing.\nPerhaps, did you run the command 'dbwebb init' or misspelled the command?\n"
        exit 2
    fi
}



#
# Fail, die and present error message.
#
die()
{
    local message="$1"
    local status="${2:-1}"

    printf "$MSG_FAILED $message\n" >&2
    exit $status
}



#
# Print out information details in standard verbose mode.
#
verboseDone()
{
    [[ $SILENT ]] || printf "$MSG_DONE $1\\n" 
}



#
# Print out information details in standard verbose mode.
#
verbose()
{
    [[ $SILENT ]] || printf "$1\\n" 
}



#
# Print out details in very verbose mode.
#
veryVerbose()
{
    [[ $VERY_VERBOSE ]] && printf "$1\\n" >&2
}



#
# Read the version of the labs used, from configuration file.
#
readLabVersionFromConfig()
{
    [ -f "$DBW_COURSE_DIR/.dbwebb/lab.version" ] \
        && cat "$DBW_COURSE_DIR/.dbwebb/lab.version"
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

    [ ! -z $RES ] && echo "$RES" && return

    # Check for known pathes in course repo config file
    local mapFile="$DBW_COURSE_DIR/.dbwebb.map"
    local item=
    if [ -f "$mapFile" ]; then
        while IFS= read -r path
        do
            item=$( basename "$path" )
            if [ "$CMD" = "$item" -a -d "$path" ]; then
                echo "$path"
                return
            fi
        done < <(grep "^[^#]" "$mapFile")
    fi

    # Check for existing directories below me/
    [ -d "$DBW_COURSE_DIR/me/$CMD" ] && echo "me/$CMD" && return 

    # Check me/* for match
    RES=$( cd "$DBW_COURSE_DIR" && find me -mindepth 2 -maxdepth 2 -name "$CMD" -type d | head -n 1 )

    echo "$RES"
    return
}



#
# Get path to dir to check, use both parts of courses and fallback
# to absolute and relative paths.
#
function createDirsInMeFromMapFile
{
    local mapFile="$DBW_COURSE_DIR/.dbwebb.map"
    if [ -f "$mapFile" ]; then
        while IFS= read -r path
        do
            echo "$path"
            install -d "$DBW_COURSE_DIR/$path"
        done < <(grep "^[^#]" "$mapFile")
    fi
}



#
# Get path to dir to check, use both parts of courses and fallback
# to absolute and relative paths.
#
function getPathToDirectoryFor
{
    local dir="$( mapCmdToDir $1 )"

    if [ -z "$command" ]; then
        echo "$DBW_CURRENT_DIR"
    elif [ -z "$dir" -a -d "$command" ]; then
        echo "$command"
    elif [ -z "$dir" -a -d "$DBW_CURRENT_DIR/$command" ]; then
        echo "$DBW_CURRENT_DIR/$command"
    elif [ ! -z "$dir" -a -d "$DBW_COURSE_DIR" -a -d "$DBW_COURSE_DIR/$dir" ]; then
        echo "$DBW_COURSE_DIR/$dir"
    else
        printf "\n$MSG_FAILED The item '$command' was mapped to directory '$dir' which is not a valid directory.\n"
        exit 1
    fi
}



#
# Validate the uploaded files
#
createUploadDownloadPaths()
{
    local ignoreSubdir="$1"
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

    if [ ! -z "$ignoreSubdir" ]; then
        WHAT="$WHAT/"
        WHERE="$WHERE/"
    elif [ ! -z "$SUBDIR" ]; then
        WHAT="$WHAT/$SUBDIR/"
        WHERE="$WHERE/$SUBDIR/"
    else
        WHAT="$WHAT/"
        WHERE="$WHERE/"
    fi

    #echo "WHAT=$WHAT"
    #echo "WHERE=$WHERE"

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
    local version="$2"
    local target="$DBW_EXECUTABLE_PATH"
    local remote=
    local silent="--quiet"
    local repo="https://raw.githubusercontent.com/mosbth/dbwebb-cli/master"

    if [[ $VERY_VERBOSE ]]; then
        silent=""
    fi

    [[ $version ]] && repo="$repo/release/$version/"

    case $what in
        dbwebb)
            remote="$repo/dbwebb2"
        ;;

        dbwebb-validate)
            remote="$repo/dbwebb2-validate"
        ;;

        dbwebb-inspect)
            remote="$repo/dbwebb2-inspect"
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
    else
        echo "Failed. Did not find wget. Please install wget."
        exit 1
    fi
    local dlm="to download."
    executeCommand "$dli" "$dlc" "$dlm"
    [[ $STATUS > 0 ]] && echo "Could not download the remote file, check the download link if its correct." && exit 1

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

        printf "\n\n$MSG_WARNING %s\n" "$MESSAGE"
        [ -z "$error" ] || printf "%s\n\n" "$error"
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
