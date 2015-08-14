#---------------------------- INSPECT linux START --------------------------
#
#
#
function linuxme()
{
    headerForTest "-- me-page" "-- ${DBW_WWW}$DBW_COURSE/$KMOM#resultat_redovisning" 
    openFilesInEditor "me/redovisa/"
    checkKmomDir "me/redovisa"

    printUrl "me.html" "me/redovisa"  
    printUrl "report.html" "me/redovisa"  

    pressEnterToContinue
}



#
# NOT USED IN LINUX REMOVE WHEN DONE WITH VALIDATIONG OTHER STUFF
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
    #http://dbwebb.se/uppgift/installera-debian-som-server
}



#
# Test kmom02
#
function linuxkmom02()
{
    #http://dbwebb.se/uppgift/skapa-en-webbplats-pa-en-apache-virtual-host
    #http://dbwebb.se/uppgift/strukturera-filer-kataloger-och-rattigheter-i-en-webbplats
    test
}



#
# Test kmom03
#
function linuxkmom03()
{
    #http://dbwebb.se/uppgift/hitta-saker-i-en-loggfil-med-unix-kommandon
    #http://dbwebb.se/uppgift/mina-forsta-bash-script
    test
}



#
# Test kmom04
#
function linuxkmom04()
{
    #http://dbwebb.se/uppgift/utfor-nodeschool-workshopen-javascripting
    #http://dbwebb.se/uppgift/skapa-en-restful-http-server-med-node-js-och-klient-i-bash
    test
}



#
# Test kmom
#
function linuxkmom05()
{
    test
}



#
# Test kmom
#
function linuxkmom06()
{
    test
}



#
# Test kmom
#
function linuxkmom10()
{
    test
}



#---------------------------- INSPECT linux END ----------------------------
