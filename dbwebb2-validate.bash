# --------------- DBWEBB-VALIDATE MAIN START HERE ---------------
#
# External tools
#
HTMLHINT="dbwebb-htmlhint"
CSSHINT="htmlhint"
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

CHECKBASH="shellcheck --shell=bash"
CHECKSH="shellcheck --shell=sh"

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
function validateHtmlCssJs()
{
    local dir="$1"

    printf "\n *.html using HTMLHint."
    for filename in $(find "$dir/" -type f -name '*.html'); do
        assert 0 "$HTMLHINT $filename" "HTMLHINT failed: $filename"
    done

    printf "\n *.css using CSSHint."
    for filename in $(find "$dir/" -type f -name '*.css'); do
        printf ""
        #assert 0 "$CSSHINT $filename" "CSSHint failed: $filename"
    done

    printf "\n *.js using JSHint."
    for filename in $(find "$dir/" -type f -name '*.js'); do
        assert 0 "$JSHINT $filename" "JSHint failed: $filename"
    done

    printf "\n *.js using JSCS."
    for filename in $(find "$dir/" -type f -name '*.js'); do
        printf ""
        #assert 0 "$JSCS $filename" "JSCS failed: $filename"
    done
}



#
# Perform validation tests
#
function validatePHP()
{
    local dir="$1"

    printf "\n *.php using PHP."
    for filename in $(find "$dir/" -type f -name '*.html'); do
        printf ""
        #assert 0 "$PHP $filename" "PHP failed: $filename"
    done

    printf "\n *.php using PHPMD."
    for filename in $(find "$dir/" -type f -name '*.css'); do
        printf ""
        #assert 0 "$PHPMD $filename" "PHPMD failed: $filename"
    done

    printf "\n *.php using PHPCS."
    for filename in $(find "$dir/" -type f -name '*.css'); do
        printf ""
        #assert 0 "$PHPCS $filename" "PHPCS failed: $filename"
    done
}



#
# Perform validation tests
#
function validateShell()
{
    local dir="$1"

    printf "\n *.bash using ShellCheck."
    for filename in $(find "$dir/" -type f -name '*.bash'); do
        printf ""
        #assert 0 "$SHELLCHECK $filename" "ShellCheck failed: $filename"
    done

    printf "\n *.sh using ShellCheck."
    for filename in $(find "$dir/" -type f -name '*.sh'); do
        printf ""
        #assert 0 "$SHELLCHECK $filename" "ShellCheck failed: $filename"
    done
}



#
# Perform validation tests
#
function validatePython()
{
    local dir="$1"

    printf "\n *.py using Pylint."
    for filename in $(find "$dir/" -type f -name '*.py'); do
        assert 0 "$PYLINT $PYLINT_OPTIONS $PYLINT_CONFIG $filename" "pylint failed: $filename"
    done

    printf "\n *.cgi using Pylint."
    for filename in $(find "$dir/" -type f -name '*.cgi'); do
        assert 0 "$PYLINT $PYLINT_OPTIONS $PYLINT_CONFIG $filename" "pylint failed: $filename"
    done
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
