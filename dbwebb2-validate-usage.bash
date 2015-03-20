function usage ()
{
    local txt=(
"Utility dbwebb-validate for working with course repos: http://dbwebb.se/dbwebb-validate"
"Usage: dbwebb-validate [options] [item]"
""
"Item:"
"  Any of the exercises for a course, example:"
"  - kmom01, kmom02, ..., kmom10"
"  - me, tutorial, example"
"  or relative path,"
"  or absolute path"
""
"Options:"
"  --check, -c         Check installed tools."
"  --selfupdate        Update to latest version."
"  --dry, -d           Dry run, only display."
"  --only extension    Only test for extension."
"  --course-repo path  Use this path as course repo."
"  --publish, -p       Publish it."
"  --publish-to path   Path where to publish."
"  --help, -h          Print help."
"  --version, -v       Print version."
    )
    printf "%s\n" "${txt[@]}"
}



function version ()
{
    local txt=(
"dbwebb-validate version $DBW_VERSION"
    )
    printf "%s\n" "${txt[@]}"
}



function badUsage ()
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"dbwebb-validate --help"
    )
    
    if [ ! -z "$message" ]; then
        printf "$message\n"
    fi
    
    printf "%s\n" "${txt[@]}"
}
