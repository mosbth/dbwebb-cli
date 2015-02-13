# --------------- DBWEBB-VALIDATE MAIN START HERE ---------------
#
# External tools
#
JSHINT="jshint"
HTMLHINT="dbwebb-htmlhint"
CSSHINT="htmlhint"

HTML_MINIFIER="html-minifier"
# TODO use DBW_COURSE_DIR
HTML_MINIFIER_OPTIONS="--config-file ./.html-minifier.conf"

UGLIFYJS="uglifyjs"
UGLIFYJS_OPTIONS="--mangle --compress --screw-ie8 --comments"

CLEANCSS="cleancss"
CLEANCSS_OPTIONS="--s1 --skip-import"

PYLINT="pylint"
# TODO use DBW_COURSE_DIR
PYLINT_OPTIONS="-r n --rcfile ./.pylintrc"



#
# Settings for this script
#
#umask 022
export NODE_PATH=/usr/local/lib/node_modules



#
# Check for installed tools
#
function checkInstalledValidateTools
{
    printf "\nCheck for installed validation tools."
    printf "\n"
    printf " pylint:        %s\n" "$( checkCommand $PYLINT )"
    printf " htmlhint:      %s\n" "$( checkCommand $HTMLHINT )"
    printf " csshint:       %s\n" "$( checkCommand $CSSHINT )"
    printf " jshint:        %s\n" "$( checkCommand $JSHINT )"

    if [[ $doPublish ]]; then 

        printf " html-minifier: %s\n" "$( checkCommand $HTML_MINIFIER )"
        printf " uglifyjs:      %s\n" "$( checkCommand $UGLIFYJS )"
        printf " cleancss:      %s\n" "$( checkCommand $CLEANCSS )"
    fi

    printf "\n"
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
    
    printf "\n\n$MSG_OK"
    printf " Asserts: $ASSERTS Faults: $FAULTS\n\n"
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

    printf "\n *.js using JSHint."
    for filename in $(find "$dir/" -type f -name '*.js'); do
        assert 0 "$JSHINT $filename" "JSHint failed: $filename"
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
        assert 0 "$PYLINT $PYLINT_OPTIONS $filename" "pylint failed: $filename"
    done

    printf "\n *.cgi using Pylint."
    for filename in $(find "$dir/" -type f -name '*.cgi'); do
        assert 0 "$PYLINT $PYLINT_OPTIONS $filename" "pylint failed: $filename"
    done
}



# ----------------------------------------- TO BE VALIDATED --------------------


#
# Init the build directory
#
initBuildDir()
{
    ME="$BUILD/me"
    for dir in $BUILD1 $BUILD2 $BUILD3 $BUILD $ME $ME/kmom01 $ME/kmom02 $ME/kmom03 $ME/kmom04 $ME/kmom05 $ME/kmom06 $ME/kmom10; do
        if [ ! -d $dir ]; then mkdir $dir; fi
    done
}



#
# Publish all
#
publishChmod()
{
    DIR="$1"

    #find $BUILD/$dir/ -type d -print0 | xargs -0 chmod 755 
    #find $BUILD/$dir/ -type f -print0 | xargs -0 chmod 644
    #find $BUILD/$dir/ -type f -name '*.cgi' -print0 | xargs -0 chmod 755
    #find $BUILD/$dir/ -type f -name '*.py'  -print0 | xargs -0 chmod 600

    for filename in $(find "$DIR" -type d); do
        chmod 755 "$filename"
    done

    for filename in $(find "$DIR" -type f); do
        chmod 644 "$filename"
    done

    for filename in $(find "$DIR" -type f -name '*.cgi'); do
        chmod 755 "$filename"
    done

    for filename in $(find "$DIR" -type f -name '*.py'); do
        chmod 600 "$filename"
    done
}



#
# Publish all
#
publish()
{
    DIR="$1"
    SILENT="$2"

    if [ -z "$SILENT" ]; then
        printf "\n\nPublishing $DIR to www/$BASEDIR/$PROJECT."
    fi
   
    case "$DIR" in
        example)    DIRS="example" ;;
        tutorial)   DIRS="tutorial" ;;
        me)         DIRS="me" ;;
        all)        DIRS="example tutorial me" ;;
        kmom*)      DIRS="me/js me/style $DIR" ;;
        *)          DIRS="$DIR" ;;
    esac

    rsync -a --delete --exclude 'me/default' -f '- /*/' $TARGET/me/ $BUILD/me/
    
    publishChmod "$BUILD/me/"

    for filename in $(find $BUILD/me/ -maxdepth 1 -type f -name '*.html'); do
        assert 0 "$HTML_MINIFIER $HTML_MINIFIER_OPTIONS $filename --output $filename" "HTMLMinifier failed: $filename"
    done

    for filename in $(find $BUILD/me/ -maxdepth 1 -type f -name '*.js'); do
        assert 0 "$UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS" "UglifyJS failed: $filename"
    done

    for filename in $(find $BUILD/me/ -maxdepth 1 -type f -name '*.css'); do
        assert 0 "$CLEANCSS $filename -o $filename" "CleanCSS failed: $filename"
    done

    #find "$BUILD/me/" -maxdepth 1 -type f -name '*.html' | while read filename; do $HTML_MINIFIER $HTML_MINIFIER_OPTIONS $filename --output $filename; exit; done
    #find "$BUILD/me/" -maxdepth 1 -type f -name '*.js'   | while read filename; do $UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS; done
    #find "$BUILD/me/" -maxdepth 1 -type f -name '*.css'  | while read filename; do $CLEANCSS $filename -o $filename; done

    for dir in $DIRS; do
        if [ ! -d "$TARGET/$dir" ]; then continue; fi

        printf "\n $dir:"
        rsync -a --delete $TARGET/$dir/ $BUILD/$dir/ 
        
        publishChmod "$BUILD/$dir/"

        if [ -z "$SILENT" ]; then printf " minify *.html"; fi
        #find "$BUILD/$dir/" -type f -name '*.html' | while read filename; do assert "0" "$HTML_MINIFIER $HTML_MINIFIER_OPTIONS $filename --output $filename" "HTMLMinifier failed: $filename"; done
        for filename in $(find "$BUILD/$dir/" -type f -name '*.html'); do
            assert 0 "$HTML_MINIFIER $HTML_MINIFIER_OPTIONS $filename --output $filename" "HTMLMinifier failed: $filename"
        done

        if [ -z "$SILENT" ]; then printf " uglify *.js"; fi
        #$UGLIFYJS $BUILD/$KMOM/$DIR/js/main.js -o $BUILD/$KMOM/$DIR/js/main.js $UGLIFYJS_OPTIONS
        #find "$BUILD/$dir/" -type f -name '*.js' | while read filename; do assert "0" "$UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS" "UglifyJS failed: $filename"; done
        for filename in $(find "$BUILD/$dir/" -type f -name '*.js'); do
            assert 0 "$UGLIFYJS $filename -o $filename $UGLIFYJS_OPTIONS" "UglifyJS failed: $filename"
        done

        
        if [ -z "$SILENT" ]; then printf " minify *.css"; fi
        #$CLEANCSS $BUILD/$KMOM/$DIR/style/style.css -o $BUILD/$KMOM/$DIR/style/style.css
        #find "$BUILD/$dir/" -type f -name '*.css' | while read filename; do assert "0" "$CLEANCSS $filename -o $filename" "CleanCSS failed: $filename"; done
        for filename in $(find "$BUILD/$dir/" -type f -name '*.css'); do
            assert 0 "$CLEANCSS $filename -o $filename" "CleanCSS failed: $filename"
        done

    done
}



#
# Process options
#
while (( $# ))
do
    case "$1" in
        
        --check | -c)
            optCheck="yes"
            shift
            ;;

        --publish | -p)
            optPublish="yes"
            shift
            ;;

        --help | -h)
            printf %s "${usage[@]}"
            exit 0
        ;;
        
        --version | -v)
            printf %s "${version[@]}"
            exit 0
        ;;
                
        *)
            if [[ $command ]]; then
                printf "$MSG_FAILED Too many options/items and/or option not recognized.\n\n"
                printf %s "${badUsage[@]}"
                exit 1
            else
                command=$1
            fi
            shift
        ;;
        
    esac
done



#
# Get the path to check
#
dir="$( getPathToDirectoryFor $command )"



#
# Do check for installed tools
#
if [[ $optCheck ]]; then checkInstalledValidateTools; fi
    
    
    
#
# Validate
#
printf "\nValidate directory '$dir'"
assert 0 "[ -d \"$dir\" ]" "Missing directory to validate: '$dir'"
validateHtmlCssJs "$dir" 
validatePython "$dir"



# TODO Validate for another user?
#THETARGET="$TARGET"
#if [ ! -z "$THEUSER" ]
#then
#    THETARGET=`eval echo "~$THEUSER/dbwebb-kurser/$COURSE"`
#fi



#
# Publish
#
if [[ $optPublish ]]; then
    initBuildDir
    publish "$dir"
fi



#
# Wrap it up
#
assertResults
