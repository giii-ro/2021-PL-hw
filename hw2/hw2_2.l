%{
 #include <stdio.h>
%}
%%

^(100+1+|01)+$	{printf("%s is danger\n",yytext);}
.|\n	;
%%

int main(){
	yylex();
	return 0;
}

int yywrap(){
	return 1;
}
