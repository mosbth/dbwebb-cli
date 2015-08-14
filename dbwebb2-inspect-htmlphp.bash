#---------------------------- INSPECT HTMLPHP START --------------------------
#
#
#
function htmlphpme()
{
    local me="$1"
    
    headerForTest "-- me-page $me" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning" 
    openFilesInEditor "me/$KMOM/$me"
    checkKmomDir "me/$KMOM/$me"

    printUrl "me.php" "me/$KMOM/$me"  
    printUrl "redovisning.php" "me/$KMOM/$me"  

    pressEnterToContinue
}



#
#
#
function htmlphplab()
{
    local lab="$1"
    local target="me/$KMOM/$lab"
    
    headerForTest "-- Lab" "-- ${DBW_WWW}$DBW_COURSE/$lab" 
    openFilesInEditor "$target"
    checkKmomDir "$target"
    printUrl "" "$target"  
    inspectCommand "answer.php" "$EXEC_DIR/$KMOM/$lab" "php answer.php"
    pressEnterToContinue
}



#
# Test general
#
function htmlphp()
{
    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir
    publishKmom
    validateKmom "$KMOM"
    htmlphpme $( echo "$KMOM" | sed 's/kmom0/me/g' | sed 'a/kmom/me/g' )
}



#
# Test kmom01
#
function htmlphpkmom01()
{
    test
}



#
# Test kmom02
#
function htmlphpkmom02()
{
    htmlphplab "lab1"
}



#
# Test kmom03
#
function htmlphpkmom03()
{
    htmlphplab "lab2"
}



#
# Test kmom04
#
function htmlphpkmom04()
{
    htmlphplab "lab3"
}



#
# Test kmom
#
function htmlphpkmom05()
{
    htmlphplab "lab4"
}



#
# Test kmom
#
function htmlphpkmom06()
{
    htmlphplab "lab5"
}



#
# Test kmom
#
function htmlphpkmom10()
{
    test
}



#---------------------------- INSPECT HTMLPHP END ----------------------------
