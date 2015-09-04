#---------------------------- INSPECT linux START --------------------------
#
# Test general
#
function linux()
{
    inspectIntro
    inspectMe "me/redovisa" "me.html" "report.html"
}



#
# Test script exercise
#
linuxExerciseScript()
{
    local target="me/$KMOM/$1"
    
    inspectCommand "hello.bash" "$THEDIR/$target" "bash hello.bash"
    viewFileContent "hello.bash" "$target"

    inspectCommand "argument.bash" "$THEDIR/$target" "bash argument.bash make-me-proud"
    viewFileContent "argument.bash" "$target"

    inspectCommand "if_1.bash" "$THEDIR/$target" "bash if_1.bash 7"
    inspectCommand "if_1.bash" "$THEDIR/$target" "bash if_1.bash 5"
    inspectCommand "if_1.bash" "$THEDIR/$target" "bash if_1.bash 3"
    viewFileContent "if_1.bash" "$target"

    inspectCommand "if_2.bash" "$THEDIR/$target" "bash if_2.bash 7"
    inspectCommand "if_2.bash" "$THEDIR/$target" "bash if_2.bash 5"
    inspectCommand "if_2.bash" "$THEDIR/$target" "bash if_2.bash 3"
    viewFileContent "if_2.bash" "$target"

    inspectCommand "argument_2.bash" "$THEDIR/$target" "bash argument_2.bash d"
    inspectCommand "argument_2.bash" "$THEDIR/$target" "bash argument_2.bash n"
    inspectCommand "argument_2.bash" "$THEDIR/$target" "bash argument_2.bash a second-argument"
    viewFileContent "argument_2.bash" "$target"

    inspectCommand "forloop.bash" "$THEDIR/$target" "bash forloop.bash"
    viewFileContent "forloop.bash" "$target"

    inspectCommand "myFunction.bash" "$THEDIR/$target" "bash myFunction.bash"
    viewFileContent "myFunction.bash" "$target"
}



#
# Test kmom01
#
function linuxkmom01()
{
    inspectExercise "install" "uppgift/installera-debian-som-server" "log.txt" "" "ssh.png"
}



#
# Test kmom02
#
function linuxkmom02()
{
    inspectExercise "vhost" "uppgift/skapa-en-webbplats-pa-en-apache-virtual-host" "log.txt" "me.linux.se.conf" "dump.png"

    inspectExercise "mysite" "uppgift/strukturera-filer-kataloger-och-rattigheter-i-en-webbplats" "log.txt" "mysite.linux.se.conf" "dump.png"
}



#
# Test kmom03
#
function linuxkmom03()
{
    inspectExercise "irc" "uppgift/hitta-saker-i-en-loggfil-med-unix-kommandon" "log.txt" "solutions.bash" "" "" "solutions.bash" "bash solutions.bash" "" "more ?.txt"

    inspectExercise "script" "uppgift/mina-forsta-bash-script"
    linuxExerciseScript "script"
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
