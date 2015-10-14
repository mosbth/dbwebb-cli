Command-line utility `dbwebb` to work with course repositories
============================================================

Part of course repos as a admin utility.



History
-------------------

v1.9.17x (2015-10-14)

* Inspect support alternate place for file view content.
* Adding tasks for linux kmom10.
* Adding tasks for htmlphp kmom10.
* Adding task webgl sandbox2.


v1.9.17 (2015-10-08)

* Adding `purepublish`, acting as `fastpublish` but without minifying.
* Added webgl with support or all assignments.
* Fastpublish is always with --yes.
* First test with bash completion.
* `.txt` is not readonly on publish, only `log.txt`.
* Exclude `-not -path '*/jquery/*'` from validation & publish.


v1.9.16 (2015-10-01)

* Correcting `fastpublish`.


v1.9.15 (2015-10-01)

* Publish setting correct permissions for sqlite, sql files and db directory.
* Excluding 'phpliteadmin.php' from validation phase.
* Added option `--no-validate` to dbwebb-validate and command `fastpublish` to dbwebb.
* Adding course oophp.
* Adding solution as target for dbwebb validate.
* Adding linux gomoku and javascript1 baddie4.
* Inspect failed on viewing content of file, fix.
* Changing linux vhosts to vhost.


v1.9.14 (2015-09-04)

* Adding tree for all inspect.
* Rework of inspects for all courses.
* Adding inspect for htmlphp kmom01 - kmom10, not complete yet.
* Adding inspect for linux kmom01 - kmom03.
* Chmod to unreadable files `*.txt` and `*.bash` when publish.
* Exclude SC2002 from shellcheck.


v1.9.13 (2015-09-03)

* Adding option `-f, --force` to upload, validate and publish to force upload and overwrite of all files.
* Replacing `--delete` with `--force`.


v1.9.12 (2015-09-03)

* Fixing permissions on files and dirs from Cygwin since chmod does not work.
* Added option --delete for download to make an exact copy of the remote.
* Added support for linux kmom05/maze.


v1.9.11 (2015-09-01)

* Correcting chmod for python cgi-scripts on publish.
* Change order of options for dbwebb publish and uglifyjs to work.
* Add dots when doing publish to track progress.
* Added support for htmlphp/kmom06/me6.


v1.9.10 (2015-08-25)

* Generate default ssh-keys instead of DSA-keys.
* Fixing installation script for Mac OS.


v1.9.9 (2015-08-24)

* Removing sudo from installation script.
* htmlphp inspect for report.php, not redovisning.php.


v1.9.8 (2015-08-17)

* Correcting dbwebb download, gave error message.
* Adding inspect for linux, webapp, webgl.
* Updating inspect for htmlphp.
* Inspect doing archive to subdirectory for each course and should preserve group ownership.
* When updating leave configfile as is, use current settings as default settings.
* When mapping paths to directories, only acknowledge preconfigured items, #53.


v1.9.7 (2015-08.06)

* Adjusting install phase and documentation.
* Enable to run selfupdate using sudo.
* Ignore some files when upload config and rc-files.


v1.9.6 (2015-08-05)

* Always upload config and rc-files when validate and publish, fix #47.
* Adding progressbar for validating since jscs and jshint was really slow.
* Replaced own htmlhint with actual htmlhint, took care of exit values. 
* Changed init-phase to rsync directory structure, fix #51.
* Adding install script, fix #52.
* Corrected curl to work when wget is not available.
* Removed unused variables pointing to commands.
* Init now includes upload, fix #49.
* Upload ignore literature and tutorial, fix #48.
* Newline before url in publish, fix #35.
* Do not validate/publish files in directories named `*/node_modules/*`.


v1.9.5 (2015-06-17)

* Corrected jscs output for linux.


v1.9.4 (2015-05-20)

* Teacher can download sourcecode from student, fix #46.
* Log also stderr during inspect, fix #42.
* Link to repo on GitHub, fix #41.
* Inspect archive only if another user.


v1.9.3 (2015-04-15)

* Adding github command, fix #39.


v1.9.2 (2015-03-23)

* Inspect working on local files, no copy.
* Inspect syncing essentials files on copy.
* Correcting inspection for javascript1.


v1.9.0 (2015-03-23)

* Updating dbwebb version 2, alpha release.


v1.1.1 (2015-01-26)

* Updated inspect for python.
* Support space in username for sshkeys.


v1.1.0 (2015-01-14)

* Support kmom10 in python & javascript1.
* Adding javascript kmom05 lab5 and removing baddie4 and baddie5.
* Enhanced debugging in dbwebb-inspect.
* Fixed issue #8, #9, #10, #11.
* Adding dbwebb2 as development of new major version of dbwebb.
* Echo hostname at inspect.
* rsync use "" around the paths.
* Changed place to ignore upload of me/ when checking another user.
* Publish python cgi with correct chmod.


v1.0.14 (2014-09-30)

* Added publish to all kmoms.
* Support for testing game in python
* Added inspect for python kmom05.


v1.0.13 (2014-09-30)

* Fixed issue #7 to publish a students kmom on the web - as part of inspect.
* Inspect javascript1 kmom01 - 04 added.
* Inspect plane.py failed when windows style line endings.


v1.0.12 (2014-09-23)

* Added `bin/dbwebb inspect` that runs tests on a kmom for yourself or selected student.
* Added tests for python kmom01-04.


v1.0.11 (2014-09-12)

* `bin/dbwebb upload` now changes mod on files and directories before uploading.
* `bin/dbwebb init` does NOT upload to server per default (preparing to improve `download`).
* `dbwebb-config-sample` to allow directory names with spaces.
* Minor spelling errors.


v1.0.10 (2014-09-08)

* v1.0.9 introduced a problem with validate. Fixed.


v1.0.9 (2014-09-08)

* `dbwebb-validate` changes chmod to make all dirs and files readable since cygwin may set 000 as rights (for some yet unknown reason).


v1.0.8 (2014-09-05)
v1.0.7 (2014-09-05)
v1.0.6 (2014-09-05)

* readlink -f fails on Mac.


v1.0.5 (2014-09-05)

* Find name of Users group on Cygwin in swedish installations.


v1.0.4 (2014-09-05)

* Failed detecting if curl or wget was available.


v1.0.3 (2014-09-05)

* Support for curl where wget is not available (Mac).
* `bin/dbwebb init` now does upload to server again.


v1.0.2 (2014-09-05)

* Check for autoupdate `.dbwebb.config` on `bin/dbwebb update`.
* Adding command `version` to display version of `bin/dbwebb` and latest commit to course repo.
* Adding file for version number `bin/.dbwebb.version`.
* Re-using user as default value when recreating config-file.
* Autocreating config-file when version number is changed.
* Now its own repo.


v1.0.1 (2014-09-03)

* Require change of configuration file.
* Gets extra information when creating labs as a tar archive.
* `bin/dbwebb init` does not upload to server.
* Avoid python labs to overwrite an existing lab.


v1.0.0 (2014-08-30)

* First official release, used in a University course at BTH, Sweden.
* Started work in april 2014, planned release end of august 2014.



```
 .
..:  Copyright (c) 2014-2015 Mikael Roos, mos@dbwebb.se
```
