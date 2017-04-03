#---------------------------- INSPECT oophp START --------------------------
#
# Test general
#
function oophp()
{
    inspectIntro
}



#
# Test general, last in sequence
#
function oophplast()
{
    inspectMe "me/anax-lite" "" "" "" "anax-lite"
}



#
#
#
function oophpRepo()
{
    local repo="$1"
    local target="me/$repo"
    
    headerForTest "-- Repo $repo" "-- ${DBW_WWW}$DBW_COURSE/$target" 
    openFilesInEditor "$target"
    printUrl "" "$target"  

    isGitRepo "$target"
    hasGitTagBetween "$EXEC_DIR/$repo" "$2" "$3" > /dev/null
    if [ ! -z "$4" ]; then
        hasGitTagBetween "$EXEC_DIR/$repo" "$4" "$5" > /dev/null
    fi

    if [ ! -z "$4" ]; then
        tag=$( hasGitTagBetween "$EXEC_DIR/$repo" "$2" "$5" )
    else
        tag=$( hasGitTagBetween "$EXEC_DIR/$repo" "$2" "$3" )
    fi

    inspectCommand "" "$EXEC_DIR/$repo" "git remote -v" ""
    inspectCommand "" "$EXEC_DIR/$repo" "git tag" ""
    inspectCommand "" "$EXEC_DIR/$repo" "git status" ""
    inspectCommand "" "$EXEC_DIR/$repo" "git log -n 20 --pretty=format:\"%h_%ad_:_%s%d_[%an]\" --graph --date=short" ""
    #inspectCommand "" "$EXEC_DIR/$repo" "git stash" ""
    #inspectCommand "" "$EXEC_DIR/$repo" "git checkout -b inspect $tag" ""

    # All repos does not include make test
    # Make test need test environment
    #inspectCommand "Makefile" "$EXEC_DIR/$repo" "make test" ""
}



#
# Test kmom
#
function oophpkmom01()
{
    oophpRepo "anax-lite" "1.0.0" "2.0.0"

    inspectExerciseHeader "guess" "uppgift/gissa-numret" "$KMOM/guess"
    printUrl "index.php" "me/$KMOM/guess"

    inspectExerciseHeader "skolan" "uppgift/kom-igang-med-sql" "kmom01/skolan"
    viewFileContent "skolan.sql" "me/kmom01/skolan"
    # should execute the sql-file skolan/skolan.sql
}



#
# Test kmom
#
function oophpkmom02()
{
    oophpRepo "anax-lite" "2.0.0" "3.0.0"

    inspectExerciseHeader "skolan" "uppgift/kom-igang-med-sql" "kmom01/skolan"
    viewFileContent "skolan.sql" "me/kmom01/skolan"
    # should execute the sql-file skolan/skolan.sql
}



#
# Test kmom
#
function oophpkmom03()
{
    oophpRepo "anax-lite" "3.0.0" "4.0.0"

    inspectExerciseHeader "skolan" "uppgift/kom-igang-med-sql" "kmom01/skolan"
    viewFileContent "skolan.sql" "me/kmom01/skolan"
    # should execute the sql-file skolan/skolan.sql
}



#
# Test kmom
#
function oophpkmom04()
{
    :
}



#
# Test kmom
#
function oophpkmom05()
{
    :
}



#
# Test kmom
#
function oophpkmom06()
{
    :
}



#
# Test kmom
#
function oophpkmom10()
{
    :
}



#---------------------------- INSPECT oophp END ----------------------------
