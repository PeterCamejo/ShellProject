/* Definitions */
//CMD Definitions
#define OK	1
#define EXIT 2
#define SYSERR 3

//Command definitions
#define CDH 1
#define CDX 2

/* externals */
int builtin;  //Determines if command is built in or not
int command;  //Current command.
int CMD; 	// Determines if the command gained from getCommand() is OK, SYSERR, or BYE
char * cd_filepath ;