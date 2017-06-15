# --------------- DBWEBB-INSPECT MAIN START HERE ---------------
#
# Settings
#
WRAP_HEADER="\n\n\n-------------------------------------------------------------"
WRAP_FOOTER="\n-------------------------------------------------------------"



#
# Write header for each test
#
headerForTest()
{
    what="$1"
    task="$2"

    pressEnterToContinue
    
    printf "$WRAP_HEADER"
    printf "\n$what"
    if [ ! -z "$task" ]; then
        printf "\n$task"
    fi
    printf "$WRAP_FOOTER"
}


#
# Open files in editor
#
openFilesInEditor()
{
    printf "\nOpen files in an editor:"
    printf "\n$EDITOR \"%s/%s\"" "$THEDIR" "$1"
    printf "\n"
}



#
# Open files in editor
#
viewFileTree()
{
    local dirname="$THEDIR/$1"
    local options="$TREE_OPTIONS"

    TREE_OPTIONS=

    printf "\nView content of directory:\n"
    tree -ph -L 2 $options "$dirname"
}



#
# Change to directory
#
changeToDirectory()
{
    local dirname="$THEDIR/$1"
    
    printf "\ncd \"%s/%s\"" "$THEDIR" "$1"
    printf "\n"
}



#
# Print url and check if it exists
#
printUrl()
{
    local what="$1"
    local where="$2"

    if [ "$what" == "-" ]; then
        what=
    fi
    
    printf "\nURL: $BASE_URL/$DBW_COURSE/$where/$what"

    if [ -z "$what" ]; then
        assert 0 "test -d \"$THEDIR/$where\"" "The directory '$where' is missing or not readable."
    else
        assert 0 "test -f \"$THEDIR/$where/$what\"" "The file '$what' is missing or not readable."
    fi

    printf "\n"
}



#
# Check if file exists and display it 
#
executeSQLite()
{
    local file="$1"
    local dir="$THEDIR"
    local sql="$2"

    assert 0 "test -f \"$THEDIR/$file\"" "The file '$file' is missing or not readable."

    if [ $? -eq 0 ]; then
        printf "\nSQLite '%s':\nView '%s' [Yn]? " "$file" "$sql"

        local answer=$( answerYesOrNo "y" )
        if [ "$answer" = "y" -o "$answer" = "Y" ]
        then
            echo ">>>"
            sqlite3 --header --column "$dir/$file" "$sql"
            echo "<<<"
            pressEnterToContinue
        fi
    fi
}



#
# Check if file exists and display it 
#
viewFileContent()
{
    local file="$1"
    local dir="$2"
    local fileAlt="$3"
    
    if [ ! -f "$THEDIR/$dir/$file" ]; then 
        if [ -f "$THEDIR/$dir/$fileAlt" ]; then
            file="$fileAlt"
        fi
    fi
    
    assert 0 "test -f \"$THEDIR/$dir/$file\"" "The file '$file' is missing or not readable."

    if [ $? -eq 0 ]; then
        printf "\nView file '%s' [Yn]? " "$file"

        local answer=$( answerYesOrNo "y" )
        if [ "$answer" = "y" -o "$answer" = "Y" ]
        then
            echo ">>>"
            less --quit-if-one-screen --no-init "$THEDIR/$dir/$file"
            echo "<<<"
            pressEnterToContinue
        fi
    fi
}



#
# Test check the kmom dir exists
#
checkKmomDir()
{
    local dirname="$THEDIR/$1"
    
    assert 0 "test -r $dirname -a -d $dirname" "Directory $dirname not readable."
}



#
# Test check the file exists and is readable
#
fileIsReadable()
{
    local filename="$THEDIR/$1"
    
    assert 0 "test -r $filename" "The file $filename is not readable."
}



#
# Check if dir seems to be a git repo
#
isGitRepo()
{
    local dirname="$THEDIR/$1"

    #echo "Validate that path is a Git repo."
    assert 0 "test -r $dirname -a -d $dirname" "Directory $dirname does not seem to be a git repo."
}



#
# Check if the git tag is between argument
#
hasGitTagBetween()
{
    local where="$1"
    local low=
    local high=
    local semTag=

    low=$( getSemanticVersion "$2" )
    high=$( getSemanticVersion "$3" )
    #echo "Validate that tag exists >=$2 and <$3 ."

    local success=false
    local highestTag=0
    local highestSemTag=0

    if [ -d "$where" ]; then
        while read -r tag; do
            semTag=$( getSemanticVersion "$tag" )
            #echo "trying tag $tag = $semTag"
            if [ $semTag -ge $low -a $semTag -lt $high ]; then
                #echo "success with $tag"
                success=
                if [ $semTag -gt $highestSemTag ]; then
                    highestTag=$tag
                    highestSemTag=$semTag
                fi
            fi
        done < <( cd "$where" && git tag )
    fi

    if [ "$success" = "false" ]; then
        assert -1 "test -d $where" "Failed to validate tag exists >=$2 and <$3."
    fi

    echo $highestTag
}



#
# Test general
#
function inspectIntro()
{
    local target="me/$KMOM"

    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir "$target"
    publishKmom
    viewFileTree "$target"
    validateKmom "$KMOM"
}



#
# The me-page
#
function inspectMe()
{
    local target="$1"
    local mepage="$2"
    local reportpage="$3"
    local assignment="$4"
    local validate="$5"

    # Anybody using this argument?
    if [ ! -z "$assignment" ]; then
        assignment="\n-- ${DBW_WWW}$assignment"
    fi

    headerForTest "-- me-page" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning$assignment" 
    checkKmomDir "$target"
    viewFileTree "$target"
    openFilesInEditor "$target"

    printUrl "$mepage" "$target"  
    [[ $reportpage ]] && printUrl "$reportpage" "$target"
    [[ $validate ]] && validateKmom "$validate"
}



#
# Test a lab, or general assignment
# answer.php  - php answer.php
# answer.bash - ./answer.bash
#
function inspectLab()
{
    local url="$1"
    local lab="$2"
    local main="$3"
    local execute="$4"
    local target="me/$KMOM/$lab"

    headerForTest "-- $lab" "-- ${DBW_WWW}$url"
    viewFileTree "$target"
    openFilesInEditor "$target"
    printUrl "" "$target"  
    checkKmomDir "$target"
    fileIsReadable "$target/$main"
    [[ $execute ]] && inspectCommand "$main" "$EXEC_DIR/$KMOM/$lab" "$execute"
}



#
# Test a exercise
#
inspectExercise()
{
    local exercise="$1"
    local url="$2"
    local file1="$3"
    local file2="$4"
    local file3="$5"
    local file4="$6"
    local file5="$7"
    local file6="$8"
    local file7="$9"
    local file8="${10}"
    local info="${11}"
    local target="me/$KMOM/$exercise"

    headerForTest "-- $exercise$info" "-- ${DBW_WWW}$url"
    checkKmomDir "$target"
    viewFileTree "$target"
    openFilesInEditor "$target"
    
    # As files
    [ -z "$file1" ] || viewFileContent "$file1" "$target"
    [ -z "$file2" ] || viewFileContent "$file2" "$target"

    # As urls
    [ -z "$file3" ] || printUrl "$file3" "$target"
    [ -z "$file4" ] || printUrl "$file4" "$target"

    # As commands
    [ -z "$file5" -a -z "$file6" ] || inspectCommand "$file5" "$THEDIR/$target" "$file6"
    [ -z "$file7" -a -z "$file8" ] || inspectCommand "$file7" "$THEDIR/$target" "$file8"
}



#
# Test a exercise
#
inspectExerciseHeader()
{
    local exercise="$1"
    local url="$2"
    local target="me/$3"

    headerForTest "-- $exercise$info" "-- ${DBW_WWW}$url"
    checkKmomDir "$target"
    viewFileTree "$target"
}



#
# Check the environment
#
dbwebbInspectTargetNotReadable()
{
    #local thedir="$( readlink -f "$REPO" )"
    local thedir="$( get_realpath "$REPO" )"
    
    if [ ! -d "$thedir" ]; then 
        
        printf "\n$MSG_FAILED Directory '$REPO' not readable.\n"

        local dirname=$( dirname "$REPO" )
        if [ ! -r "$dirname" ]; then 
            printf "\n$MSG_FAILED Directory '$dirname' not readable.\n"
        else
            printf "\nDirectory '$dirname' exists, doing an ls.\n"
            ls "$dirname"
        fi
        
        printf "\n$MSG_FAILED Perhaps login to the studserver and execute the command:\n"
        echo "sudo setpre-dbwebb-kurser.bash $THEUSER"
        echo  
    fi 
}



#
# Check the environment
#
dbwebbInspectCheckEnvironment()
{
    headerForTest "-- dbwebb inspect"
    printUrl "" "me"
    openFilesInEditor "me"
    changeToDirectory "me"
}



#
# Make own copy
#
publishKmom()
{
    [[ $COPY_DIR ]] || return
    
    rm -rf "$COPY_DIR"
    mkdir "$COPY_DIR"
    
    printf "\nPublishing a copy of %s to '%s'" "$KMOM" "$COPY_DIR"
    rsync -a --exclude 'kmom*' "$THEDIR/me/" "$COPY_DIR/"
    rsync -a "$THEDIR/me/$KMOM/" "${COPY_DIR}${KMOM}/"
    
    publishChmod "$COPY_DIR"

    printf "\nURL: %s" "$COPY_URL"
    printf "\n"

    printf "\nOpen files in an editor:"
    printf "\n$EDITOR \"%s\"" "$COPY_DIR"
    printf "\n"

    printf "\nChange to directory:"
    printf "\ncd \"%s\"" "$COPY_DIR"
    printf "\n"
}



#
# Test validate a kmom
#
validateKmom()
{
    local kmom=${1-$KMOM}

    printf "\nValidate %s [Yn]? " "$kmom"

    local answer=$( answerYesOrNo "y" )
    if [ "$answer" = "y" -o "$answer" = "Y" ]
    then
        dbwebb-validate1 --course-repo "$DBW_COURSE_DIR" "$kmom"
    fi
}



#
# Execute a command, maybe as another user
# TODO remove support for $4 $opts, its not really used, but check in python & js1 before doing it.
#
inspectCommand()
{
    local what="$1"
    local move="$2"
    local cmd="$3"
    local opts="$4"

    filename="$move/$what"

    if [ ! -z "$what" ]; then
        assert 0 "test -f \"$filename\" -o -r \"$filename\"" "The file '$what' is missing or not readable."
    fi
    
    if [ $? == 0 ]; then
        printf "\nExecute '%s' [Yn]? " "$cmd"

        local answer=$( answerYesOrNo "y" )
        if [ "$answer" = "y" -o "$answer" = "Y" ]; then

            pushd "$move" > /dev/null
            echo ">>>"
            $cmd
            status=$?
            echo "<<<"
            popd > /dev/null

            if [ $status -eq 0 ]; then
                assert 1 "test" "Command executed successfully."
                printf "\n$MSG_OK Command executed with a exit status 0  - indicating success."
                printf "\n"
            else
                assert 0 "test" "Command returned non-zero exit status which might indicate failure."
            fi
        fi
    fi
}



#
# Set default settings for running server
#
serverSettings()
{
    LINUX_PORT=${LINUX_PORT:-1342}
    export LINUX_PORT=${PORT:-$LINUX_PORT}
    export LINUX_SERVER=${LINUX_SERVER:-127.0.0.1}
}



#
# Check if port is free
#
checkPortIsFree()
{
    local program=$( netstat -lnt --program 2> /dev/null | grep $LINUX_PORT | awk '{print $7}' )

    assert 0 "test -z $program" "The port $LINUX_PORT is allocated, trying to kill it."
    [ -z $program ] || kill -9 $( echo $program | cut -d '/' -f 1 )

    program=$( netstat -lnt --program 2> /dev/null | grep $LINUX_PORT | awk '{print $7}' )

    assert 0 "test -z $program" "The port $LINUX_PORT is still allocated, you should use another port."
}



#
# Execute a command as a server in the background logging output to a file.
#
runServer()
{
    local what="$1"
    local move="$2"
    local cmd="$3"
    local opts="$4"
    local ignorePidFile="$5"
    local pid=

    local filename="$move/$what"
    
    export SERVER_LOG="/tmp/dbwebb-inspect-server-log.$DBW_USER"

    if [ ! -z "$what" ]; then
        assert 0 "test -f \"$filename\" -o -r \"$filename\"" "The file '$what' is missing or not readable."
    fi
    
    if [ $? == 0 ]; then
        serverSettings
        checkPortIsFree

        printf "\nExecute '%s' as server on $LINUX_SERVER:$LINUX_PORT [Yn]? " "$cmd"

        local answer=$( answerYesOrNo "y" )
        if [ "$answer" = "y" -o "$answer" = "Y" ]; then

            pushd "$move" > /dev/null
            
            echo ">>>"

            [[ -f pid ]] && rm pid
            $cmd &> $SERVER_LOG &
            status=$?
            SERVER_PID=$!
            echo "$cmd started with pid '$SERVER_PID' and status $status (sleeping 3 before continue)..."
            sleep 3
            echo "(Will kill server automatically within 60 seconds.)"

            if [[ ! $ignorePidFile ]]; then
                assert 0 "test -f pid" "The pid-file is missing."
                pid=$( [[ -f pid ]] && cat pid )
                echo "File pid contains: '$pid'"
            fi

            sleep 60 && kill $SERVER_PID $id &> /dev/null &
            echo "<<<"

            popd > /dev/null

            if [ $status -eq 0 ]; then
                assert 1 "test" "Command executed successfully."
                printf "\n$MSG_OK Command executed with a exit status 0  - indicating success."
                printf "\n"
            else
                assert 0 "test" "Command returned non-zero exit status which might indicate failure."
            fi
        fi
    fi
}



#
# Kill the server started with startServer and output its logfile.
#
killServer()
{
    local move="$1"
    local ignorePidFile="$2"
    local PID="$SERVER_PID"

    pushd "$move" > /dev/null

    echo
    echo ">>>"

    if [[ ! $ignorePidFile ]]; then
        PID=$( cat pid )
        assert 0 "test -f pid" "The pid-file is missing."
        echo "Killing server with PID $PID ($SERVER_PID) (sleeping 3 before continue)..."
        kill $PID $SERVER_PID &> /dev/null
    else
        echo "Killing server with PID $PID (sleeping 3 before continue)..."
        kill $SERVER_PID &> /dev/null # To be sure then file pid is missing
    fi;

    sleep 3

    echo "Printing logfile from server:"
    echo "--------- Logfile start  ---------"
    cat "$SERVER_LOG"
    rm -f "$SERVER_LOG"
    echo "--------- Logfile end    ---------"
    echo "<<<"
    popd > /dev/null    
}



#
# Process options
#
while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        --selfupdate)
            selfupdate dbwebb-inspect
            exit 0
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

        --archive)
            if [ ! -d "$2" ]; then
                badUsage "Path to --archive '$2' is not a directory."
                exit 2                
            fi
            ARCHIVE="$2"
            shift
            shift
        ;;

        --config)
            if [ ! -f "$2" ]; then
                badUsage "Path to --config '$2' is not a file."
                exit 2                
            fi
            DBW_INSPECT_CONFIGFILE="$2"
            shift
            shift
        ;;

        --publish-to)
            if [ ! -d "$2" ]; then
                badUsage "Path to --publish-to '$2' is not a directory."
                exit 2                
            fi
            COPY_DIR="$2/inspect/"
            shift
            shift
        ;;
        
        --publish-url)
            COPY_URL="$2/inspect/"
            shift
            shift
        ;;

        --base-url)
            BASE_URL="$2"
            shift
            shift
        ;;

        *) 
            break
        ;;
        
    esac
done



#
# Get path to dir to check
#
REPO="$1"
KMOM="$2"



#
# Check incoming arguments
#
if [ -z "$REPO" ]; then
    badUsage "Missing course repo."
    exit 2
elif [ -z "$KMOM" ]; then
    badUsage "Missing kmom."
    exit 2    
fi

#THEDIR=$( readlink -f "$REPO" )
THEDIR=$( get_realpath "$REPO" )
if [ ! -d "$THEDIR" ]; then
    dbwebbInspectTargetNotReadable
    #badUsage "The path '$REPO' is not a valid directory."
    exit 2
fi

DBW_COURSE_DIR="$THEDIR"
sourceCourseRepoFile



#
# Source validate config file
#
[[ $DBW_INSPECT_CONFIGFILE ]] && . "$DBW_INSPECT_CONFIGFILE"



#
# Guess the user as owner of the repo
#
THEUSER=$( ls -ld "$REPO" | awk '{print $3}' )



#
# Guess BASE_URL if not available
#
DBW_WWW_HOST=${DBW_WWW_HOST:=http://www.student.bth.se/}
DBW_REMOTE_BASEDIR=${DBW_REMOTE_BASEDIR:=dbwebb-kurser}
if [[ ! $BASE_URL ]]; then
    BASE_URL="$DBW_WWW_HOST~$THEUSER/$DBW_REMOTE_BASEDIR"    
fi

# Guess COPY_URL if not available
if [[ ! $COPY_URL ]]; then
    COPY_URL="$DBW_WWW_HOST~$USER/$DBW_REMOTE_BASEDIR/inspect/"    
fi

# Check if ARCHIVE should be used
if [[ $ARCHIVE ]]; then
    echo -n "Archiving, please wait..."
    
    if [ ! -d "$ARCHIVE/$THEUSER/$DBW_COURSE" ]; then
        echo -n "creating '$ARCHIVE/$THEUSER/$DBW_COURSE'..."
        install --mode=770 --directory "$ARCHIVE/$THEUSER/$DBW_COURSE"
    fi
    
    rsync -a --no-perms --exclude vendor --delete "$THEDIR/me/" "$ARCHIVE/$THEUSER/$DBW_COURSE/"
    find "$ARCHIVE/$THEUSER/$DBW_COURSE/" -user $USER -exec chmod g+w {} \;   
    echo "done."
fi



#
# Decide on target dir for execution
#
if [[ $COPY_DIR ]]; then
    EXEC_DIR="$COPY_DIR"
else
    EXEC_DIR="$THEDIR/me/"
fi



#
# Use local inspect file if available
# perhaps check its md5 to ensure its not modified?
#
local inspectVersion="Built-in"
if [ -f "$DBW_COURSE_DIR/.dbwebb/inspect" ]; then
    . "$DBW_COURSE_DIR/.dbwebb/inspect"
    inspectVersion="Course repo"
fi



#
# Do inspect
#
echo "#"
echo "# $( date )"
echo "# $( dbwebb-inspect --version )"
echo "#"
echo "# Repo:     $DBW_COURSE_DIR"
echo "# Course:   $DBW_COURSE"
echo "# Kmom:     $KMOM"
echo "# Student:  $THEUSER"
echo "# By:       $USER"
echo "# Source:   $inspectVersion"
echo "# Archived: $( [[ $ARCHIVE ]] && echo "yes" || echo "no" )"
echo "#"
dbwebbInspectCheckEnvironment



#
# Execute command
#
case "$KMOM" in
    kmom01)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom02)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom03)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom04)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom05)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom06)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    kmom10)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}"; "${DBW_COURSE}last";;
    *)          
        badUsage "\n$MSG_FAILED Invalid combination of course '$DBW_COURSE' and kmom: '$KMOM'"
        exit 1 
        ;;
esac


#
# Clean up and output results
#
headerForTest "-- dbwebb inspect summary"

if [ $FAULTS -gt 0 ]; then
        printf "\n\n$MSG_FAILED"
        STATUS=1
else 
        printf "\n\n$MSG_OK"
        STATUS=0
fi

printf " Asserts: $ASSERTS Faults: $FAULTS\n"
#pressEnterToContinue
#[[ $COPY_DIR ]] && rm -rf "$COPY_DIR"
exit $STATUS
