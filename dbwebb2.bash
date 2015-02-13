# --------------- DBWEBB MAIN START HERE ---------------

#
# TODO Check how config-file is initiated
# Check if config file is up to date
#
updateConfigIfNeeded "update"



#
# TODO CLEAN UP THESE
# Get options
#
SKIP_READLINE="no"
IGNORE_FAULTS="-i"
VERY_VERBOSE="no"



#
# Process options
#
while (( $# ))
do
    case "$1" in
        
        --inspect | -i)
            printf %s "${inspectUsage[@]}"
            exit 0
        ;;

        --verbose | -v)
            VERY_VERBOSE="yes"
        ;;

        --yes | -y)
            SKIP_READLINE="yes"
        ;;

        --help | -h)
            printf %s "${usage[@]}"
            exit 0
        ;;
        
        --version)
            printf %s "${version[@]}"
            exit 0
        ;;
                
        clone)
            if [ -z "$2" ]; then
                $ECHO "\n$MSG_FAILED missing argument for repo name."
                $ECHO "\n"
                dbwebb2PrintShortUsage
                exit 1
            fi
            reposClone "$2"
            exit 0
        ;;

        selfupdate|self-update)
            selfUpdate
            exit 0
        ;;

#    init)
#        initServer
#        createDefaultFiles
#        #uploadToServer
#        ;;

        create)
            LAB="$2"
            if [ -z "$LAB" ]
            then
                echo "Missing name for lab, perhaps use lab1, lab2 or lab3?"
                exit 1
            fi
            createLab "$LAB"
            exit 0
        ;;

        publish)
            setChmod
            publishResults "$DBW_COURSE_DIR" "$DBW_REMOTE_DESTINATION" "$2"
            exit 0
        ;;

        inspect)
            WHICH=$2
            WHO=$3
            inspectResults ${WHICH:=all} ${WHO:=$USER}
            exit 0
        ;;

        update        \
        | check       \
        | config      \
        | ls          \
        | repo        \
        | sshkey      \
        | login       \
        | upload      \
        | download    \
        | validate    \
        | init-server \
        | init-me)
            command=$1
            shift
            dbwebb-$command $*
            exit 0
        ;;
        
        *)
            printf "$MSG_FAILED Option/command not recognized.\n\n"
            printf %s "${badUsage[@]}"
            exit 1
        ;;
        
    esac
done

printf %s "${badUsage[@]}"
exit 1
