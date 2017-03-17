#---------------------------- INSPECT webapp START --------------------------
#
# Test general
#
function webapp()
{
    inspectIntro
}



#
# Test general, last in sequence
#
function webapplast()
{
    inspectMe "me/redovisa" "" "" "" "redovisa"
}



#
#
# Test kmom01
#
function webappkmom01()
{
    :
}



#
# Test kmom02
#
function webappkmom02()
{
    inspectExerciseHeader "jq" "uppgift/sokverktyg-for-json-filer" "$KMOM/jq"
    inspectCommand "solution.bash" "$THEDIR/me/$KMOM/jq" "./solution.bash"
}



#
# Test kmom03
#
function webappkmom03()
{
    :
}



#
# Test kmom04
#
function webappkmom04()
{
    :
}



#
# Test kmom
#
function webappkmom05()
{
    :
}



#
# Test kmom
#
function webappkmom06()
{
    :
}



#
# Test kmom
#
function webappkmom10()
{
    :
}



#---------------------------- INSPECT webapp END ----------------------------
