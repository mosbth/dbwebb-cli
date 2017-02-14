#---------------------------- INSPECT linux START --------------------------
#
# Test general
#
function linux()
{
    inspectIntro
}



#
# Test general, last in sequence
#
function linuxlast()
{
    inspectMe "me/redovisa" "me.html" "report.html" "" "redovisa"
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
# Create and run bash-script
#
linuxExerciseCommands()
{
    local target="me/$KMOM/$1"
    local where="$EXEC_DIR/$KMOM/$1"
    local main="commands"

    # Options
    opts="--help"
    args=""
    inspectCommand "$main" "$where" "./$main $opts $args" "$opts $args"

    opts="--version"
    args=""
    inspectCommand "$main" "$where" "./$main $opts $args" "$opts $args"

    # Run it
    opts=""
    args="reverse Obi-Wan Kenobi"
    inspectCommand "$main" "$where" "./$main $opts $args" "$opts $args"

    opts=""
    args="factors 5 6 16"
    inspectCommand "$main" "$where" "./$main $opts $args" "$opts $args"
}



#
# View files in irc exercise
# OBSOLETE v1
linuxExerciseIrc()
{
    local target="me/$KMOM/$1"
    
    pushd "$THEDIR/$target"
    for file in ?.txt; do
        viewFileContent "$file" "$target"
    done
    popd
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
    if [ "$USE_VERSION" = "1" ]; then
        inspectExercise "mysite" "uppgift/strukturera-filer-kataloger-och-rattigheter-i-en-webbplats" "log.txt" "mysite.linux.se.conf" "dump.png"

        inspectExercise "vhost" "uppgift/skapa-en-webbplats-pa-en-apache-virtual-host" "log.txt" "me.linux.se.conf" "dump.png"

        return
    fi

    inspectLab "uppgift/linux-lab-1-introduktion-till-bash" "bash1" "answer.bash" "./answer.bash"

    inspectExercise "vhost" "uppgift/skapa-en-webbplats-pa-en-apache-virtual-host" "log.txt" "me.linux.se.conf" "dump.png"
}



#
# Test kmom03
#
function linuxkmom03()
{
    if [ "$USE_VERSION" = "1" ]; then
        inspectExercise "irc" "uppgift/hitta-saker-i-en-loggfil-med-unix-kommandon" "log.txt" "solutions.bash" "" "" "solutions.bash" "bash solutions.bash"

        linuxExerciseIrc "irc"
        
        inspectExercise "script" "uppgift/mina-forsta-bash-script"
        linuxExerciseScript "script"

        return
    fi

    inspectLab "uppgift/linux-lab-2-sok-i-en-logg-fil" "bash2" "answer.bash" "./answer.bash"

    inspectExercise "script" "uppgift/mina-forsta-bash-script"
    linuxExerciseScript "script"

    inspectExercise "commands" "uppgift/ett-bash-script-med-options-command-arguments"
    linuxExerciseCommands "commands"
}



#
# Test kmom04
#
function linuxkmom04()
{
    if [ "$USE_VERSION" = "1" ]; then
        inspectExercise "javascripting" "uppgift/utfor-nodeschool-workshopen-javascripting" "" "" "" "" "" ""

        inspectExercise "server" "uppgift/skapa-en-restful-http-server-med-node-js-och-klient-i-bash" "index.js" "server.js" "" "" "" "" "" "" " (del 1 servern)"

        inspectExercise "server" "uppgift/skapa-en-restful-http-server-med-node-js-och-klient-i-bash" "client.bash" "" "" "" "" "" "" "" " (del 2 klienten)"

        return
    fi

    inspectLab "uppgift/linux-lab3-introduktion-till-nodejs" "node1" "answer.js" "babel-node answer.js"

    # Prepare
    inspectExerciseHeader "Server i node och klient i bash" "uppgift/skapa-en-restful-http-server-med-node-js-och-klient-i-bash" "$KMOM/server"

    # Start the server
    #local target="me/$KMOM/server"
    local target="$KMOM/server"
    fileIsReadable "me/$target/index.js"
    fileIsReadable "me/$target/server.js"
    runServer "index.js" "$EXEC_DIR/$target" "babel-node index.js"

    # Execute the client
    fileIsReadable "me/$KMOM/server/client.bash"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash hello"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash html"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash status"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash sum 2 3 4"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash filter 2 3 42 99"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash 404"
    inspectCommand "client.bash" "$EXEC_DIR/$target" "bash client.bash all"

    # Close it up
    killServer "$EXEC_DIR/$target"
}



#
# Test kmom
#
function linuxkmom05()
{
    # http://dbwebb.se/uppgift/los-mazen-med-din-mazerunner-i-bash
    # mazerunner.sh mazerunner.bash
    test
}



#
# Test kmom
#
function linuxkmom06()
{
    #http://dbwebb.se/uppgift/skapa-klienter-och-servrar-som-spelar-luffarschack-i-node-js
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
