function usage ()
{
    local txt=(
"Usage: dbwebb [options] <command> [arguments]"
""
"Command:"
"  check        Check the environment."
"  config       (Re-)Create config file."
"  selfupdate   Update to latest version."
"  sshkey       Create and install ssh-keys."
"  login        Login to the remote server."
"  init         Init course repo and remote server."
"  update       Update course repo."
"  upload [part]     Upload to server."
"  download [part]   Download from server."
"  create labid      Create a lab."
"  validate [part]   Validate it."
"  publish [part]    Publish it."
"  inspect [kmom] [user]   Inspect a kmom."
""
"Options:"
"  -i, --inspect  Help for inspect."
"  -v, --verbose  More verbose."
"  -y, --yes      Do not wait for my input."
"  -h, --help     Print help."
"  --version      Print version."
""
"Manual at: http://dbwebb.se/dbwebb-cli"
    )
    printf "%s\n" "${txt[@]}"
}



function version ()
{
    local txt=(
"dbwebb version $DBW_VERSION"
    )
    printf "%s\n" "${txt[@]}"
}



function badUsage ()
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"dbwebb --help"
    )
    
    if [ ! -z "$message" ]; then
        printf "$message\n"
    fi
    
    printf "%s\n" "${txt[@]}"
}



function inspectUsage ()
{
    local txt=(
"Using dbwebb inspect, for another student than youreself,"
"needs extra privilegies."
""
"Add acronym for inspect"
" sudo /usr/local/sbin/setpre-dbwebb-kurser.bash acronym"
""
"Add or delete teacher (on each server)"
" sudo update-dbwebb-kurser.bash -a acronym"
" sudo update-dbwebb-kurser.bash -d acronym"
""
"Execute command as the user dbwebb."
" sudo -u dbwebb script"
    )
    printf "%s\n" "${txt[@]}"
}
