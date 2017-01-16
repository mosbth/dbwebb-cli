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
    inspectCommand "test_deck.py" "$THEDIR/me/$KMOM/test" "python3 test_deck.py"

    inspectExerciseHeader "Sequence diagram" "uppgift/skapa-sequence-diagram" "$KMOM/uml"
    printUrl "sequenceDiagram.png" "me/$KMOM/uml"
}


#
# test http://dbwebb.se/
#
#cp -ri me/kmom02/deck/*.py me/kmom02/test/
#touch me/kmom02/test/test_deck.py
#test -d me/kmom02/test
#dbwebb validate test



#
# Test kmom
#
function oopythonkmom03()
{
    :
}



#
# Test kmom
#
function oopythonkmom04()
{
    :
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
