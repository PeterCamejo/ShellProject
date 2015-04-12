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

#define HOME getenv("HOME")
#define PWD  getenv("PWD")

//open and close macros
#define STDIN 0
#define STDOUT 1


/* Globals */
int builtin;  						//Determines if command is built in or not
int command;  						//Current built in command.
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
int unaliasing;

char * infile;						// In File for IO redirection
char * outfile; 					// Out File for IO Redirection


/*structs*/



typedef struct node{
	char * data;
	struct node * next;
} node;

typedef struct linklist{
	struct node * head;
	struct node * tail;

}linklist;

typedef struct com{
	int infd;
	int outfd;
	int fd[2];
	struct com * next; 				//points to next command;
	linklist * comargs;
	int index;				

} com;

/* struct methods */

com * create_com();
linklist * create_linklist();
void linklist_insert(linklist * list, char * data );
void linklist_remove(linklist * list ,char * data );
void linklist_delete(linklist * list);


/* main function constructors */
char  processAlias(char * alias);
