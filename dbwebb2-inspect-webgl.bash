#---------------------------- INSPECT webgl START --------------------------
#
#
#
function webglme()
{
    headerForTest "-- me-page" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning" 
    openFilesInEditor "me/redovisa/"
    checkKmomDir "me/redovisa"

    printUrl "me.html" "me/redovisa"  
    printUrl "report.html" "me/redovisa"  

    pressEnterToContinue
}



#
#
#
function webgllab()
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
function webgl()
{
    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir
    publishKmom
    validateKmom "$KMOM"
    webglme
}



#
# Test kmom01
#
function webglkmom01()
{
    test
}



#
# Test kmom02
#
function webglkmom02()
{
    webgllab "lab1"
}



#
# Test kmom03
#
function webglkmom03()
{
    webgllab "lab2"
}



#
# Test kmom04
#
function webglkmom04()
{
    webgllab "lab3"
}



#
# Test kmom
#
function webglkmom05()
{
    webgllab "lab4"
}



#
# Test kmom
#
function webglkmom06()
{
    webgllab "lab5"
}



#
# Test kmom
#
function webglkmom10()
{
    test
}



#---------------------------- INSPECT webgl END ----------------------------
