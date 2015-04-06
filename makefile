all: flex bison gcc

winall:winflex winbison gcc

flex:
	flex shell.lex

bison:
	bison -dy shell.y

gcc:
	gcc -std=c99 lex.yy.c y.tab.c shell.c -o shell

winflex:
	win_flex shell.lex

winbison:
	win_bison -dy shell.y

clean:
	rm shell lex.yy.c y.tab.c y.tab.h