# --------------- DBWEBB-VALIDATE MAIN START HERE ---------------
#
# External tools
#
#HTMLHINT="dbwebb-htmlhint"
HTMLHINT="htmlhint"
HTMLHINT_OPTIONS=
HTMLHINT_CONFIG=

CSSLINT="csslint"
CSSLINT_OPTIONS="--quiet"

JSHINT="jshint"

JSCS="jscs"
JSCS_OPTIONS="--verbose"

JSONLINT="jsonlint"
JSONLINT_OPTIONS="--quiet"

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

FILE_CRLF="file"
FILE_CRLF_OPTIONS=""

FILE_BOM="file"
FILE_BOM_OPTIONS=""

PHPUGLIFY=""

PHPMINIFY="php"
PHPMINIFY_OPTIONS="--strip"

CHECKBASH="shellcheck"
CHECKBASH_OPTIONS="--shell=bash --exclude=SC2002"

CHECKSH="shellcheck"
CHECKSH_OPTIONS="--shell=sh --exclude=SC2002"

#YAML="dbwebb-js-yaml"
#YAML_OPTIONS="--silent"
YAML="js-yaml"
YAML_OPTIONS=""

# Exclude these paths/filenames from tools processing
#EXCLUDE_PATHS='\*/webgl/\* \*/libs/\* \*/lib/\* \*/node_modules/\*'
EXCLUDE_PATHS='\*/example/webgl/\* \*/libs/\* \*/lib/\* \*/node_modules/\* \*/platforms/\* \*/plugins/\* \*/docs/api/\* \*/vendor/\* \*/3pp/\*'
EXCLUDE_FILES='phpliteadmin\* \*.min.\* \*.tpl.php'



#
# Set default configurations
#
function setDefaultConfigFiles()
{
    if [[ $DBW_COURSE_DIR ]]; then
        if [ -f "$DBW_COURSE_DIR/.htmlhintrc" ]; then
            HTMLHINT_CONFIG="--config '$DBW_COURSE_DIR/.htmlhintrc'"
        fi

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
    printf " jsonlint:      %s\n" "$( checkCommand $JSONLINT )"
    printf " pylint:        %s\n" "$( checkCommand $PYLINT )"
    printf " php:           %s\n" "$( checkCommand $PHP )"
    printf " phpmd:         %s\n" "$( checkCommand $PHPMD )"
    printf " phpcs:         %s\n" "$( checkCommand $PHPCS )"
    printf " bash:          %s\n" "$( checkCommand $CHECKBASH )"
    printf " sh:            %s\n" "$( checkCommand $CHECKSH )"
    printf " yaml:          %s\n" "$( checkCommand $YAML )"
    printf " file CRLF:     %s\n" "$( checkCommand $FILE_CRLF )"
    printf " file BOM:      %s\n" "$( checkCommand $FILE_BOM )"

    printf "Check for installed publishing tools.\n"
    printf " html-minifier: %s\n" "$( checkCommand $HTML_MINIFIER )"
    printf " cleancss:      %s\n" "$( checkCommand $CLEANCSS )"
    printf " uglifyjs:      %s\n" "$( checkCommand $UGLIFYJS )"
    printf " phpminify:     %s\n" "$( checkCommand $PHPMINIFY )"
    printf " phpuglify:     %s\n" "$( checkCommand $PHPUGLIFY )"
}



#
# Create a find expression for validate and publish
#
function getFindExpression
{
    local ignorePaths
    local ignoreFiles
    local findExpression
    local ignoreExtension="$1"

    ignorePaths=$( printf " -not -path %s " $( echo $EXCLUDE_PATHS ) )
    ignoreFiles=$( printf " -not -name %s " $( echo $EXCLUDE_FILES ) )

    if [ -z "$ignoreExtension" ]; then
        findExpression=$( echo "find \"$dir/\" -type f -name \*.$extension $ignorePaths $ignoreFiles" )
    else
        findExpression=$( echo "find \"$dir/\" $ignorePaths $ignoreFiles" )
    fi
    
    echo $findExpression
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
    local onlyExitStatus="$6"
    local counter=0
    local findExpression=
    local ignoreExtension="$7"

    if hash "$cmd" 2>/dev/null; then
        printf "\n *.$extension using $cmd"

        findExpression=$( getFindExpression $ignoreExtension )

        [[ $optDryRun ]] && echo "$findExpression"

        OIFS="$IFS"
        IFS=$'\n'

        for filename in $( eval $findExpression ); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmd $options '$filename' $output"
            else
                if [ -z $optOnly  ]; then
                    assert 0 "$cmd $options '$filename' $output" "$cmd failed: '$filename'" "$onlyExitStatus"
                elif [ "$extension" == "$optOnly" ]; then
                    assert 0 "$cmd $options '$filename' $output" "$cmd failed: '$filename'" "$onlyExitStatus"
                fi
            fi
            counter=$(( counter + 1 ))
            printf "."
        done
        
        IFS="$OIFS"

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

    [[ $ENABLE_ALL || ! $DISABLE_HTMLHINT ]]  && validateCommand "$dir" "$HTMLHINT" "html" "$HTMLHINT_OPTIONS $HTMLHINT_CONFIG" '| grep -v "No problem." | grep -v "Config loaded." | grep -v "Scan "; test ${PIPESTATUS[0]} -eq 0'
    [[ $ENABLE_ALL || ! $DISABLE_CSSLINT ]]   && validateCommand "$dir" "$CSSLINT" "css" "$CSSLINT_OPTIONS $( cat "$CSSLINT_CONFIG" )"
    [[ $ENABLE_ALL || ! $DISABLE_JSHINT ]]    && validateCommand "$dir" "$JSHINT" "js"
    [[ $ENABLE_ALL || ! $DISABLE_JSCS ]]      && validateCommand "$dir" "$JSCS" "js"  "$JSCS_OPTIONS $JSCS_CONFIG" "" "onlyExitStatus"
    [[ $ENABLE_ALL || ! $DISABLE_JSONLINT ]]  && validateCommand "$dir" "$JSONLINT" "json" "$JSONLINT_OPTIONS" "" ""
    #validateCommand "$dir" "$JSCS" "js" "$JSCS_OPTIONS $JSCS_CONFIG" ""
    [[ $ENABLE_ALL || ! $DISABLE_PYLINT ]]    && validateCommand "$dir" "$PYLINT" "py" "$PYLINT_OPTIONS $PYLINT_CONFIG"
    [[ $ENABLE_ALL || ! $DISABLE_PYLINT ]]    && validateCommand "$dir" "$PYLINT" "cgi" "$PYLINT_OPTIONS $PYLINT_CONFIG"
    [[ $ENABLE_ALL || ! $DISABLE_PHP ]]       && validateCommand "$dir" "$PHP" "php" "$PHP_OPTIONS" "> /dev/null"
    [[ $ENABLE_ALL || ! $DISABLE_PHPMD ]]     && validateCommand "$dir" "$PHPMD" "php" "" "$PHPMD_OPTIONS $PHPMD_CONFIG"
    [[ $ENABLE_ALL || ! $DISABLE_PHPCS ]]     && validateCommand "$dir" "$PHPCS" "php" "$PHPCS_OPTIONS $PHPCS_CONFIG"
    [[ $ENABLE_ALL || ! $DISABLE_CHECKBASH ]] && validateCommand "$dir" "$CHECKBASH" "bash" "$CHECKBASH_OPTIONS"
    [[ $ENABLE_ALL || ! $DISABLE_CHECKSH ]]   && validateCommand "$dir" "$CHECKSH" "sh" "$CHECKSH_OPTIONS"
    [[ $ENABLE_ALL || ! $DISABLE_YAML ]]      && validateCommand "$dir" "$YAML" "yml" "$YAML_OPTIONS" "> /dev/null"
    [[ $ENABLE_ALL || ! $DISABLE_FILE_CRLF ]] && validateCommand "$dir" "$FILE_CRLF" "" "$FILE_CRLF_OPTIONS" '| grep CRLF; test $? -eq 1' "" "allExtensions"
    [[ $ENABLE_ALL || ! $DISABLE_FILE_BOM ]]  && validateCommand "$dir" "$FILE_BOM" "" "$FILE_BOM_OPTIONS" '| grep BOM; test $? -eq 1' "" "allExtensions"
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
        
        findExpression=$( getFindExpression )

        [[ $optDryRun ]] && echo "$findExpression"

        for filename in $( eval $findExpression ); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmd $options $filename $output $filename"
            else
                assert 0 "$cmd $options $filename $output $filename" "$cmd failed: $filename"
            fi
            counter=$(( counter + 1 ))
            printf "."
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
        printf "\nrsync -a $RSYNC_CHMOD --delete %s %s" "$from/" "$to/"
    else
        rsync -a $RSYNC_CHMOD --delete "$from/" "$to/"
    fi

    if [[ ! $noMinification ]]; then
        [[ $ENABLE_ALL || ! $DISABLE_HTML_MINIFIER ]] && publishCommand "$to" "$HTML_MINIFIER" "html" "$HTML_MINIFIER_CONFIG $HTML_MINIFIER_OPTIONS" "--output"
        [[ $ENABLE_ALL || ! $DISABLE_CLEANCSS ]]      && publishCommand "$to" "$CLEANCSS" "css" "$CLEANCSS_OPTIONS" "-o"
        [[ $ENABLE_ALL || ! $DISABLE_UGLIFYJS ]]      && publishCommand "$to" "$UGLIFYJS" "js" "$UGLIFYJS_OPTIONS --output" "--"
        [[ $ENABLE_ALL || ! $DISABLE_PHPMINIFY ]]     && publishCommand "$to" "$PHPMINIFY" "php"     "$PHPMINIFY_OPTIONS" "> /tmp/$$; mv /tmp/$$ "
    fi

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

        --no-validate)
            noValidate="yes"
            shift
            ;;

        --no-minification)
            noMinification="yes"
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

        --install-npm)
            npm install -g htmlhint@0.9.12 csslint jshint jscs jsonlint js-yaml html-minifier@0.8.0 clean-css uglify-js
            exit
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
# Source validate config files
#
configFile=".dbwebb-validate.config"

[[ -f $DBW_VALIDATE_CONFIGFILE ]]    && . "$DBW_VALIDATE_CONFIGFILE"
[[ -f $HOME/$configFile ]]           && . "$HOME/$configFile"
[[ -f $DBW_COURSE_DIR/$configFile ]] && . "$DBW_COURSE_DIR/$configFile"


setDefaultConfigFiles


if [[ ! $noValidate ]]; then
    printf "Validating '%s'." "$dir"
    validate "$dir"
fi


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
