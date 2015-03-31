/* Definitions */
#define OK	1
#define EXIT 2
#define SYSERR 3

/* externals */
extern int builtin;  //Determines if command is built in or not
extern int command;  //Current command.
int CMD; 	// Determines if the command gained from getCommand() is OK, SYSERR, or BYE (Actually not sure how to implement this yet)
