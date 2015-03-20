# --------------- DBWEBB MAIN START HERE ---------------

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
                
        #--course)
        #    DBW_COURSE=$2
        #    shift
        #    shift
        #;;
                
        update         \
        | check        \
        | clone        \
        | config       \
        | updateconfig \
        | selfupdate   \
        | sshkey       \
        | login        \
        | upload       \
        | download     \
        | validate     \
        | publish      \
        | inspect      \
        | create       \
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
