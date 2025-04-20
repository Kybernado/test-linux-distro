CC = gcc
DESTDIR = /usr/share/local
PROGDIR = testprog

build: 
	$(CC) -shared -o libtest.so lib.c
	$(CC) -o prog prog.c -L. -ltest

install: build
	mkdir -p $(DESTDIR)/$(PROGDIR)
	cp prog libtest.so $(DESTDIR)/$(PROGDIR)

clean:
	rm libtest.so prog