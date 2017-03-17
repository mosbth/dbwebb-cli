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
# Test kmom
#
function oophpkmom01()
{
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
    inspectExerciseHeader "skolan" "uppgift/kom-igang-med-sql" "kmom01/skolan"
    viewFileContent "skolan.sql" "me/kmom01/skolan"
    # should execute the sql-file skolan/skolan.sql
}



#
# Test kmom
#
function oophpkmom03()
{
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
