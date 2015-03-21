all: flex bison gcc

flex:
	flex hello.lex

bison:
	bison -dy hello.y

gcc:
	gcc lex.yy.c y.tab.c -o main.exe