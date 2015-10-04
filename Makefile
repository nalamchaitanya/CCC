# Makefile

CC=gcc
SH = bash
CFLAGS = -g
LDFLAGS = -lm

a.out: lex.yy.c y.tab.o Interpreter.o
	gcc -lm $^ -o $@

y.tab.o: y.tab.c y.tab.h
	gcc -c $(CFLAGS) $< -o $@

Interpreter.o: Interpreter.c Interpreter.h
	gcc -c $(CFLAGS) $< -o $@

y.tab.c: ccc.y
	yacc -t -v -d ccc.y

lex.yy.c: ccc.l
	lex ccc.l

test: a.out
	bash eval.sh ./a.out testcases

clean:
	@rm lex.yy.c y.tab.h y.tab.c a.out *.o

tar:
	@mv a.out /tmp/
	@mv testcases /tmp/
	@tar czf `ls -d1 ../CS* | grep -v tar | grep -v 000`.tar.gz `ls -d1 ../CS* | grep -v tar | grep -v 000`
	@mv /tmp/testcases .
	@mv /tmp/a.out .
	@ls -d1 ../CS*.tar.gz | grep -v 000
