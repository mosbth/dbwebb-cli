Revision History
============================================================


v2.0.7 (2017-06-29)
-------------------

* Adding eslint as validation tool, to replace jshint.


v2.0.6 (2017-06-22)
-------------------

* Fix remove error message popd from dbwebb-validate.


v2.0.5 (2017-06-15)
-------------------

* Enable to inspect source from course repo.


v2.0.4 (2017-06-14)
-------------------

* Move upload include and exclude files to .dbwebb.
* Fix dbwebb2-inspect1 on ssh.student.


v2.0.3 (2017-06-12)
v2.0.2 (2017-06-12)
-------------------

* Fix mapCmdToDir when below subdir.


v2.0.1 (2017-06-12)
-------------------

* Validate and publish specific course moment now backward compatible, checking existing dirs.


v2.0.0 (2017-06-09)
-------------------

* Enable to create different versions of the labs.
* Move course repo .dbwebb.version to .dbwebb/cli.version.
* Cleanup mapCmdToDir and remove hardcoded python paths.
* Add extra option to selfupdate [version] to downgrade to specified release.
* Add releases to upgrade/downgrade to.


v1.9.104 (2017-05-31)
-------------------

* Added option -s n to pylint validator.


v1.9.103 (2017-05-31)
-------------------

* Updated installation script for usability.


v1.9.102 (2017-04-25)
-------------------

* Download even though newer file exists locally.


v1.9.101 (2017-04-19)
-------------------

* Use temporary dbwebb-validate1 for both validate and publish.


v1.9.100 (2017-04-19)
-------------------

* Fix path dbwebb validate to really exclude file from included subdir using -- in .dbwebb/validate.exclude.


v1.9.99 (2017-04-13)
-------------------

* Fix path for dbwebb publish to exclude files from .dbwebb/validate.exclude.


v1.9.98 (2017-04-05)
-------------------

* Fix init dbwebb-include support space in filename.
* Fix clashing kmom03/jq versus kmom02/jq in webapp.


v1.9.97 (2017-04-04)
-------------------

* Add repo tests on oophp.


v1.9.96 (2017-04-03)
-------------------

* Fix how publish interprets paths.


v1.9.95 (2017-04-03)
-------------------

* Use absolute path when publish --publish-to.


v1.9.94 (2017-04-03)
-------------------

* Fix path to dbwebb-validate.


v1.9.93 (2017-04-03)
-------------------

* dbwebb validate/publish --courserepo must use absolut path.
* Adding --dry to enable dry option to validate/publish from using dbwebb --dry.


v1.9.92 (2017-04-03)
-------------------

* Added .dbwebb/validate.exclude for improving how validate/publish excludes/includes files and move configuration from dbwebb-cli to courserepo.
* Corrected get_realpath to work with both dirs and files.
* Rewrote basis for find expression in dbwebb validate.
* Download does not use dbwebb.include or dbwebb.exclude.


v1.9.91 (2017-03-23)
-------------------

* Added parts to dbjs inspect kmom04.


v1.9.90 (2017-03-22)
-------------------

* Included .dbwebb.include and .dbwebb.exclude2 for dbwebb init.


v1.9.89 (2017-03-17)
v1.9.88 (2017-03-17)
-------------------

* Included .dbwebb.include and .dbwebb.exclude2.
* Inspect updates to dbjs, webapp and oophp.


v1.9.87 (2017-03-14)
-------------------

* Corrected get_realpath.


v1.9.86 (2017-03-14)
-------------------

* Function get_realpath to replace readlink -f in inspect.


v1.9.85 (2017-03-13)
-------------------

* Formatted output for dbwebb-validate --check.
* Removed unuused phpuglify.


v1.9.84 (2017-03-13)
-------------------

* Added version for dbwebb, dbwebb-validate and dbwebb-inspect in dbwebb-validate --check.


v1.9.83 (2017-02-24)
-------------------

* Enhanced inspect for linux kmom05.


v1.9.82 (2017-02-23)
-------------------

* Inspect for dbjs kmom03.
* Inspect for oopython kmom05, kmom06.
* Enhanced inspect for linux kmom05 and 06.


v1.9.81 (2017-02-16)
-------------------

* Fix create config with empty username in tests.


v1.9.80 (2017-02-14)
-------------------

* Remove option --s1 and--skip-import (--inline none) from upgraded clean-css.


v1.9.79 (2017-02-14)
-------------------

* Assert for missing pid-file.
* Change whats done during init.


v1.9.78 (2017-02-14)
-------------------

* Always publish whole repo, to be able to include/exclude files.
* Validate and publish did two rsync, removed the second one.
* Inspect oopython kmom04 checking for allocated port.
* Find correct pid-file when killing server.


v1.9.77 (2017-02-11)
-------------------

* Inspect oopython kmom04 spelling of sqlite file.
* Fix printf codestyle in assert().


v1.9.76 (2017-02-06)
-------------------

* View file in oopython kmom02 inspect.


v1.9.75 (2017-02-06)
-------------------

* Upgrade htmlhint from 0.9.12.
* Remove dbwebb-validate install tools.


v1.9.74 (2017-02-06)
-------------------

* Add blackjack for inspect oopython kmom03.


v1.9.73 (2017-02-03)
-------------------

* Inspect for oopython kmom04.
* Inspect for linux kmom04.


v1.9.72 (2017-01-30)
-------------------

* Changed my_data.py to data.py in inspect oopython kmom03.


v1.9.70 (2017-01-24)
-------------------

* Inspect for oopython kmom03.
* Inspect for linux kmom03.


v1.9.69 (2017-01-17)
-------------------

* Change all .py-files to go+r in oopython.
* Inspect for oopython kmom02.


v1.9.68 (2017-01-16)
-------------------

* Inspect for dbjs and linux kmom02.


v1.9.67 (2017-01-13)
-------------------

* Publish and chmod 644 all files having.py in my_app directory.


v1.9.66 (2017-01-10)
-------------------

* Publish and chmod 644 all files having.py in flask directory.


v1.9.65 (2017-01-06)
-------------------

* Inspect for dbjs, linux and oopython kmom01.


v1.9.64 (2016-12-22)
-------------------

* Shellcheck exclude SC1091.


v1.9.63 (2016-12-21)
-------------------

* dbwebb-validate check for babel and babel-node versions.


v1.9.62 (2016-12-19)
-------------------

* Change base url to Github dbwebb-se organisation.


v1.9.61 (2016-12-19)
-------------------

* Adding repo for course dbjs.


v1.9.59 (2016-10-07)
-------------------

* Inspect version number of git repo supporting 1.0.0 and v1.0.0.


v1.9.57 (2016-09-27)
-------------------

* Add link to manual.
* Add lab sql1 to inspect htmlphp.


v1.9.56 (2016-09-13)
-------------------

* Ignore `/slide` in dbwebb-validate.


v1.9.55 (2016-08-29)
-------------------

* Fix upload failed due to space in filenames.


v1.9.53 (2016-08-19)
-------------------

* Ignore \*/css/anax-grid/\* \*/me/anax-flat/\* \*/cache/\* \*/build/\* \*/.git/\* validation (repo design).


v1.9.52 (2016-08-18)
-------------------

* Ignore font-awesome.css, lessc.inc.php and \*/css/anax-grid/\* during validation (repo phpmvc).


v1.9.51 (2016-08-17)
-------------------

* Ignore example/lekplats when validate, for repo javascript.


v1.9.50 (2016-06-08)
-------------------

* Adding initial inspect routine for course design.


v1.9.49 (2016-06-08)
-------------------

* Add .dbwebb.exclude with list of files to exclude from upload.
* Add .dbwebb.include with list of files to include in upload.


v1.9.48 (2016-05-25)
-------------------

* The .dbwebb.map did only work in base directory, fix #79.
* Add python3 and pip3 version to be displayed in dbwebb-validate --check.


v1.9.47 (2016-05-16)
-------------------

* Rechange ssh -n again, avoid using it.
* Solved loop with filedescriptors that stopped working during dbwebb validate.


v1.9.46 (2016-05-16)
-------------------

* Improving dbwebb testrepo.


v1.9.45 (2016-05-16)
-------------------

* Correcting dbwebb inspect to work, re-change ssh -n option.


v1.9.44 (2016-05-16)
-------------------

* Added version info in dbwebb-validate check.



v1.9.43 (2016-05-16)
-------------------

* Improve error messages during selfupdate.



v1.9.42 (2016-05-16)
-------------------

* Support course repo having minimum requirement on dbwebb-cli version, .dbwebb.version.
* Add config file for moss, .dbwebb.moss.
* Add config file for subdirs in me, .dbwebb.map.



v1.9.41 (2016-05-13)
-------------------

* Adding to dbwebb-validate to install compatible npm modules needed. Useful for automating tests.



v1.9.40 (2016-05-13)
-------------------

* Added command to test course repos, testrepo.



v1.9.39 (2016-05-13)
-------------------

* Added command to recreate labs, dbwebb recreate lab1.



v1.9.38 (2016-05-12)
-------------------

* New way to create lab bundles, supported by lab v2.2.0.



v1.9.37 (2016-04-21)
-------------------

* Make anax-grid writable to allow style.php to work in phpmvc.


v1.9.36 (2016-04-06)
-------------------

* Do not upload dir with name coverage/.


v1.9.35 (2016-02-14)
-------------------

* Updated help text for teachers.


v1.9.32, 33, 34 (2016-02-05)
-------------------

* Another fix for #75...


v1.9.31 (2016-02-05)
-------------------

* Temporary fix to solve upgrades from v1.9.29 without destroying config-file for ssh key on mac/unix, #75.


v1.9.30 (2016-02-04)
-------------------

* Changed how the configfile is generating the path to the ssh key, #75.


v1.9.29 (2016-01-26)
-------------------

* Do not upload files like npm-debug.log, #74.
* dbwebb config should change baseurl when setting username, #71.


v1.9.28 (2016-01-15)
-------------------

* Ignore .tpl.php files for validation
* Exclude files related to Anax-MVC during validation.
* Validate work with filenames containing spaces.


v1.9.27 (2016-01-04)
-------------------

* Do not upload files in platforms/ directory.


v1.9.26 (2015-12-22)
v1.9.25 (2015-12-22)
-------------------

* Add validation tests for CRLF and BOM using `file`.


v1.9.24 (2015-12-22)
-------------------

* Exlude paths for Cordova during validation/publishing `*/platforms/*` and `*/plugins/*`.
* Make `*.sql` readable by all when publish.
* Make dirs named `cache/*` writable when publish.
* Fix inspect htmlphp kmom10.
* Support for phpmvc.
* Adding webapp kmom10/proj.
* Adding webapp kmom06/cordova.
* Enable to create oophp lab1.


v1.9.23 (2015-12-04)
-------------------

* Default is to skip press enter, fix #68.
* Speedup on cygwin by removing chmod, fix #69.
* Validate failed due to find expression, fix #64.
* dbwebb run with sudo commands on remote.
* webapp adding task pizza.
* webgl changed task game to world.
* Adding assignment webapp jq.
* Inspection of labs in webgl.


v1.9.22 (2015-11-18)
-------------------

* Validation of course webgl ignored, fixed.


v1.9.21 (2015-11-17)
-------------------

* htmlhint changed its output and broke validation, fixed.
* Rewrite find-expression and exclude path/names for validate and publish.
* Adding config file `.dbwebb-validate.config` for dbwebb-validate in course repo and in $HOME
* Wrong path to webgl kmom02/sandbox3.
* Do not validate/publish files named `*.min.*`.
* Do not upload `.solution` directory.
* Do not sync `.solution` and `.old` when upload for validate and publish.


v1.9.20 (2015-11-06)
-------------------

* Do not upload `slide` directory or dir named `old`.


v1.9.19 (2015-10-29)
-------------------

* Added inspect for phpmvc, javascript and oophp.
* Adding inspect for webapp kmom01 and kmom02.
* Exclude `*/lib/*` from validation and publishing tools.


v1.9.18 (2015-10-18)
-------------------

* Adding support for `run`, `--host` and `--cwd` to execute command on remote server.
* Support publishfast and publishpure as alias for purepublish and fastpublish.
* Add linux inspect kmom04.
* Publish make .sh-file readonly.
* Publish linux make js-files readonly instead of uglifyjs.
* Validate and publish ignore directories -not -path `*/libs/*`.
* Validate add support for jsonlint.
* Inspect support alternate place for file view content.
* Adding tasks for linux kmom10.
* Adding tasks for htmlphp kmom10.
* Adding task webgl sandbox2.


v1.9.17 (2015-10-08)
-------------------

* Adding `purepublish`, acting as `fastpublish` but without minifying.
* Added webgl with support or all assignments.
* Fastpublish is always with --yes.
* First test with bash completion.
* `.txt` is not readonly on publish, only `log.txt`.
* Exclude `-not -path '*/jquery/*'` from validation & publish.


v1.9.16 (2015-10-01)
-------------------

* Correcting `fastpublish`.


v1.9.15 (2015-10-01)
-------------------

* Publish setting correct permissions for sqlite, sql files and db directory.
* Excluding 'phpliteadmin.php' from validation phase.
* Added option `--no-validate` to dbwebb-validate and command `fastpublish` to dbwebb.
* Adding course oophp.
* Adding solution as target for dbwebb validate.
* Adding linux gomoku and javascript1 baddie4.
* Inspect failed on viewing content of file, fix.
* Changing linux vhosts to vhost.


v1.9.14 (2015-09-04)
-------------------

* Adding tree for all inspect.
* Rework of inspects for all courses.
* Adding inspect for htmlphp kmom01 - kmom10, not complete yet.
* Adding inspect for linux kmom01 - kmom03.
* Chmod to unreadable files `*.txt` and `*.bash` when publish.
* Exclude SC2002 from shellcheck.


v1.9.13 (2015-09-03)
-------------------

* Adding option `-f, --force` to upload, validate and publish to force upload and overwrite of all files.
* Replacing `--delete` with `--force`.


v1.9.12 (2015-09-03)
-------------------

* Fixing permissions on files and dirs from Cygwin since chmod does not work.
* Added option --delete for download to make an exact copy of the remote.
* Added support for linux kmom05/maze.


v1.9.11 (2015-09-01)
-------------------

* Correcting chmod for python cgi-scripts on publish.
* Change order of options for dbwebb publish and uglifyjs to work.
* Add dots when doing publish to track progress.
* Added support for htmlphp/kmom06/me6.


v1.9.10 (2015-08-25)
-------------------

* Generate default ssh-keys instead of DSA-keys.
* Fixing installation script for Mac OS.


v1.9.9 (2015-08-24)
-------------------

* Removing sudo from installation script.
* htmlphp inspect for report.php, not redovisning.php.


v1.9.8 (2015-08-17)
-------------------

* Correcting dbwebb download, gave error message.
* Adding inspect for linux, webapp, webgl.
* Updating inspect for htmlphp.
* Inspect doing archive to subdirectory for each course and should preserve group ownership.
* When updating leave configfile as is, use current settings as default settings.
* When mapping paths to directories, only acknowledge preconfigured items, #53.


v1.9.7 (2015-08.06)
-------------------

* Adjusting install phase and documentation.
* Enable to run selfupdate using sudo.
* Ignore some files when upload config and rc-files.


v1.9.6 (2015-08-05)
-------------------

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
-------------------

* Corrected jscs output for linux.


v1.9.4 (2015-05-20)
-------------------

* Teacher can download sourcecode from student, fix #46.
* Log also stderr during inspect, fix #42.
* Link to repo on GitHub, fix #41.
* Inspect archive only if another user.


v1.9.3 (2015-04-15)
-------------------

* Adding github command, fix #39.


v1.9.2 (2015-03-23)
-------------------

* Inspect working on local files, no copy.
* Inspect syncing essentials files on copy.
* Correcting inspection for javascript1.


v1.9.0 (2015-03-23)
-------------------

* Updating dbwebb version 2, alpha release.


v1.1.1 (2015-01-26)
-------------------

* Updated inspect for python.
* Support space in username for sshkeys.


v1.1.0 (2015-01-14)
-------------------

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
-------------------

* Added publish to all kmoms.
* Support for testing game in python
* Added inspect for python kmom05.


v1.0.13 (2014-09-30)
-------------------

* Fixed issue #7 to publish a students kmom on the web - as part of inspect.
* Inspect javascript1 kmom01 - 04 added.
* Inspect plane.py failed when windows style line endings.


v1.0.12 (2014-09-23)
-------------------

* Added `bin/dbwebb inspect` that runs tests on a kmom for yourself or selected student.
* Added tests for python kmom01-04.


v1.0.11 (2014-09-12)
-------------------

* `bin/dbwebb upload` now changes mod on files and directories before uploading.
* `bin/dbwebb init` does NOT upload to server per default (preparing to improve `download`).
* `dbwebb-config-sample` to allow directory names with spaces.
* Minor spelling errors.


v1.0.10 (2014-09-08)
-------------------

* v1.0.9 introduced a problem with validate. Fixed.


v1.0.9 (2014-09-08)
-------------------

* `dbwebb-validate` changes chmod to make all dirs and files readable since cygwin may set 000 as rights (for some yet unknown reason).


v1.0.8 (2014-09-05)
v1.0.7 (2014-09-05)
v1.0.6 (2014-09-05)
-------------------

* readlink -f fails on Mac.


v1.0.5 (2014-09-05)
-------------------

* Find name of Users group on Cygwin in swedish installations.


v1.0.4 (2014-09-05)
-------------------

* Failed detecting if curl or wget was available.


v1.0.3 (2014-09-05)
-------------------

* Support for curl where wget is not available (Mac).
* `bin/dbwebb init` now does upload to server again.


v1.0.2 (2014-09-05)
-------------------

* Check for autoupdate `.dbwebb.config` on `bin/dbwebb update`.
* Adding command `version` to display version of `bin/dbwebb` and latest commit to course repo.
* Adding file for version number `bin/.dbwebb.version`.
* Re-using user as default value when recreating config-file.
* Autocreating config-file when version number is changed.
* Now its own repo.


v1.0.1 (2014-09-03)
-------------------

* Require change of configuration file.
* Gets extra information when creating labs as a tar archive.
* `bin/dbwebb init` does not upload to server.
* Avoid python labs to overwrite an existing lab.


v1.0.0 (2014-08-30)
-------------------

* First official release, used in a University course at BTH, Sweden.
* Started work in april 2014, planned release end of august 2014.



```
 .
..:  Copyright (c) 2014-2016 Mikael Roos, mos@dbwebb.se
```
