#
#
#
install:
	install -g 0 -o 0 -m 0755 dbwebb2.bash /usr/local/bin/dbwebb

	if [ ! -d /usr/local/man/man1 ]; then mkdir /usr/local/man/man1; fi
	install -g 0 -o 0 -m 0644 man/man1/dbwebb.1 /usr/local/man/man1/
	gzip -f /usr/local/man/man1/dbwebb.1

deinstall:
	rm -f /usr/local/bin/dbwebb
	rm -f /usr/local/bin/dbwebb2
	rm -f /usr/local/man/man1/dbwebb.1.gzip
