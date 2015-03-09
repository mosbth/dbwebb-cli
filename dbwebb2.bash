# --------------- DBWEBB MAIN START HERE ---------------

#
# TODO CLEAN UP THESE
# Get options
#
SKIP_READLINE="no"



#
# Process options
#
while (( $# ))
do
    case "$1" in
        
        --inspect | -i)
            inspectUsage
            exit 0
        ;;

        --verbose | -v)
            VERY_VERBOSE="yes"
            shift
        ;;

        --yes | -y)
            SKIP_READLINE="yes"
            shift
        ;;

        --help | -h)
            usage
            exit 0
        ;;
        
        --version)
            version
            exit 0
        ;;
                
#        clone)
#            if [ -z "$2" ]; then
#                $ECHO "\n$MSG_FAILED missing argument for repo name."
#                $ECHO "\n"
#                dbwebb2PrintShortUsage
#                exit 1
#            fi
#            reposClone "$2"
#            exit 0
#        ;;

#        selfupdate|self-update)
#            selfUpdate
#            exit 0
#        ;;

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

        update         \
        | check        \
        | config       \
        | updateconfig \
        | selfupdate   \
        | sshkey       \
        | login        \
        | upload       \
        | download     \
        | validate     \
        | publish      \
        | init         \
        | init-server  \
        | init-me)
            command=$1
            shift
            dbwebb-$command $*
            exit 0
        ;;
        
        *)
            badUsage "$MSG_FAILED Option/command not recognized."
            exit 2
        ;;
        
    esac
done

badUsage
exit 1
