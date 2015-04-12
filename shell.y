%{#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "shell.h"



void yyerror ( const char *str) { if(alias_caught != 1 && unaliasing != 1)fprintf ( stderr , "\t ERROR: %s\n" , str);}
int yywrap(){return 1;}


%}

%union
{
	int intval;
	char *strval;
	float floatval;
}

%token NUMBER HELLO BYE CD FILEPATH PRINT_ENV ALIAS UN_ALIAS WORD COMMAND SET_ENV NEWLINE AMPER GT GT2 LT PIPE ESCAPE

%left CD WORD ALIAS

%type <strval> args
%type <linklist> arglist;
%type <linklist> cm

%%

commands: /*empty */
		| commands command;

command:
		NEWLINE { /*Ignore */} |hello_case NEWLINE|bye_case NEWLINE|cd_case NEWLINE|setenv_case NEWLINE|printenv_case NEWLINE|add_alias_case NEWLINE|unalias_case NEWLINE;
hello_case:
		HELLO 		{CMD = OK; builtin = 1; command = HELLOFRIEND; return 0;};
bye_case:
		BYE			{CMD = EXIT; return 0;};
cd_case: 
		CD 		  	{CMD = OK; builtin = 1; command = CDH; return 0;};
		|CD args   	{CMD = OK; builtin = 1; command = CDX; cd_filepath = $<strval>2; return 0;};
		
setenv_case:
		SET_ENV args args   {CMD = OK; builtin = 1; command = SETENV; envvar = $<strval>2; envvar_value = $<strval>3; return 0;};

printenv_case:
		PRINT_ENV  	
		{
			extern char ** environ; // Holds local UNIX Environmental Variables.
			int i = 0;
			while(environ[i]){
				printf("%s\n" , environ[i]);
				i++;
			}
			return 0;
		};
add_alias_case:
		ALIAS args COMMAND       {CMD = OK ; builtin =1 ; command = ADDALIAS; alias_name = $<strval>2; alias_command = $<strval>3; return 0;};
		|ALIAS 					 {CMD = OK; builtin = 1; command = LISTALIAS; return 0;};
unalias_case:
		UN_ALIAS args			{CMD = OK; builtin = 1; command = UNALIAS; alias_name = $<strval>2; return 0; };

final_command:
		cm{
			int wait;
			com * currcmd = $1;
			pid_t proccess_id;
			while(currcmd){
				switch(process_id = fork()){
					case 0:
						switch(determinePlace(currcmd)){ //Determine if child (0) or not (0 > )
							case ONLYONE:
								in_redir(infile);
								out_redit(outfile , appending);
								CMD = OK;
								builtin = 0;
								current_command = currcmd;
								exit(0);
							break;

							case FIRST:
								if(close(STDOUT) == -1){
									printf("\t Error closing STDOUT in FIRST switch\n");
								}
								if(dup(currcmd->fd[FD_WRITE] != 1)){
									printf("\t Error dup() current command's write fd in FIRST switch \n");
								}
								if(close(currcmd->next->[FD_READ] == -1)){
									printf("\t Error closing next command's read fd in FIRST switch \n");
								}
								in_redir(infile);
								CMD = OK;
								builtin = 0;
								current_command = currcmd;
								exit(0);
							break;

							case LAST:
								if(close(STDIN) == -1){
									printf("\t Error closing STDIN in LAST switch\n");
								}
								if(dup(currcmd->fd[FD_READ]) != 0){
									printf(\t "Error dup() current command's read fd in LAST switch \n");
								}
								
								out_redir(outfile , appending);
								CMD = OK;
								builtin = 0;
								current_command = currcmd;
								exit(0);
							break;

							default: //MIDDLE
								if(dup2(currcmd->fd[FD_READ] , STDIN) == -1){
									printf("\t ERROR at first dup2() in MIDDLE switch\n");
								}
								if(dup2(currcmd->fd[FD_WRITE] , STDOUT) == -1){
									printf("\t ERROR at second dup2() in MIDDLE switch\n");
								}
								if(close(currcmd->next->fd[FD_READ]) == -1){
									printf("\t ERROR closing next command's read fd in MIDDLE switch\n");
								}
								CMD = OK;
								builtin = 0;
								current_command = currcmd;
								exit(0);
							break;
					    } // End whichCommand() switch

					break;

					default:	//in parent
						if(currcmd->next){
							close(currcmd->next->fd[FD_WRITE]);
						}
						waitpid(process_id , &wait , 0);
					break;

				}// end fork() switch 

				currcmd = currcmd->next; //Move on to next command
			}
			infile = NULL;		//reset file values;
			outfile = NULL;
		};
cm:
	cm LT WORD {
				com * argcom = $1;
				infile = $<strval>3;
	}
	|cm PIPE WORD{
				com * com0 = $1;
				com * com1 = $<strval>3;
				com1->index =  com0->index+1;
				com0->next = com1;

				pipe(com1->fd);
				$$ = $1;
	}
	|cm GT2 WORD{
				com * argom = $1;
				outfile = $<strval>3;
				appending = 1;
	}
	|cm GT WORD{
				com * argcom = $1;
				outfile = $<strval>3;
				appending = 0;
	}
	|arglist	{$$ = $1;};

arglist:
		args {
			com * argcom = create_com();
			linklist_insert(argcom->comargs , $1);
			argcom->index = 0;
			$$ = argcom;
		}
		|arglist args{
					com * argcom = $1;
					linklist_insert(argcom->comargs , $2);
					$$ = $1;
		};

args:
		WORD 					{$$ = $<strval>1;};
