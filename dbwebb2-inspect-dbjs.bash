#---------------------------- INSPECT dbjs START --------------------------
#
# Test general
#
function dbjs()
{
    inspectIntro
}



#
# Test general, last in sequence
#
function dbjslast()
{
    inspectMe "me/redovisa" "me.html" "redovisning.html" "" "redovisa"
}



#
# Test kmom
#
function dbjskmom01()
{
    inspectLab "uppgift/skapa-din-egen-sandbox-for-javascript-testprogram" "sandbox" "index.html" ""

    inspectLab "uppgift/gor-svenska-flaggan-i-html-och-css-dbjs" "flag1" "index.html" ""

    inspectLab "uppgift/javascript-med-variabler-loopar-och-inbyggda-funktioner-1" "javascript1" "answer.js" ""
}



#
# Test kmom
#
function dbjskmom02()
{
    # jetty , boats.sqlite, boats.sql

    inspectExerciseHeader "Kom igång med SQLite" "https://dbwebb.se/kunskap/kom-igang-med-databasen-sqlite" "kmom02/jetty"

    inspectLab "https://dbwebb.se/uppgift/sql-lab-introduktion-till-sql-dbjs" "sql1" "answer.bash" "./answer.bash"

    inspectExerciseHeader "ER Jetty" "https://dbwebb.se/uppgift/skapa-er-modell-av-databasen-jetty" "redovisa"
    printUrl "jetty.html" "me/redovisa"

    inspectLab "https://dbwebb.se/uppgift/javascript-med-funktioner-dbjs" "javascript2" "answer.js" ""

    inspectLab "uppgift/gor-svenska-flaggan-med-javascript-html-och-css-dbjs" "flag2" "index.html" ""
}



#
# Test kmom
#
function dbjskmom03()
{
    :
}



#
# Test kmom
#
function dbjskmom04()
{
    :
}



#
# Test kmom
#
function dbjskmom05()
{
    :
}



#
# Test kmom
#
function dbjskmom06()
{
    :
}



#
# Test kmom
#
function dbjskmom10()
{
    :
}



#---------------------------- INSPECT DESIGN END ----------------------------
