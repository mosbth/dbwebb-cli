mapfile usage <<EOD
Utility dbwebb version $DBW_VERSION by Mikael Roos (mos@dbwebb.se), to work with dbwebb course repositories.

Usage: dbwebb [options] <command> [arguments]

Command:

  check             Check and print out details on the environment.
  config            Create, or re-create the config file.
  selfupdate        Update dbwebb-cli installation.
  sshkey            Create and install ssh-keys to avoid using password.
  login             Login to the remote server using ssh and sshkeys if available.
  init-server       Init the server by creating a directory structure on it.

Command (to manage course repos):

  ls                List all locally installed course repos within \$DBW_HOME.
  repo              List all supporoted remote course repos.
  clone repo-name   Clone and locally install a remote course repo.

Command (for a valid course repo):

  init-me           Init the directory me/ by copying files and directories from default/.
  update            Update the courserepo with latest updates from the master repo.
  upload [part]     Upload current directory to the the server.
  download [part]   Download current directory from the server (overwrite all files, be careful).
  create labid      Create a laboration, use additional argument for naming what lab to create.
  validate [part]   Validate (and upload) your files using the remote server.
  publish [part]    Upload, Validate and Publish your course results to the web.
  inspect kmom [user]   Inspect a kmom for yourself or a specific user, needs teacher privilegies
                        to check another students kmom.

Options:

  -i, --inspect  Prints help with commands for inspect.
  -v, --verbose  Verbose, print out what's happening.
  -y, --yes      Do not wait for my input, just proceed.
  -h, --help     Print this message and exit.
  --version      Print version and exit.
  
EOD



mapfile version <<EOD
dbwebb version $DBW_VERSION

EOD



mapfile badUsage <<EOD
For an overview of the command, execute:
dbwebb --help

EOD



mapfile inspectUsage <<EOD
Commands useful at the server with respect to dbwebb inspect, needs extra privilegies.

Open up for inspect by setting group and chmod for directories and files.
sudo /usr/local/sbin/setpre-dbwebb-kurser.bash acronym

Add or delete as member of the dbwebb-group (execute on all servers)
sudo update-dbwebb-kurser.bash -a acronym
sudo update-dbwebb-kurser.bash -d acronym

Execute command as the user dbwebb.
sudo -u dbwebb script

EOD
