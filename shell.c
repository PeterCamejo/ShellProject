#include "shell.h"
#include <stdlib.h>
#include <stdio.h>

void shell_init(){
	alias_loop = 0;
	return;
}

/* changes directory when CD+filepath command recieved */
void changedir(char * directory){
	if(chdir(directory) == -1){
		printf("\t %s is not a directory\n" , directory);
	}

	char * pwd;
	pwd = get_current_dir_name();
	setenv("PWD" , pwd , 1);
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
		printf("%s != %s\n" , alias_name , aliastable[i][0]);
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

		int i = 0;
		case CDX :  // CD with a directory specified.
			changedir(cd_filepath);
			break;
		case CDH: 	// CD with no directory specified.
			chdir(HOME);
			setenv("PWD" , getenv("HOME") , 1);
			break;
		case SETENV:
			if(setenv( envvar , envvar_value, 1) == -1){
				printf("\t Error: Unable to set %s as %s\n" , envvar , envvar_value);
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

	return;
}

/*
void execute(){
//Check to see if command is accessible and executable
	if(! executable()){
		printf("\t Command not Found\n"); //not accessible
		return;
	}

//Check IO file existence in the event of io-reduction.
	if( check_in_file() == SYSERR){
		printf("Can't read from: %s, srcf"); //not accessible
		return;
	}
	if( check_out_file() == SYSERR){
		printf("Can't write to: %s, destf"); //not accessible
		return;
	}

	//Build Up the PipeLine
	for(c=0; c < currcmd; c++){
		//Prepare arguments
		if(..){
			//Argv
		}
		else{
			//the case of a command with no arguments
		}

		switch( pid = fork() ) { //Fork process return twice

			case 0:
				switch(WhichComm(c)){
					case FIRST:
					if( close(1) = SYSCALLER) {...}
					if( dup(comtab[c].outfd) != 1) {...}
					if( close(comtab[c+1].infd) == SYSCALLER){...}
					in_redir();
					break;

					case LAST:
						if( close(0) == SYSCALLER){...}
						if( dup(comtab[c].infd) != 0) {...}
						out_redir();
						break;

					case THE_ONLY_ONE:
						in_redir();
						out_redir();
						break;

					default:
					if( dup2(comtab[c].outfd,1) == SYSCALLER) {...}
					if( dup2(comtab[c].infd, 0) == SYSCALLER) {...}
					if( close(comtab[c+1].infd) == SYSCALLER) {...}
					break;
				}
		}
	}
}



*/

/* Prompts shell input each line */
void prompt(){
	char *curdir = get_current_dir_name(); //current working directory
	printf("SHELL:%s$ " , curdir);
	return;
}
void init_scanner_and_parser(){
	unaliasing = 0;
	alias_caught = 0;
	expanding = 0;
	builtin = 0;
	command = 0;
	CMD = 0;
	return;
}

int getCommand(){
	
	init_scanner_and_parser();

	yyparse();

	while(alias_caught == 1){
		if(alias_loop == 0){
			start_alias = alias_name;
			alias_loop = 1;
		}
		if(strcmp(alias_command , start_alias)== 0){
			printf("\t Error: Infinite alias loop detected. Aborting...\n");
			break;
		}else{
			reflex(alias_command);
		}
	}

	alias_loop = 0;
	return 0;
}


int main(){
	/* initilization */
	shell_init();   // What is the point in this...?

	/* Shell Loop */
	while(1){
		prompt();
		getCommand();
		switch(CMD){
			case OK: 
				if(builtin){
					do_it();
				}
				else{
					//execute();
				};
				
				break;
			case EXIT:
				printf("\t Exiting...\n");
				exit(0);
			case SYSERR:
				printf("\t Nonvalid command\n");
				break;
				//	recover();
		}

	}
	return 0;
}