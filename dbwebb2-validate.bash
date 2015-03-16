# --------------- DBWEBB-VALIDATE MAIN START HERE ---------------
#
# External tools
#
HTMLHINT="dbwebb-htmlhint"
CSSHINT="csslint"
JSHINT="jshint"
JSCS="jscs"

HTML_MINIFIER="html-minifier"

CLEANCSS="cleancss"
CLEANCSS_OPTIONS="--s1 --skip-import"

UGLIFYJS="uglifyjs"
UGLIFYJS_OPTIONS="--mangle --compress --screw-ie8 --comments"

PYLINT="pylint"
PYLINT_OPTIONS="-r n"

PHP="php"
PHP_OPTIONS="--syntax-check"

PHPMD="phpmd"
PHPMD_OPTIONS="text"

PHPCS="phpcs"
PHPCS_OPTIONS=""

PHPUGLIFY=""

PHPMINIFY="php"
PHPMINIFY_OPTIONS="--strip"

CHECKBASH="shellcheck"
CHECKBASH_OPTIONS="--shell=bash"

CHECKSH="shellcheck"
CHECKSH_OPTIONS="--shell=sh"

#YAML="dbwebb-js-yaml"
#YAML_OPTIONS="--silent"
YAML="js-yaml"
YAML_OPTIONS=""

if [[ $DBW_COURSE_DIR ]]; then
    HTML_MINIFIER_CONFIG="--config-file '$DBW_COURSE_DIR/.html-minifier.conf'"
    PYLINT_CONFIG="--rcfile '$DBW_COURSE_DIR/.pylintrc'"
    PHPMD_CONFIG="'$DBW_COURSE_DIR/.phpmd.xml'"
    PHPCS_CONFIG="--standard='$DBW_COURSE_DIR/.phpcs.xml'"
else
    PHPMD_CONFIG="cleancode,codesize,controversial,design,naming,unusedcode"
fi



#
# Check for installed tools
#
function checkInstalledValidateTools
{
    printf "Check for installed validation tools.\n"
    printf " htmlhint:      %s\n" "$( checkCommand $HTMLHINT )"
    printf " csshint:       %s\n" "$( checkCommand $CSSHINT )"
    printf " jshint:        %s\n" "$( checkCommand $JSHINT )"
    printf " jscs:          %s\n" "$( checkCommand $JSCS )"
    printf " pylint:        %s\n" "$( checkCommand $PYLINT )"
    printf " php:           %s\n" "$( checkCommand $PHP )"
    printf " phpmd:         %s\n" "$( checkCommand $PHPMD )"
    printf " phpcs:         %s\n" "$( checkCommand $PHPCS )"
    printf " bash:          %s\n" "$( checkCommand $CHECKBASH )"
    printf " sh:            %s\n" "$( checkCommand $CHECKSH )"
    printf " yaml:          %s\n" "$( checkCommand $YAML )"

    printf "Check for installed publishing tools.\n"
    printf " html-minifier: %s\n" "$( checkCommand $HTML_MINIFIER )"
    printf " cleancss:      %s\n" "$( checkCommand $CLEANCSS )"
    printf " uglifyjs:      %s\n" "$( checkCommand $UGLIFYJS )"
    printf " phpuglify:     %s\n" "$( checkCommand $PHPMINIFY )"
    printf " phpuglify:     %s\n" "$( checkCommand $PHPUGLIFY )"
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

    sh -c "$TEST" > "$TMPFILE" 2>&1
    STATUS=$?
    ERROR=$(cat $TMPFILE)

    if [ \( ! $STATUS -eq $EXPECTED \) -o \( ! -z "$ERROR" \) ]; then
        FAULTS=$(( $FAULTS + 1 ))

        printf "\n\n$MSG_WARNING $MESSAGE\n" 
        [ -z "$ERROR" ] || printf "$ERROR\n\n"
    fi

    return $STATUS
}



#
# Clean up and output results from asserts
#
function assertResults()
{
    rm -f "$TMPFILE"
    
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



#
# Set correct mode on published file and dirs
#
publishChmod()
{
    local dir="$1"

    if [ -d "$dir" ]; then
        find "$dir" -type d -exec chmod a+rx {} \;  
        find "$dir" -type f -exec chmod a+r {} \;   
        find "$dir" -type f -name '*.py' -exec chmod go-r {} \;
    fi
}


#
# Selfupdate
#
selfupdate()
{
    local INTRO="Selfupdating dbwebb-validate-cli from https://github.com/mosbth/dbwebb-cli."
    local COMMAND="wget https://raw.githubusercontent.com/mosbth/dbwebb-cli/master/dbwebb2-validate -O /tmp/$$; install /tmp/$$ /usr/local/bin/dbwebb-validate; rm /tmp/$$"
    local MESSAGE="to update dbwebb-validate installation."
    executeCommand "$INTRO" "$COMMAND" "$MESSAGE"
        
    printf "Current version is: "
    dbwebb-validate --version
}



#
# Perform validation tests
#
function validateCommand()
{
    local dir="$1"
    local cmd="$2"
    local extension="$3"
    local options="$4"
    local output="$5"
    local counter=0

    if hash "$cmd" 2>/dev/null; then
        printf "\n *.$extension using $cmd"
        for filename in $(find "$dir/" -type f -name \*.$extension); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmd $options $filename $output"
            else
                if [ -z $optOnly  ]; then
                    assert 0 "$cmd $options $filename $output" "$cmd failed: $filename"
                elif [ "$extension" == "$optOnly" ]; then
                    assert 0 "$cmd $options $filename $output" "$cmd failed: $filename"
                fi
            fi
            counter=$(( counter + 1 )) 
        done
        printf " ($counter)"
    else
        printf "\n *.$extension (skipping - $cmd not installed)"
    fi
}



#
# Perform validation tests
#
function validate()
{
    local dir="$1"

    validateCommand "$dir" "$HTMLHINT" "html" 
    validateCommand "$dir" "$CSSHINT" "css"
    validateCommand "$dir" "$JSHINT" "js"
    validateCommand "$dir" "$JSCS" "js"
    validateCommand "$dir" "$PYLINT" "py" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
    validateCommand "$dir" "$PYLINT" "cgi" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
    validateCommand "$dir" "$PHP" "php" "$PHP_OPTIONS" "> /dev/null"
    validateCommand "$dir" "$PHPMD" "php" "" "$PHPMD_OPTIONS $PHPMD_CONFIG"
    validateCommand "$dir" "$PHPCS" "php" "$PHPCS_OPTIONS $PHPCS_CONFIG"
    validateCommand "$dir" "$CHECKBASH" "bash" "$CHECKBASH_OPTIONS" 
    validateCommand "$dir" "$CHECKSH" "sh" "$CHECKSH_OPTIONS"
    validateCommand "$dir" "$YAML" "yml" "$YAML_OPTIONS" "> /dev/null"
}



#
# Perform publish 
#
function publishCommand()
{
    local dir="$1"
    local cmd="$2"
    local extension="$3"
    local options="$4"
    local output="$5"
    local counter=0

    if hash "$cmd" 2>/dev/null; then
        printf "\n *.$extension using $cmd"
        for filename in $(find "$dir/" -type f -name \*.$extension); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmd $options $filename"
            else
                assert 0 "$cmd $options $filename $output $filename" "$cmd failed: $filename"
            fi
            counter=$(( counter + 1 )) 
        done
        printf " ($counter)"
    else
        printf "\n *.$extension (skipping - $cmd not installed)"
    fi
}



#
# Publish all
#
publish()
{
    local from="$1"
    local to="$2"
 
    cd "$HOME"

    if [ -z "$from" ]; then
        printf "\n$MSG_FAILED Publish with empty source directory: '$from'\n"
        exit 2
    elif [ ! -d "$from" ]; then
        printf "\n$MSG_FAILED Publish without valid from directory: '$from'\n"
        exit 2
    elif [ -z "$to" ]; then
        printf "\n$MSG_FAILED Publish with empty target directory: '$to'\n"
        exit 2
    elif [ ! -d $( dirname "$to" ) ]; then
        printf "\n$MSG_FAILED Publish to nonexisting directory: '$to'\n"
        exit 2
    fi
 
    if [[ $optDryRun ]]; then
        printf "\nrsync -a --delete %s %s" "$from/" "$to/"
    else
        rsync -a --delete "$from/" "$to/"
    fi
    
    publishCommand "$to" "$HTML_MINIFIER" "html" "$HTML_MINIFIER_OPTIONS" "--output" 
    publishCommand "$to" "$CLEANCSS" "css" "" "-o" 
    publishCommand "$to" "$UGLIFYJS" "js" "$UGLIFYJS_OPTIONS" "-o" 
    publishCommand "$to" "$MINIFYPHP" "php" "$MINIFYPHP_OPTIONS" ">" 
    #publishCommand "$to" "$UGLIFYPHP" "php" "" "--output" 

    publishChmod "$to"
}



#
# Process options
#
while (( $# ))
do
    case "$1" in
        
        --check | -c)
            checkInstalledValidateTools
            exit 0
            ;;

        --publish | -p)
            optPublish="yes"
            shift
            ;;

        --publish-to)
            DBW_PUBLISH_TO="$2"
            if [ ! -d $( dirname "$DBW_PUBLISH_TO" ) ]; then
                badUsage "$MSG_FAILED --publish-to '$DBW_PUBLISH_TO' is not a valid directory."
                exit 2
            fi
                
            shift
            shift
            ;;

        --only)
            optOnly="$2"
            shift
            shift
            ;;

        --dry | -d)
            optDryRun="yes"
            shift
            ;;

        --help | -h)
            usage
            exit 0
        ;;
        
        --version | -v)
            version
            exit 0
        ;;
                
        --selfupdate)
            selfupdate
            exit 0
        ;;
                
        *)
            if [[ $command ]]; then
                badUsage "$MSG_FAILED Too many options/items and/or option not recognized."
                exit 2
            else
                command=$1
            fi
            shift
        ;;
        
    esac
done



#
# Validate (and publish) the path choosen
#
dir="$( getPathToDirectoryFor "$command" )"
if [ ! -d "$dir" ]; then
    badUsage "$MSG_FAILED Directory '$command' is not a valid directory."
    exit 2
fi

if [ -f "$HOME/.dbwebb-validate.config" ]; then . "$HOME/.dbwebb-validate.config"; fi
if [ -f "$DBWEBB_VALIDATE_CONFIG" ]; then . "$DBWEBB_VALIDATE_CONFIG"; fi

printf "Validating '%s'." "$dir"
validate "$dir" 

if [[ $optPublish ]]; then
    if [ -z "$DBW_PUBLISH_TO" ]; then
        printf "\n$MSG_FAILED Missing target dir for publish, not supported.\n"
        exit 2
    fi
    
    if [ ! -d $( dirname "$DBW_PUBLISH_TO" ) ]; then
        printf "\n$MSG_FAILED Target dir for publish is not a valid directory '%s'.\n" "$DBW_PUBLISH_TO"
        exit 2
    fi
    
#    if [ -f "$DBW_COURSE_FILE" ]; then
#        printf "\nTake subdir with coursedir.\n"
#        printf $( dirname "$DBW_COURSE_DIR" )        
#        printf "\n"
#        a=$( dirname "$DBW_COURSE_DIR" )
#        b=$( dirname "$DBW_COURSE_DIR" )
#        target=${a#dir}
#        printf "\n$target\n"
#        target="$DBW_REMOTE_WWWDIR"
#    else
#        target="$DBW_REMOTE_WWWDIR/$( basename "$dir" )"
#    fi
    
    printf "\nPublishing to '%s'." "$DBW_PUBLISH_TO"
    publish "$dir" "$DBW_PUBLISH_TO"
fi

assertResults


# TODO Validate for another user?
#THETARGET="$TARGET"
#if [ ! -z "$THEUSER" ]
#then
#    THETARGET=`eval echo "~$THEUSER/dbwebb-kurser/$COURSE"`
#fi
