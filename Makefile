#
#
#
main:
	cat dbwebb2-header.bash \
		LICENSE \
		dbwebb2-version.bash \
		dbwebb2-functions.bash \
		dbwebb2-bootstrap.bash \
		dbwebb2-usage.bash \
		dbwebb2.bash \
		> dbwebb2
	chmod 755 dbwebb2

validate:
	cat dbwebb2-validate-header.bash \
		LICENSE \
		dbwebb2-version.bash \
		dbwebb2-functions.bash \
		dbwebb2-bootstrap.bash \
		dbwebb2-validate-usage.bash \
		dbwebb2-validate.bash \
		> dbwebb2-validate
	chmod 755 dbwebb2-validate

inspect:
	cat dbwebb2-inspect-header.bash \
		LICENSE \
		dbwebb2-version.bash \
		dbwebb2-functions.bash \
		dbwebb2-bootstrap.bash \
		dbwebb2-inspect-usage.bash \
		dbwebb2-inspect-python.bash \
		dbwebb2-inspect-javascript1.bash \
		dbwebb2-inspect-htmlphp.bash \
		dbwebb2-inspect-design.bash \
		dbwebb2-inspect-dbjs.bash \
		dbwebb2-inspect-oopython.bash \
		dbwebb2-inspect-oophp.bash \
		dbwebb2-inspect-phpmvc.bash \
		dbwebb2-inspect-javascript.bash \
		dbwebb2-inspect-linux.bash \
		dbwebb2-inspect-webapp.bash \
		dbwebb2-inspect-webgl.bash \
		dbwebb2-inspect.bash \
		> dbwebb2-inspect
	chmod 755 dbwebb2-inspect

install: inspect validate main
	install -g 0 -o 0 -m 0755 dbwebb2 /usr/local/bin/dbwebb
	install -g 0 -o 0 -m 0755 dbwebb2-validate /usr/local/bin/dbwebb-validate
	install -g 0 -o 0 -m 0755 dbwebb2-inspect /usr/local/bin/dbwebb-inspect
	install -g 0 -o 0 -m 0755 bash_completion.d/dbwebb /etc/bash_completion.d/dbwebb
	#install -g 0 -o 0 -m 0755 htmlhint /usr/local/bin/dbwebb-htmlhint

	#if [ ! -d /usr/local/man/man1 ]; then mkdir /usr/local/man/man1; fi
	#install -g 0 -o 0 -m 0644 man/man1/dbwebb.1 /usr/local/man/man1/
	#gzip -f /usr/local/man/man1/dbwebb.1

deinstall:
	rm -f /usr/local/bin/dbwebb
	rm -f /usr/local/bin/dbwebb-validate
	rm -f /usr/local/bin/dbwebb-inspect
	rm -f /etc/bash_completion.d/dbwebb
	#rm -f /usr/local/bin/dbwebb-htmlhint
	rm -f /usr/local/bin/dbwebb2
	rm -f /usr/local/man/man1/dbwebb.1.gzip
