#include "shell.h"
#include <stdlib.h>
#include <stdio.h>

void shell_init(){
	return;
}

/* changes directory when CD+filepath command recieved */
void changedir(char * directory){
	if(chdir(directory) == -1){
		printf("\t %s is not a directory\n" , directory);
	}
	return;
}


/* adds an alias to the aliastable */
int addalias(char * alias_name , char * alias_command){
	int i = 0;
	while(aliastable[i][0] != NULL){
		if(strcmp(alias_name , aliastable[i][0]) == 0){
			printf("\t Error: That name is already assigned\n");
			return 1;
		}
		if(strcmp(alias_command,aliastable[i][1]) == 0){
			printf("\t Error: That command is already assigned\n");
			return 1;
		}

		i++;
	}
	
	if(i >= MAX_ALIASES){
		printf("\t Error: Alias table is full.\n");
		return 1;
	}
	else{
		aliastable[i][0] = alias_name;
		aliastable[i][1] = alias_command;
	}
	return 0;
}

int unalias(char * alias_name){
	int i = 0;
	int found = 0;
	
	while(aliastable[i][0]!=NULL){
		if(strcmp(alias_name , aliastable[i][0]) == 0){
			aliastable[i][0] = 0;
			aliastable[i][1] = 0;
			i++;
			found = 1;
			break;
		}
		i++;
	}
	while(aliastable[i][0]!=NULL){
		aliastable[i-1][0] = aliastable[i][0];
		aliastable[i-1][1] = aliastable[i][1];		
		if(aliastable[i+1][0] == 0){	
			aliastable[i][0] = 0;
			aliastable[i][1] = 0;
			return 0;
		}
		i++;
	}

	if(found == 0){
		printf("\t Error: %s alias not found.\n" , alias_name);
		return 1;
	}
		
}

/* do_it() runs built in commands */
void do_it(){
	switch(command){
		/* environ and i for use in printenv (Cant declare variables inside cases) */
		extern char ** environ; // Holds local UNIX Environmental Variables.
		int i = 0;

		case CDX :  // CD with a directory specified.
			changedir(cd_filepath);
			break;
		case CDH: 	// CD with no directory specified.
			chdir(getenv("HOME"));
			break;
		case SETENV:
			if(setenv( envvar , envvar_value, 1) == -1){
				printf("\t Error: Failed to set %s as %s\n", envvar , envvar_value);
			}
			break;
		case PRINTENV:
			while(environ[i]){
				printf("%s\n" , environ[i++]);
			}
			break;
		case LISTALIAS:
			while(aliastable[i][0]){
				printf("%s\t", aliastable[i][0]);
				printf("%s\n", aliastable[i++][1]);
			}
			break;
		case HELLOFRIEND:  //Using to make sure shell responds on startup.Can remove later.
			printf("\t Hello back!\n");
			break;
		case ADDALIAS:
			addalias(alias_name , alias_command);
			break;
		case UNALIAS:
			unalias(alias_name);
			break;
		
	}
}

/* Prompts shell input each line */
void prompt(){
	char *curdir = get_current_dir_name(); //current working directory
	printf("SHELL:%s$ " , curdir);
	return;
}


int getCommand(){
	yyparse();
	return 0;
}


int main(){
	/* initilization */
	shell_init();   // What is the point in this...?

	/* Shell Loop */
	while(1){	
		prompt();
		CMD = 0;
		getCommand();
		switch(CMD){
			case OK: 
				if(builtin){
					do_it();
				}
				/*else{
					execute();
				};*/
				
				break;
			case EXIT:
				printf("\t Exiting...\n");
				exit(0);
			case SYSERR:
				printf("\t Nonvalid command\n");
				//	recover();
		}

	}
	return 0;
}