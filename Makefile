#
#
#
install:
	install -g 0 -o 0 -m 0755 dbwebb2 /usr/local/dbwebb2

	if [ ! -d /usr/local/man/man1 ]; then mkdir /usr/local/man/man1; fi
	install -g 0 -o 0 -m 0644 man/man1/dbwebb.1 /usr/local/man/man1/
	gzip -f /usr/local/man/man1/dbwebb.1

deinstall:
	rm -f /usr/local/dbwebb2
	rm -f /usr/local/man/man1/dbwebb.1.gzip
