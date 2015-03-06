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
PHPMD="phpmd"
PHPCS="phpcs"
PHPUGLIFY=""

CHECKBASH="shellcheck"
CHECKBASH_OPTIONS="--shell=bash"

CHECKSH="shellcheck"
CHECKSH_OPTIONS="--shell=sh"

if [[ $DBW_COURSE_DIR ]]; then
    HTML_MINIFIER_CONFIG="--config-file '$DBW_COURSE_DIR/.html-minifier.conf'"
    PYLINT_CONFIG="--rcfile $DBW_COURSE_DIR/.pylintrc"
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

    printf "Check for installed publishing tools.\n"
    printf " html-minifier: %s\n" "$( checkCommand $HTML_MINIFIER )"
    printf " cleancss:      %s\n" "$( checkCommand $CLEANCSS )"
    printf " uglifyjs:      %s\n" "$( checkCommand $UGLIFYJS )"
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
# Perform validation tests
#
function validateCommand()
{
    local dir="$1"
    local cmd="$2"
    local extension="$3"
    local options="$4"

    if hash "$cmd" 2>/dev/null; then
        printf "\n *.$extension using $cmd."
        
        for filename in $(find "$dir/" -type f -name \*.$extension); do
            assert 0 "$cmd $options $filename" "$cmd failed: $filename"
        done
    else
        printf "\n *.$extension (skipping - $cmd not installed)."
    fi
}



#
# Perform validation tests
#
function validateHtmlCssJs()
{
    local dir="$1"

    validateCommand "$dir" "$HTMLHINT" "html" 
    validateCommand "$dir" "$CSSHINT" "css"
    validateCommand "$dir" "$JSHINT" "js"
    validateCommand "$dir" "$JSCS" "js"
}



#
# Perform validation tests
#
function validatePHP()
{
    local dir="$1"

    validateCommand "$dir" "$PHP" "php" 
    validateCommand "$dir" "$PHPMD" "php" 
    validateCommand "$dir" "$PHPCS" "php" 
}



#
# Perform validation tests
#
function validateShell()
{
    local dir="$1"

    validateCommand "$dir" "$CHECKBASH" "bash" "$CHECKBASH_OPTIONS" 
    validateCommand "$dir" "$CHECKSH" "sh" "$CHECKSH_OPTIONS"
}



#
# Perform validation tests
#
function validatePython()
{
    local dir="$1"

    validateCommand "$dir" "$PYLINT" "py" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
    validateCommand "$dir" "$PYLINT" "cgi" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
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


# ----------------------------------------- TO BE VALIDATED --------------------


#
# Publish all
#
publish()
{
    local from="$1"
    local to="$2"
 
    if [ ! -d "$from" ]; then
        printf "$MSG_FAILED Publish without valid from directory: '$from'\n"
        exit 2
    elif [ -z "$to" ]; then
        printf "$MSG_FAILED Publish with empty target directory: '$to'\n"
        exit 2
    fi
 
    printf "rsync -a --delete %s %s" "$from/" "$to/"
    return
    
    printf " minify *.html"
    for filename in $(find "$to/" -type f -name '*.html'); do
        assert 0 "$HTML_MINIFIER $HTML_MINIFIER_OPTIONS $filename --output $filename" "HTMLMinifier failed: $filename"
    done

    printf ", minify *.css"
    for filename in $(find "$to/" -type f -name '*.css'); do
        assert 0 "$CLEANCSS $filename -o $filename" "CleanCSS failed: $filename"
    done

    printf ", uglify *.js"
    for filename in $(find "$to/" -type f -name '*.js'); do
        assert 0 "$UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS" "UglifyJS failed: $filename"
    done
    
    printf ", uglify *.php"
    for filename in $(find "$to/" -type f -name '*.js'); do
        printf ""
        #assert 0 "$UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS" "UglifyJS failed: $filename"
    done
    
    printf ", chmod"
    publishChmod "$dir/"
    printf ". Done"
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

printf "Validating directory '%s'." "$dir"
validateHtmlCssJs "$dir" 
validatePython "$dir"
validateShell "$dir"
validatePHP "$dir"

if [[ $optPublish ]]; then
    if [ -z "$DBW_PUBLISH_BASEDIR" ]; then
        printf "\n$MSG_FAILED Missing basedir for publish, not supported.\n"
        exit 2
    fi
    
    if [ ! -d "$DBW_PUBLISH_BASEDIR" ]; then
        printf "\n$MSG_FAILED Basedir for publish is not a valid directory '%s'.\n" "$DBW_PUBLISH_BASEDIR"
        exit 2
    fi
    
    if [ -f "$DBW_COURSE_FILE" ]; then
        printf "\nTake subdir with coursedir.\n"
        printf $( dirname "$DBW_COURSE_DIR" )        
        printf "\n"
        a=$( dirname "$DBW_COURSE_DIR" )
        b=$( dirname "$DBW_COURSE_DIR" )
        target=${a#dir}
        printf "\n$target\n"
        target="$DBW_PUBLISH_BASEDIR"
    else
        target="$DBW_PUBLISH_BASEDIR/$( basename "$dir" )"
    fi
    
    # printf "\nPublishing to '%s'.\n" "$target"
    publish "$dir" "$target"
fi

assertResults


# TODO Validate for another user?
#THETARGET="$TARGET"
#if [ ! -z "$THEUSER" ]
#then
#    THETARGET=`eval echo "~$THEUSER/dbwebb-kurser/$COURSE"`
#fi
