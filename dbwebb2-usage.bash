function usage ()
{
    local txt=(
"Utility dbwebb for working with course repos: http://dbwebb.se/dbwebb-cli"
"Usage: dbwebb [options] <command> [arguments]"
""
"Command:"
"  check              Check the environment."
"  config             (Re-)Create config file."
"  selfupdate         Update to latest version."
"  sshkey             Create and install ssh-keys."
"  login              Login to the remote server."
"  clone [repo]       Clone a course repo."
"  init               Init course repo and remote server."
"  github [repo]      Get urls to repo on GitHub."
"  update             Update course repo."
"  upload [part]      Upload to server."
"  download [part]    Download from server."
"  create labid       Create a lab."
"  recreate labid     Re-create environment for a lab."
"  validate [part]    Validate it."
"  publish [part]     Publish it."
"  publishfast [part] Publish without validation."
"  publishpure [part] Publish without minification."
"  inspect [course] [kmom] [user]  Inspect a kmom."
"  run <command>      Run a command on remote host."
"  testrepo           Automated tests of a course repo."
""
"Options:"
"  --inspect, -i  Help for inspect."
"  --verbose, -v  More verbose."
"  --silent, -s   Less verbose output."
"  --force, -f    Force upload/download of files, overwrite existing."
"  --local, -l    Only local tests in command testrepo."
"  --host         Host to connect to (supported by run)."
"  --cwd          Working dir for command (supported by run)."
"  --dry          Dry run (supported by validate/publish)."
"  --help, -h     Print help."
"  --version      Print version."
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
    
    if [[ "$message" ]]; then
        printf "$message\n"
    fi
    
    printf "%s\n" "${txt[@]}"
}



function usageGithub ()
{
    local txt=(
"Available course repos are: $( join , "${DBW_COURSE_REPOS[@]}" )"
"Usage: dbwebb github [course repo]"
""
"The repo 'dbwebb-cli' exists on GitHub."
"Repo:   $( createGithubUrl "$DBW_REPO" )"
"Issues: $( createGithubUrl "$DBW_REPO" "/issues" )"
)
    printf "%s\n" "${txt[@]}"
}



function badUsageGithub ()
{
    local message="$1"

    if [[ "$message" ]]; then
        printf "$message\n"
    fi
    
    usageGithub
}


function usageClone ()
{
    local txt=(
"Available course repos are: $( join , "${DBW_COURSE_REPOS[@]}" )"
"Usage: dbwebb clone [course repo]"
"Read more: http://dbwebb.se/dbwebb-cli/clone"
)
    printf "%s\n" "${txt[@]}"
}



function badUsageClone ()
{
    local message="$1"

    if [[ "$message" ]]; then
        printf "$message\n"
    fi
    
    usageClone
}



function usageInspect ()
{
    local txt=(
"dbwebb inspect:"
"Use to inspect a kmom, as the teachers does, self inspect your own kmom before handing it in."
""
"Usage: dbwebb inspect <kmom>"
"Use to self inspect a kmom in current course repo. This will also upload all your files to the remote server to ensure you are checking the latest code."
""
"Usage: dbwebb inspect <course> <kmom>"
"Use to inspect a kmom in any course repo that is uploaded to the remote server. No need of being in a valid course repo. No upload of files."
""
"Usage: dbwebb inspect <course> <kmom> <user>"
"Use to inspect a kmom in any course for any user, without the need of being in a valid course repo. No upload of files."
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



function inspectUsage ()
{
    local txt=(
"Using dbwebb inspect, for another student than youreself,"
"needs extra privilegies."
""
"Add acronym for inspect"
" sudo /usr/local/sbin/setpre-dbwebb-kurser.bash acronym"
""
"or add as an alias in your .cshrc"
" dbwebb run echo 'alias potatoe \"sudo setpre-dbwebb-kurser.bash\"' >> .cshrc"
""
"and then run as this:"
" dbwebb run potatoe akronym"
""
"Add or delete teacher (on each server)"
" sudo update-dbwebb-kurser.bash -a acronym"
" sudo update-dbwebb-kurser.bash -d acronym"
""
"Change owner to mosstud of all files in the archive"
" sudo /usr/local/sbin/setowner-on-dbwebb-archive.bash"
""
"Add --yes to answer yes/default answer to all questions."
""
" Add --port port, -p port to execute external servers on this port."
""
"Add --useVersion 1 to use a specific version of the course. Useful when courses has several versions and same repo must be used for all versions."
""
"Execute command as the user dbwebb."
" sudo -u dbwebb script"
    )
    printf "%s\n" "${txt[@]}"
}
