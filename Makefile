#
#
#
main:
	cat dbwebb2-header.bash \
		dbwebb2-version.bash \
		dbwebb2-usage.bash \
		dbwebb2-functions.bash \
		dbwebb2-bootstrap.bash \
		dbwebb2.bash \
		> dbwebb2

validate:
	cat dbwebb2-validate-header.bash \
		dbwebb2-version.bash \
		dbwebb2-validate-usage.bash \
		dbwebb2-functions.bash \
		dbwebb2-bootstrap.bash \
		dbwebb2-validate.bash \
		> dbwebb2-validate

install: validate main
	install -g 0 -o 0 -m 0755 dbwebb2 /usr/local/bin/dbwebb
	install -g 0 -o 0 -m 0755 dbwebb2-validate /usr/local/bin/dbwebb-validate
	install -g 0 -o 0 -m 0755 htmlhint /usr/local/bin/dbwebb-htmlhint

	if [ ! -d /usr/local/man/man1 ]; then mkdir /usr/local/man/man1; fi
	install -g 0 -o 0 -m 0644 man/man1/dbwebb.1 /usr/local/man/man1/
	gzip -f /usr/local/man/man1/dbwebb.1

deinstall:
	rm -f /usr/local/bin/dbwebb
	rm -f /usr/local/bin/dbwebb-validate
	rm -f /usr/local/bin/dbwebb-htmlhint
	rm -f /usr/local/bin/dbwebb2
	rm -f /usr/local/man/man1/dbwebb.1.gzip
