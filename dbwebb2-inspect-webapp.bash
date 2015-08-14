#---------------------------- INSPECT webapp START --------------------------
#
#
#
function webappme()
{
    headerForTest "-- me-page" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning" 
    openFilesInEditor "me/redovisa/"
    checkKmomDir "me/redovisa"

    printUrl "me.html" "me/redovisa"  
    printUrl "report.html" "me/redovisa"  

    pressEnterToContinue
}



#
# NOT USED IN WEBAPP REMOVE WHEN DONE WITH VALIDATIONG OTHER STUFF
#
function webapplab()
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
function webapp()
{
    headerForTest "-- $DBW_COURSE $KMOM" "-- ${DBW_WWW}$DBW_COURSE/$KMOM"
    checkKmomDir
    publishKmom
    validateKmom "$KMOM"
    webappme
}



#
# Test kmom01
#
function webappkmom01()
{
    test
}



#
# Test kmom02
#
function webappkmom02()
{
    test
}



#
# Test kmom03
#
function webappkmom03()
{
    test
}



#
# Test kmom04
#
function webappkmom04()
{
    test
}



#
# Test kmom
#
function webappkmom05()
{
    test
}



#
# Test kmom
#
function webappkmom06()
{
    test
}



#
# Test kmom
#
function webappkmom10()
{
    test
}



#---------------------------- INSPECT webapp END ----------------------------
