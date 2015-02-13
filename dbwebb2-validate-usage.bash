mapfile usage <<EOD
Utility dbwebb-validate version $DBW_VERSION by Mikael Roos (mos@dbwebb.se), to work with dbwebb course repositories.

Usage: dbwebb-validate [options] [item]

Item:

  Any of the supporter exercises for each course, for example:
  - kmom01, kmom02, kmom03, kmom04, kmom05, kmom06, kmom10
  - me, tutorial, example
  or a relative path,
  or a absolute path

Options:

  -c, --check    Check environment for installed tools.
  -p, --publish  Publish, otherwise only validate.
  -s, --silent   Silent, limited output.
  -h, --help     Print this message and exit.
  -v, --version  Print version and exit.
  
EOD



mapfile version <<EOD
dbwebb-validate version $DBW_VERSION

EOD



mapfile badUsage <<EOD
For an overview of the command, execute:
dbwebb-validate --help

EOD
