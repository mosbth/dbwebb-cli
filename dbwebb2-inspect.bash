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

    printf "$WRAP_HEADER"
    printf "\n$what"
    if [ ! -z "$task" ]; then
        printf "\n$task"
    fi
    printf "$WRAP_FOOTER"
}


#
# Open viles in editor
#
openFilesInEditor()
{
    printf "\nOpen files in an editor:"
    printf "\n$EDITOR \"%s/%s\"" "$THEDIR" "$1"
    printf "\n"
}


#
# Change to directory
#
changeToDirectory()
{
    printf "\nChange to directory:"
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
    local url="${DBW_WWW_HOST}~${THEUSER}/$DBW_REMOTE_BASEDIR/$DBW_COURSE"
    
    printf "\nURL: $url/$where/$what"

    if [ -z "$what" ]; then
        assert 0 "test -d \"$THEDIR/$where\"" "The directory '$where' is missing or not readable."
    else
        assert 0 "test -f \"$THEDIR/$where/$what\"" "The file '$what' is missing or not readable."
    fi

    printf "\n"
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
# Check the environment
#
dbwebbInspectCheckEnvironment()
{
    headerForTest "-- dbwebb inspect"

    # Check who you are
    if [ "$USER" = "$THEUSER" ]
    then
        printf "\nChecking your own $DBW_COURSE/$KMOM, ok."
    else
        printf "\nChecking $DBW_COURSE/$KMOM for $THEUSER as $( whoami ) at `hostname`."
    fi

    printf "\n"

    if [ ! -d "$THEDIR" ]; then 
        
        printf "\n$MSG_FAILED Directory '$THEDIR' not readable.\n"

        local dirname=$( dirname "$THEDIR" )
        if [ ! -r "$dirname" ]; then 
            printf "\n$MSG_FAILED Directory '$dirname' not readable.\n"
        else
            printf "\nDirectory '$dirname' exists, doing an ls.\n"
            ls "$dirname"
        fi
        
        printf "\nPerhaps login to the studserver and execute the command:\nsudo setpre-dbwebb-kurser.bash $THEUSER"        

        printf "\n\nPress CTRL-C and fix it."
        read answer
    fi 

    printUrl "" "me"
    openFilesInEditor "me"
    changeToDirectory "me"
}



#
# Make own copy
#
publishKmom()
{
    if [ ! -d "$COPY_DIR" ]; then
        mkdir "$COPY_DIR"
    fi
    
    printf "\nPublishing a copy of %s to '%s'" "$KMOM" "$COPY_DIR"
    rm -rf "$COPY_DIR/*"
    rsync -a --delete "$THEDIR/me/$KMOM/" "${COPY_DIR}${KMOM}/"
    if [ -d "$THEDIR/me/redovisa/" ]; then
        rsync -a --delete "$THEDIR/me/redovisa/" "${COPY_DIR}/redovisa/"
    fi
    find "$COPY_DIR" -type f -name '*.cgi' -exec chmod a+x {} \;

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
    printf "\nValidate %s [Yn]? " "$KMOM"

    read answer
    default="y"
    answer=${answer:-$default}

    if [ "$answer" = "y" -o "$answer" = "Y" ]
    then
        dbwebb-validate --course-repo "$DBW_COURSE_DIR" "$KMOM"
        pressEnterToContinue
    fi
}



#
# Execute a command, maybe as another user
#
inspectCommand()
{
    local what="$1"
    local move="$2"
    local cmd="$3"
    local opts="$4"

    filename="$move/$what"

    if [ -f "$filename" -o -r "$filename" ]; then
        printf "\nExecute: $what $opts [Yn]? "
        read answer
        default="y"
        answer=${answer:-$default}

        if [ "$answer" = "y" -o "$answer" = "Y" ]; then

            pushd "$move" > /dev/null
            $cmd            
            status=$?
            popd > /dev/null

            if [ $status -eq 0 ]; then
                assert 1 "test" "Command executed successfully."
                printf "\n$MSG_OK Command executed with a exit status 0  - indicating success."
                printf "\n"
            else
                assert 0 "test" "Command returned non-zero exit status which might indicate failure."
            fi
        fi
    else
        assert 0 "test" "The file $what is missing or not readable."
    fi
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
THEUSER="$3"
THETARGET="me/$KMOM"

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

#
# If omitting the user, expect a valid path, else use relative from its user.
#
if [ -z "$THEUSER" ]; then
    THEDIR=$( eval echo "$REPO" )
    THEUSER=$USER
else
    THEDIR=$( eval echo "~$THEUSER/$REPO" )
fi

if [ ! -d "$THEDIR" ]; then
    badUsage "The path '$THEDIR' is not a valid directory."
    exit 2
fi

DBW_COURSE_DIR="$THEDIR"
sourceCourseRepoFile

COPY_DIR="$HOME/$DBW_REMOTE_WWWDIR/inspect/"
COPY_URL="${DBW_WWW_HOST}~${USER}$DBW_REMOTE_BASEDIR/inspect/"

printf "#"
printf "\n# %s" "$( date )"
printf "\n# %s" "$( dbwebb-inspect --version )"
printf "\n#"
printf "\n# Course:  %s" "$DBW_COURSE"
printf "\n# Kmom:    %s" "$KMOM"
printf "\n# Student: %s" "$THEUSER"
printf "\n# By:      %s" "$USER"
printf "\n#"
dbwebbInspectCheckEnvironment


#
# Execute command
#
case "$KMOM" in
    kmom01)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom02)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom03)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom04)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom05)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom06)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
    kmom10)     ${DBW_COURSE}; "${DBW_COURSE}${KMOM}" ;;
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
pressEnterToContinue
rm -rf "$COPY_DIR/*"
exit $STATUS
