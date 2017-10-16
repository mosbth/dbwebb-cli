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

STYLELINT="stylelint"
STYLELINT_OPTIONS=""

JSHINT="jshint"

ESLINT="eslint"

JSCS="jscs"
JSCS_OPTIONS="--verbose"

JSONLINT="jsonlint"
JSONLINT_OPTIONS="--quiet"

HTML_MINIFIER="html-minifier"

CLEANCSS="cleancss"
CLEANCSS_OPTIONS="--inline none"

UGLIFYJS="uglifyjs"
UGLIFYJS_OPTIONS="--mangle --compress --screw-ie8 --comments"

PYLINT="pylint"
PYLINT_OPTIONS="-r n -s n"

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

PHPMINIFY="php"
PHPMINIFY_OPTIONS="--strip"

CHECKBASH="shellcheck"
CHECKBASH_OPTIONS="--shell=bash --exclude=SC2002,SC1091"

CHECKSH="shellcheck"
CHECKSH_OPTIONS="--shell=sh --exclude=SC2002,SC1091"

#YAML="dbwebb-js-yaml"
#YAML_OPTIONS="--silent"
YAML="js-yaml"
YAML_OPTIONS=""

# Exclude these paths/filenames from tools processing
#EXCLUDE_PATHS='\*/webgl/\* \*/libs/\* \*/lib/\* \*/node_modules/\*'
EXCLUDE_PATHS='\*/example/webgl/\* \*/libs/\* \*/lib/\* \*/node_modules/\* \*/platforms/\* \*/plugins/\* \*/docs/api/\* \*/vendor/\* \*/3pp/\* \*/example/lekplats/\* \*/css/anax-grid/\* \*/me/anax-flat/\* \*/cache/\* \*/build/\* \*/.git/\* \*/slide/\*'
EXCLUDE_FILES='phpliteadmin\* \*.min.\* \*.tpl.php font-awesome.css lessc.inc.php'
INCLUDE_PATHS='' #'\*/platforms/browser/www/\*'
#EXCLUDE_PATHS="*/example/webgl/* */libs/* */lib/* */node_modules/* */platforms/* */plugins/* */docs/api/* */vendor/* */3pp/* */example/lekplats/* */css/anax-grid/* */me/anax-flat/* */cache/* */build/* */.git/* */slide/*"
#EXCLUDE_FILES="phpliteadmin* *.min.* *.tpl.php font-awesome.css lessc.inc.php"



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

        if [ ! -f "$DBW_COURSE_DIR/.eslintrc.json" ]; then
            DISABLE_ESLINT=true
        fi

        if [ ! -f "$DBW_COURSE_DIR/.stylelintrc.json" ]; then
            DISABLE_STYLELINT=true
        fi

    else
        DISABLE_ESLINT=true
        PHPMD_CONFIG="cleancode,codesize,controversial,design,naming,unusedcode"
    fi
}



#
# Check for installed tools
#
function checkInstalledValidateTools
{
    printf "Check for dbwebb tools.\n"
    printf " dbwebb:          %s\n"  "$( checkCommandWithVersion dbwebb "--version" "| cut -d ' ' -f 3" )"
    printf " dbwebb-validate: %s\n"  "$( checkCommandWithVersion dbwebb-validate "--version" "| cut -d ' ' -f 3" )"
    printf " dbwebb-inspect:  %s\n"  "$( checkCommandWithVersion dbwebb-inspect "--version" "| cut -d ' ' -f 3" )"

    printf "Check for installed validation tools.\n"
    printf " htmlhint:        %s\n"  "$( checkCommandWithVersion $HTMLHINT "--version" )"
    printf " csslint:         %s\n"  "$( checkCommandWithVersion $CSSLINT "--version" )"
    printf " stylelint:       %s\n"  "$( checkCommandWithVersion $STYLELINT "--version" )"
    printf " jshint:          %s\n"  "$( checkCommandWithVersion $JSHINT "--version" "2>&1 | cut -d ' ' -f 2" )"
    printf " eslint:          %s\n"  "$( checkCommandWithVersion $ESLINT "--version" )"
    printf " jscs:            %s\n"  "$( checkCommandWithVersion $JSCS "--version" )"
    printf " jsonlint:        %s\n"  "$( checkCommandWithVersion $JSONLINT "" )"
    printf " pylint:          %s\n"  "$( checkCommandWithVersion $PYLINT "--version" "| head -1 | cut -d ' ' -f 2" )"
    printf " php:             %s\n"  "$( checkCommandWithVersion $PHP "--version" "| head -1 | cut -d ' ' -f 2" )"
    printf " phpmd:           %s\n"  "$( checkCommandWithVersion $PHPMD "--version" "| cut -d ' ' -f 2" )"
    printf " phpcs:           %s\n"  "$( checkCommandWithVersion $PHPCS "--version" "| cut -d ' ' -f 3" )"
    printf " bash:            %s\n"  "$( checkCommandWithVersion $CHECKBASH "--version" "| head -2 | tail -1 | cut -d ' ' -f 2" )"
    printf " sh:              %s\n"  "$( checkCommandWithVersion $CHECKSH "--version" "| head -2 | tail -1 | cut -d ' ' -f 2" )"
    printf " yaml:            %s\n"  "$( checkCommandWithVersion $YAML "--version" )"
    printf " file CRLF:       %s\n"  "$( checkCommandWithVersion $FILE_CRLF "--version" "| head -1" )"
    printf " file BOM:        %s\n"  "$( checkCommandWithVersion $FILE_BOM "--version" "| head -1" )"

    printf "Check for installed publishing tools.\n"
    printf " html-minifier:   %s\n"  "$( checkCommandWithVersion $HTML_MINIFIER "--version" "| cut -d ' ' -f 2" )"
    printf " cleancss:        %s\n"  "$( checkCommandWithVersion $CLEANCSS "--version" )"
    printf " uglifyjs:        %s\n"  "$( checkCommandWithVersion $UGLIFYJS "--version" "| cut -d ' ' -f 2" )"
    printf " phpminify:       %s\n"  "$( checkCommandWithVersion $PHPMINIFY "--version" "| head -1 | cut -d ' ' -f 2" )"

    printf "Check for other tools.\n"
    printf " node:            %s\n"  "$( checkCommandWithVersion "node" "--version" )"
    printf " npm:             %s\n"  "$( checkCommandWithVersion "npm" "--version" )"
    printf " babel:           %s\n"  "$( checkCommandWithVersion "babel" "--version" " | cut -d ' ' -f 1" )"
    printf " babel-node:      %s\n"  "$( checkCommandWithVersion "babel-node" "--version" )"
    printf " python3:         %s\n"  "$( checkCommandWithVersion "python3" "--version" " | cut -d ' ' -f 2" )"
    printf " pip3:            %s\n"  "$( checkCommandWithVersion "pip3" "--version" " | cut -d ' ' -f 2" )"
}



#
# Create a find expression for validate and publish
#
function getFindExpression
{
    local dir="$1"
    local extension="$2"
    local includeExclude
    local exclude
    local findExtension=

    if [ -f "$DBW_COURSE_DIR/.dbwebb/validate.exclude" ]; then
        #includeExclude="$( grep -v "^#" "$DBW_COURSE_DIR/.dbwebb-validate.exclude" | sed "s/^-\(.*\)/-o -not -path \"\1\"/g" | sed "s/^+\(.*\)/-o -path \"\1\"/g" | tr "\n" " " )"
        includeExclude="$( grep -v "^#" "$DBW_COURSE_DIR/.dbwebb/validate.exclude" | grep -v "^--" | sed "s/^-\(.*\)/-not -path \"\1\"/g" | sed "s/^+\(.*\)/-o -path \"\1\"/g" | tr "\n" " " )"
        includeExclude="$( sed -e 's/[[:space:]]*$//' <<<${includeExclude} )"
        if [ ! -z "$includeExclude" ]; then
            includeExclude="\( $includeExclude \)"
        fi

        exclude="$( grep "^--" "$DBW_COURSE_DIR/.dbwebb/validate.exclude" | sed "s/^--\(.*\)/-not -path \"\1\"/g" | tr "\n" " " )"
        exclude="$( sed -e 's/[[:space:]]*$//' <<<${exclude} )"
        if [ ! -z "$exclude" ]; then
            exclude="\( $exclude \)"
        fi
    else
        # Hardcoded include exclude expressions
        includeExclude="$( printf " -not -path %s " $( echo $EXCLUDE_PATHS ) )"
        includeExclude="$includeExclude $( printf " -not -name %s " $( echo $EXCLUDE_FILES ) )"
        #includePaths=$( printf " -path %s " $( echo $INCLUDE_PATHS ) )
    fi

    if [ ! -z "$extension" ]; then
        findExtension="-name \"*.$extension\""
    fi

    echo "find \"$dir/\" $includeExclude -type f $findExtension" "$exclude"
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

    if hash "$cmd" 2>/dev/null; then
        printf "\n *.$extension using $cmd"

        # If within course repo, use relative links in find
        if [[ $DBW_COURSE_DIR ]]; then
            pushd "$DBW_COURSE_DIR" > /dev/null
            dir=".${dir#$DBW_COURSE_DIR}"
        fi

        findExpression="$( getFindExpression "$dir" "$extension" )"

        [[ $optDryRun ]] && printf "\n%s" "$findExpression"

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
        [[ $DBW_COURSE_DIR ]] && popd &> /dev/null

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

    [[ $ENABLE_ALL || ! $DISABLE_HTMLHINT ]]  && validateCommand "$dir" "$HTMLHINT" "html" "$HTMLHINT_OPTIONS $HTMLHINT_CONFIG" '| grep -v "No problem." | grep -v "Config loaded." | grep -v "Scan " | grep -v "Scanned "; test ${PIPESTATUS[0]} -eq 0'
    [[ $ENABLE_ALL || ! $DISABLE_CSSLINT ]]   && validateCommand "$dir" "$CSSLINT" "css" "$CSSLINT_OPTIONS $( cat "$CSSLINT_CONFIG" )"
    [[ $ENABLE_ALL || ! $DISABLE_STYLELINT ]]   && validateCommand "$dir" "$STYLELINT" "css" "$STYLELINT_OPTIONS" "" ""
    [[ $ENABLE_ALL || ! $DISABLE_JSHINT ]]    && validateCommand "$dir" "$JSHINT" "js"
    [[ $ENABLE_ALL || ! $DISABLE_ESLINT ]]    && validateCommand "$dir" "$ESLINT" "js"
    [[ $ENABLE_ALL || ! $DISABLE_JSCS ]]      && validateCommand "$dir" "$JSCS" "js"  "$JSCS_OPTIONS $JSCS_CONFIG < /dev/null" "" "onlyExitStatus"
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
    [[ $ENABLE_ALL || ! $DISABLE_FILE_CRLF ]] && validateCommand "$dir" "$FILE_CRLF" "" "$FILE_CRLF_OPTIONS" '| grep CRLF; test $? -eq 1' ""
    [[ $ENABLE_ALL || ! $DISABLE_FILE_BOM ]]  && validateCommand "$dir" "$FILE_BOM" "" "$FILE_BOM_OPTIONS" '| grep BOM; test $? -eq 1' ""
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

        # Find real path to cmd
        set $cmd
        local cmdPath="$( get_realpath "$( which $1 )" )"

        # If within course repo, use relative links in find
        if [[ $DBW_COURSE_DIR && $DBW_PUBLISH_ROOT ]]; then
            pushd "$DBW_PUBLISH_ROOT" > /dev/null
            [[ $optDryRun ]] && printf "\nCurrent dir: %s" "$(pwd)"
            dir=".${dir#$DBW_PUBLISH_ROOT}"
        fi

        findExpression="$( getFindExpression "$dir" "$extension" )"

        [[ $optDryRun ]] && printf "\n%s" "$findExpression"

        for filename in $( eval $findExpression ); do
            if [[ $optDryRun ]]; then
                printf "\n%s" "$cmdPath $options $filename $output $filename"
            else
                assert 0 "$cmdPath $options $filename $output $filename" "$cmd failed: $filename"
            fi
            counter=$(( counter + 1 ))
            printf "."
        done

        [[ $DBW_COURSE_DIR ]] && popd &> /dev/null
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
DBW_PUBLISH_ROOT=
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

        --publish-root)
            DBW_PUBLISH_ROOT="$( get_realpath "$2" )"
            if [ ! -d $( dirname "$DBW_PUBLISH_ROOT" ) ]; then
                badUsage "$MSG_FAILED --publish-root '$DBW_PUBLISH_ROOT' is not a valid directory."
                exit 2
            fi

            shift
            shift
            ;;

        --publish-to)
            DBW_PUBLISH_TO="$( get_realpath "$2" )"
            if [ ! -d $( dirname "$DBW_PUBLISH_TO" ) ]; then
                badUsage "$MSG_FAILED --publish-to '$DBW_PUBLISH_TO' is not a valid directory."
                exit 2
            fi

            shift
            shift
            ;;

        --course-repo)
            DBW_COURSE_DIR="$( get_realpath "$2" )"
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
dir="$( get_realpath "$dir" )"

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

    printf "\nPublishing to '%s' using root '%s'." "$DBW_PUBLISH_TO" "$DBW_PUBLISH_ROOT"
    publish "$dir" "$DBW_PUBLISH_TO"
fi

assertResults
