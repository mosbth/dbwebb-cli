#---------------------------- INSPECT DBJS START --------------------------
#
# Test general
#
function oopython()
{
    inspectIntro
}



#
# Test general, last in sequence
#
function oopythonlast()
{
    inspectMe "me/flask" "app.cgi" "" "" "flask"
}



#
# Test kmom
#
function oopythonkmom01()
{
    inspectLab "uppgift/python-med-objekt-och-klasser" "lab1" "answer.py" "python3 answer.py"
}



#
# Test kmom
#
function oopythonkmom02()
{
    inspectLab "uppgift/python-med-mer-objekt-och-klasser" "lab2" "answer.py" "python3 answer.py"

    inspectExerciseHeader "Skapa objekt efter UML-diagram" "uppgift/skapa-objekt-efter-uml" "$KMOM/deck"
    fileIsReadable "me/$KMOM/deck/deck.py"
    fileIsReadable "me/$KMOM/deck/hand.py"
    fileIsReadable "me/$KMOM/deck/card.py"
    inspectCommand "main.py" "$THEDIR/me/$KMOM/deck" "python3 main.py"

    inspectExerciseHeader "Testfall för din kortlek" "uppgift/skriv-testfall-for-ett-objekt" "$KMOM/test"
    viewFileContent "test_deck.py" "me/$KMOM/test"
    inspectCommand "test_deck.py" "$THEDIR/me/$KMOM/test" "python3 test_deck.py"

    inspectExerciseHeader "Sequence diagram" "uppgift/skapa-sequence-diagram" "$KMOM/uml"
    printUrl "sequenceDiagram.png" "me/$KMOM/uml"
}


#
# Test kmom
#
function oopythonkmom03()
{
    inspectExerciseHeader "Skapa ett person-objekt till me-sidan" "uppgift/skapa-personobjekt-till-me-sida" "flask"
    fileIsReadable "me/flask/person.py"
    printUrl "person.png" "me/flask"
    printUrl "person.html" "me/flask"

    inspectExerciseHeader "Skapa ett dataobjekt till me-sidan" "uppgift/skapa-dataobjekt-till-me-sida" "flask"
    fileIsReadable "me/flask/data.py"
    printUrl "data.png" "me/flask"
    printUrl "data.html" "me/flask"

    inspectExerciseHeader "Skapa ett Black Jack spel" "uppgift/skapa_blackjack" "$KMOM/blackjack"
    inspectCommand "main.py" "$THEDIR/me/$KMOM/blackjack" "python3 main.py"
}



#
# Test kmom
#
function oopythonkmom04()
{
    inspectLab "uppgift/python-med-regex" "lab3" "answer.py" "python3 answer.py"

    inspectExerciseHeader "Skapa en bondgårdssdatabas" "uppgift/skapa-en-bondgards-databas" "flask"
    executeSQLite "me/flask/db/farms.sqlite" ".schema"

    inspectExerciseHeader "Visa bondgården på me-sidan" "uppgift/visa-bondgarden-pa-me-sida" "flask"
    printUrl "app.cgi" "me/flask"
}



#
# Test kmom
#
function oopythonkmom05()
{
    :
}



#
# Test kmom
#
function oopythonkmom06()
{
    :
}



#
# Test kmom
#
function oopythonkmom10()
{
    :
}



#---------------------------- INSPECT DESIGN END ----------------------------
