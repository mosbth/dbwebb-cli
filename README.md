Command-line utility `dbwebb` to work with course repositories
============================================================

Part of course repos as a admin utility.



History
-------------------

v1.9.5x (latest)

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
