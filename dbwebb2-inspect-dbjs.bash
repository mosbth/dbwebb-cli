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
    inspectExerciseHeader "Kom igång med SQLite" "kunskap/kom-igang-med-databasen-sqlite" "kmom02/jetty"

    inspectLab "uppgift/sql-lab-introduktion-till-sql-dbjs" "sql1" "answer.bash" "./answer.bash"

    inspectExerciseHeader "ER Jetty" "uppgift/skapa-er-modell-av-databasen-jetty" "redovisa"
    printUrl "jetty.html" "me/redovisa"

    inspectLab "uppgift/javascript-med-funktioner-dbjs" "javascript2" "answer.js" ""

    inspectLab "uppgift/gor-svenska-flaggan-med-javascript-html-och-css-dbjs" "flag2" "index.html" ""
}



#
# Test kmom
#
function dbjskmom03()
{
    local target=
    local curlit=

    inspectLab "uppgift/introduktion-till-nodejs" "node1" "answer.js" "node answer.js"



    inspectExerciseHeader "server" "uppgift/skapa-en-restful-http-server-med-node-js" "$KMOM/server"

    target="$EXEC_DIR/$KMOM/server"
    runServer "index.js" "$target" "node index.js"

    curlit="curl http://localhost:$LINUX_PORT"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/index.html"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/status"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/sum?2&3&5&32"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/filter?1&2&4&42&43&99"
    inspectCommand "" "$EXEC_DIR/$KMOM/invoice" "$curlit/route-does-not-exists"

    killServer "$target"



    inspectExerciseHeader "invoice" "uppgift/bygg-en-faktureringsmotor-for-batklubben" "$KMOM/invoice"
    inspectCommand "index.js" "$EXEC_DIR/$KMOM/invoice" "node index.js"

    inspectLab "uppgift/sql-lab-fortsattning-med-sql" "sql2" "answer.bash" "./answer.bash"
}



#
# Test kmom
#
function dbjskmom04()
{
    inspectExerciseHeader "skolan" "uppgift/kom-igang-med-sql" "$KMOM/skolan"
    viewFileContent "skolan.sql" "me/$KMOM/skolan"
    # should execute the sql-file skolan/skolan.sql

    inspectLab "uppgift/uppgift/nodejs-inbyggda-moduler" "node2" "answer.js" "node answer.js"

    inspectExerciseHeader "terminal" "uppgift/nodejs-terminalprogram-mot-mysql" "$KMOM/terminal"
    viewFileContent "allan" "me/$KMOM/terminal"
    inspectCommand "" "$EXEC_DIR/$KMOM/terminal" "./allan --version"
    inspectCommand "" "$EXEC_DIR/$KMOM/terminal" "./allan --help"
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
