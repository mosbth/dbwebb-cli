# --------------- DBWEBB REPO FUNCTIONS PHASE START ---------------

#
# Clone a remote repos
#
reposClone()
{
    local repo="$1"
    local repos=(python javascript1 linux webapp htmlphp)

    if [ ! -d "$DBW_HOME" ]; then
        printf "\nYou have not set \$DBW_HOME nor do you have a directory \$HOME/$DBW_BASEDIR."
    else
        ok=0
        for i in ${repos[@]}; do
            if [ "$repo" == "${i}" ]; then
                
                ok=1
                if [ -d "$DBW_HOME/$repo" ]; then
                    printf "\n$MSG_FAILED to clone. There seem to exist a directory with this name already."
                    printf "\n"
                else
                    cmd="$GIT clone https://github.com/mosbth/$repo"
                    printf "\nCloning remote course repo and making a local installation."
                    printf "\nMoving to '$DBW_HOME'"
                    printf "\n$cmd"
                    cd "$DBW_HOME"
                    $cmd
                fi
            fi
        done

        if [ $ok -eq 0 ]; then
            printf "\n$MSG_FAILED to clone remote repo, unknown repo '$repo'. Use '$DBW_EXECUTABLE repos' to get a list of supported repos."
            printf "\n"
            dbwebb2PrintShortUsage
        fi
    fi
}



#
# ls $DBWEBB_HOME
#
function dbwebb-ls()
{
    if [ -d "$DBW_HOME" ]; then
        cd "$DBW_HOME"
        printf $( pwd )
        printf "\n"
        ls -lF
    else 
        printf "\nYou have not set \$DBWEBB_HOME nor do you have a directory \$HOME/$DBW_BASEDIR."
    fi
    printf "\n"
}



#
# List all available remote repos
#
function dbwebb-repo()
{
    printf "\nThe following remote course repos are supported."
    printf "\n"
    printf "\n python       https://github.com/mosbth/python"
    printf "\n javascript1  https://github.com/mosbth/javascript1"
    printf "\n linux        https://github.com/mosbth/linux"
    printf "\n webapp       https://github.com/mosbth/webapp"
    printf "\n htmlphp      https://github.com/mosbth/htmlphp"
    printf "\n"
    printf "\n"
}



# --------------- DBWEBB REPO FUNCTIONS PHASE END ---------------
