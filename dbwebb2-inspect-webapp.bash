#---------------------------- INSPECT webapp START --------------------------
#
# Test general
#
function webapp()
{
    inspectIntro
    
    local meDir=
    
    meDir="$( echo "$KMOM" | sed 's/kmom0/me/g' | sed 's/kmom/me/g' )"
    METARGET="me/$KMOM/$meDir"
}

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
#
# Test kmom01
#
function webappkmom01()
{
    inspectMe "$METARGET" "index.html" "" "uppgift/skapa-en-me-app-till-webapp-kursen"
}



#
# Test kmom02
#
function webappkmom02()
{
    inspectMe "$METARGET" "index.html" "" "uppgift/bygg-ut-me-appen-med-ett-potpurri-av-tester"
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
