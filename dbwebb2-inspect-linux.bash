#---------------------------- INSPECT linux START --------------------------
#
#
#
function linuxme()
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
function linuxlab()
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
function linux()
{
    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir
    publishKmom
    validateKmom "$KMOM"
    linuxme
}



#
# Test kmom01
#
function linuxkmom01()
{
    test
}



#
# Test kmom02
#
function linuxkmom02()
{
    linuxlab "lab1"
}



#
# Test kmom03
#
function linuxkmom03()
{
    linuxlab "lab2"
}



#
# Test kmom04
#
function linuxkmom04()
{
    linuxlab "lab3"
}



#
# Test kmom
#
function linuxkmom05()
{
    linuxlab "lab4"
}



#
# Test kmom
#
function linuxkmom06()
{
    linuxlab "lab5"
}



#
# Test kmom
#
function linuxkmom10()
{
    test
}



#---------------------------- INSPECT linux END ----------------------------
