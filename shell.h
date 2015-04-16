#include <sys/stat.h>
#include <fcntl.h>

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
#define LS 9

#define HOME getenv("HOME")
#define PWD  getenv("PWD")

//open and close macros
#define STDIN 0
#define STDOUT 1

// Piping macros
#define FIRST 0
#define MIDDLE 1
#define LAST 2
#define ONLYONE 3
#define FD_READ 0
#define FD_WRITE 1


/*structs*/
typedef struct node{
	char * data;
	struct node * next;
} node;

typedef struct linklist{
	struct node * head;
	struct node * tail;
	int size;

}linklist;

typedef struct com{
	int infd;
	int outfd;
	int fd[2];						//Holds filedes from pipe() syscall.
	struct com * next; 				//points to next command;
	linklist * comargs;
	int index;				

} com;


/* Globals */
int builtin;  						//Determines if command is built in or not
int command;  						//Current built in command.
int CMD; 							// Determines if the command gained from getCommand() is OK, SYSERR, or BYE
char * cd_filepath; 				//Filepath that cd is changing into.
char * ls_filepath;					//Filepath that ls is searching.
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
char * outfile;		 				// Out File for IO Redirection
int appending;						// Signals if a write will overwrite or append (when > or >> is used, respectively)

com * current_command;


/* struct methods */

com * create_com();
linklist * create_linklist();
void linklist_insert(linklist * list, char * data );
void linklist_remove(linklist * list ,char * data );
void linklist_delete(linklist * list);


/* main function constructors */
void  shell_init();
void changedir(char * directory);
int addalias(char * alias_name , char * alias_command);
int unalias(char * alias_name);
void do_it();
void ls();
void lsfilepath(char * filepath);
int executable(char * filename , char * filepath);
int determinePlace(com * comargs);
void in_redir(char * infile);
void out_redir(char * outfile , int appending);
void execute(com * current_command);
void prompt();
void init_scanner_and_parser();
int getCommand();







