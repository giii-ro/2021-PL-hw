%{
#include <stdio.h>
int cnt = 0;
%}

%%
"Love"|"love"	{cnt++;}
.|\n	;
%%

int main(){
	yylex();
	printf("nuber of love=%d",cnt);
	return 0;
}

int yywrap(){
	return 1;
}
