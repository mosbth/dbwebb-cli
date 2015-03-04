function usage ()
{
    local txt=(
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
"  -c, --check    Check installed tools."
"  -p, --publish  Publish it."
"  -h, --help     Print help."
"  -v, --version  Print version."
""
"Manual at: http://dbwebb.se/dbwebb-cli"
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
