#include "shell.h"

/* do_it() runs built in commands */
/*
void do_it(){
	switch(command){
		case CDHome:
		case CD : 
		case ALIAS
		case UNALIAS
		case SETENV
		case PRINTENV
	}
}
*/

int main(){
	/* initilization */
	//shell_int();

	/* Shell Loop */
	while(1){	
		//prompt();
		switch(CMD = getCommand()){
			case OK: 
				if(builtin){
					do_it();
				}
				else{
					execute();
				};
			case BYE:
				exit();  //Couldn't we just break?
			case SYSERR:
				printErr("Nonvalid command");
				recover();
		}

	}
	return 0;
}