#---------------------------- INSPECT DESIGN START --------------------------
#
# Test general
#
function design()
{
    TREE_OPTIONS="-d"
    #inspectIntro

    #local target="me/$KMOM"

    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir "me/anax-flat"
    #publishKmom
    #viewFileTree "$target"
    validateKmom "me"


    
    local meDir=
    
    meDir="$( echo "$KMOM" | sed 's/kmom0/me/g' | sed 's/kmom/me/g' )"
    METARGET="me/$KMOM/$meDir"
}



#
#
#
function designRepo()
{
    local repo="$1"
    local target="me/$repo"
    
    headerForTest "-- Repo $repo" "-- ${DBW_WWW}$DBW_COURSE/$target" 
    openFilesInEditor "$target"
    printUrl "" "$target"  
    isGitRepo "$target"
    hasGitTagBetween "$EXEC_DIR/$repo" "$2" "$3"
    if [ ! -z "$4" ]; then
        hasGitTagBetween "$EXEC_DIR/$repo" "$4" "$5"
    fi

    inspectCommand "" "$EXEC_DIR/$repo" "git tag" ""
    inspectCommand "" "$EXEC_DIR/$repo" "git log --pretty=format:\"%h%ad\|%s%d[%an]\" --graph --date=short | head -10" ""

    # All repos does not include make test
    # Make test need test environment
    #inspectCommand "Makefile" "$EXEC_DIR/$repo" "make test" ""

    # ? below
    #inspectCommand "" "$EXEC_DIR/$repo" "git tag"
    #cd "$EXEC_DIR/$repo" && git status
    #validateKmom "$repo"
}



#
# Test kmom
#
function designkmom01()
{
    designRepo "anax-flat" "1.0.0" "1.1.0" "1.1.0" "1.2.0"
    designRepo "anax-flat/theme" "1.0.0" "1.1.0" "1.1.0" "1.2.0"
}



#
# Test kmom
#
function designkmom02()
{
    designRepo "anax-flat" "2.0.0" "3.0.0"
    designRepo "anax-flat/theme" "2.0.0" "3.0.0"
}



#
# Test kmom
#
function designkmom03()
{
    designRepo "anax-flat" "3.0.0" "4.0.0"
    designRepo "anax-flat/theme" "3.0.0" "4.0.0"
}



#
# Test kmom
#
function designkmom04()
{
    echo "TBD"
}



#
# Test kmom
#
function designkmom05()
{
    echo "TBD"
}



#
# Test kmom
#
function designkmom06()
{
    echo "TBD"
}



#
# Test kmom
#
function designkmom10()
{
    echo "TBD"
}



#---------------------------- INSPECT DESIGN END ----------------------------
