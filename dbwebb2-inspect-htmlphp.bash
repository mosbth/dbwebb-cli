#---------------------------- INSPECT HTMLPHP START --------------------------
#
# Test general
#
function htmlphp()
{
    inspectIntro
    
    local meDir=
    
    meDir="$( echo "$KMOM" | sed 's/kmom0/me/g' | sed 's/kmom/me/g' )"
    METARGET="me/$KMOM/$meDir"
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
}



#
# Test kmom
#
function htmlphpkmom01()
{
    inspectMe "$METARGET" "me.php" "report.php" "uppgift/skapa-en-me-sida-i-kursen-htmlphp"
}



#
# Test kmom
#
function htmlphpkmom02()
{
    inspectMe "$METARGET" "me.php" "report.php" "uppgift/bygg-ut-din-htmlphp-me-sida-till-version-2"

    htmlphplab "lab1"
}



#
# Test kmom
#
function htmlphpkmom03()
{
    inspectMe "$METARGET" "me.php" "report.php" "uppgift/bygg-ut-din-htmlphp-me-sida-till-version-3"

    viewFileContent "multipage.php" "$METARGET"

    htmlphplab "lab2"
    
    inspectExercise "multi" "uppgift/bygg-en-multisida-och-testa-arrayer"
}



#
# Test kmom
#
function htmlphpkmom04()
{
    inspectMe "$METARGET" "me.php" "report.php" "uppgift/bygg-ut-din-me-sida-till-version-4"

    viewFileContent "config.php" "$METARGET"
    viewFileContent "stylechooser.php" "$METARGET"

    htmlphplab "lab3"

    inspectExercise "stylechooser" "uppgift/bygg-en-stylevaljare-till-din-webbplats"
}



#
# Test kmom
#
function htmlphpkmom05()
{
    inspectMe "$METARGET" "me.php" "report.php" "htmlphp/proj5"

    viewFileContent "jetty.php" "$METARGET"
    viewFileContent "search.php" "$METARGET"

    htmlphplab "lab4"

    inspectExercise "jetty" "uppgift/bygg-en-multisida-for-att-soka-i-en-databas"
}



#
# Test kmom
#
function htmlphpkmom06()
{
    inspectMe "$METARGET" "me.php" "report.php" "htmlphp/proj6"
    
    viewFileContent "admin.php" "$METARGET"
    
    htmlphplab "lab5"
}



#
# Test kmom
#
function htmlphpkmom10()
{
    inspectMe "$METARGET" "me.php" "report.php"
}



#---------------------------- INSPECT HTMLPHP END ----------------------------
