/* Definitions */
#define MAX_ALIASES 50

//CMD Definitions
#define OK	1
#define EXIT 2
#define SYSERR 3

//Command definitions
#define CDH 1
#define CDX 2
#define SETENV 3
#define PRINTENV 4
#define ADDALIAS 5
#define UNALIAS 6
#define LISTALIAS 7
#define	HELLOFRIEND 8  //Using to make sure shell is responding on startup. Can remove later.


/* externals */
int builtin;  						//Determines if command is built in or not
int command;  						//Current command.
int CMD; 							// Determines if the command gained from getCommand() is OK, SYSERR, or BYE
char * cd_filepath; 				//Filepath that cd is changing into.
char * envvar; 						// Environmental Variable for setenv()
char * envvar_value; 				// Value to set envvar to.
char * aliastable[MAX_ALIASES][2];	//50 possible aliases with 1 definition each.
char * start_alias;
int alias_loop;
char*  alias_name;				
char * alias_command;
int alias_caught;
int expanding; 						//Signals FLEX on if a word is an expansion attempt.

extern char ** environ; // Holds local UNIX Environmental Variables.


/* main function constructors */
char  processAlias(char * alias);
