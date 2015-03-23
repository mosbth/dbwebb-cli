# --------------- DBWEBB-VALIDATE MAIN START HERE ---------------
#
# External tools
#
HTMLHINT="dbwebb-htmlhint"

CSSLINT="csslint"
CSSLINT_OPTIONS="--quiet"

JSHINT="jshint"

JSCS="jscs"
JSCS_OPTIONS="--verbose"

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



#
# Set default configurations
#
function setDefaultConfigFiles()
{
    if [[ $DBW_COURSE_DIR ]]; then
        HTML_MINIFIER_CONFIG="--config-file '$DBW_COURSE_DIR/.html-minifier.conf'"
        PYLINT_CONFIG="--rcfile '$DBW_COURSE_DIR/.pylintrc'"
        PHPMD_CONFIG="'$DBW_COURSE_DIR/.phpmd.xml'"
        PHPCS_CONFIG="--standard='$DBW_COURSE_DIR/.phpcs.xml'"
        
        if [ -f "$DBW_COURSE_DIR/.csslintrc" ]; then
            CSSLINT_CONFIG="$DBW_COURSE_DIR/.csslintrc"
        else
            CSSLINT_CONFIG="/dev/null"
        fi
        
        JSCS_CONFIG="--config=$DBW_COURSE_DIR/.jscsrc"
    else
        PHPMD_CONFIG="cleancode,codesize,controversial,design,naming,unusedcode"
    fi    
}



#
# Check for installed tools
#
function checkInstalledValidateTools
{
    printf "Check for installed validation tools.\n"
    printf " htmlhint:      %s\n" "$( checkCommand $HTMLHINT )"
    printf " csslint:       %s\n" "$( checkCommand $CSSLINT )"
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
    printf " phpminify:     %s\n" "$( checkCommand $PHPMINIFY )"
    printf " phpuglify:     %s\n" "$( checkCommand $PHPUGLIFY )"
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

    [[ $DISABLE_HTMLHINT ]]  || validateCommand "$dir" "$HTMLHINT" "html" 
    [[ $DISABLE_CSSLINT ]]   || validateCommand "$dir" "$CSSLINT" "css" "$CSSLINT_OPTIONS $( cat "$CSSLINT_CONFIG" )"
    [[ $DISABLE_JSHINT ]]    || validateCommand "$dir" "$JSHINT" "js"
    [[ $DISABLE_JSCS ]]      || validateCommand "$dir" "$JSCS" "js" "$JSCS_OPTIONS $JSCS_CONFIG" "| grep -v 'No code style errors found.'; exit ${PIPESTATUS[0]}"
    #validateCommand "$dir" "$JSCS" "js" "$JSCS_OPTIONS $JSCS_CONFIG" ""
    [[ $DISABLE_PYLINT ]]    || validateCommand "$dir" "$PYLINT" "py" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
    [[ $DISABLE_PYLINT ]]    || validateCommand "$dir" "$PYLINT" "cgi" "$PYLINT_OPTIONS $PYLINT_CONFIG" 
    [[ $DISABLE_PHP ]]       || validateCommand "$dir" "$PHP" "php" "$PHP_OPTIONS" "> /dev/null"
    [[ $DISABLE_PHPMD ]]     || validateCommand "$dir" "$PHPMD" "php" "" "$PHPMD_OPTIONS $PHPMD_CONFIG"
    [[ $DISABLE_PHPCS ]]     || validateCommand "$dir" "$PHPCS" "php" "$PHPCS_OPTIONS $PHPCS_CONFIG"
    [[ $DISABLE_CHECKBASH ]] || validateCommand "$dir" "$CHECKBASH" "bash" "$CHECKBASH_OPTIONS" 
    [[ $DISABLE_CHECKSH ]]   || validateCommand "$dir" "$CHECKSH" "sh" "$CHECKSH_OPTIONS"
    [[ $DISABLE_YAML ]]      || validateCommand "$dir" "$YAML" "yml" "$YAML_OPTIONS" "> /dev/null"
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
        for filename in $( find "$dir/" -type f -name \*.$extension ); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmd $options $filename $output $filename"
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
    
    [[ $DISABLE_HTML_MINIFIER ]] || publishCommand "$to" "$HTML_MINIFIER" "html" "$HTML_MINIFIER_CONFIG $HTML_MINIFIER_OPTIONS" "--output" 
    [[ $DISABLE_CLEANCSS ]]      || publishCommand "$to" "$CLEANCSS" "css" "$CLEANCSS_OPTIONS" "-o" 
    [[ $DISABLE_UGLIFYJS ]]      || publishCommand "$to" "$UGLIFYJS" "js" "$UGLIFYJS_OPTIONS" "-o"
    [[ $DISABLE_PHPMINIFY ]]     || publishCommand "$to" "$PHPMINIFY" "php" "$PHPMINIFY_OPTIONS" "> /tmp/$$; mv /tmp/$$ "
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

        --course-repo)
            DBW_COURSE_DIR="$2"
            if [ ! -d "$DBW_COURSE_DIR" ]; then
                badUsage "$MSG_FAILED --course-repo '$DBW_COURSE_DIR' is not a valid directory."
                exit 2
            fi

            # Get the name of the course as $DBW_COURSE
            sourceCourseRepoFile
                
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
            selfupdate dbwebb-validate
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



#
# Source validate config file
#
[[ $DBW_VALIDATE_CONFIGFILE ]] && . "$DBW_VALIDATE_CONFIGFILE"



printf "Validating '%s'." "$dir"
setDefaultConfigFiles
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
