#---------------------------- INSPECT HTMLPHP STARRT --------------------------
#
#
#
function htmlphpme()
{
    headerForTest "-- me-page" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning" 
    openFilesInEditor "me/redovisa/"
    checkKmomDir "me/redovisa"

    printUrl "me.php" "me/redovisa"  
    printUrl "redovisning.php" "me/redovisa"  

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
    inspectCommand "answer.php" "$COPY_DIR/$KMOM/$lab" "php answer.php"
    pressEnterToContinue
}



#
# Test kmom01
#
function htmlphp()
{
    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir
    publishKmom
    validateKmom "$KMOM"
    htmlphpme
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
