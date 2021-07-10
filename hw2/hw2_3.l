%{
#include <stdio.h>
#include <string.h>
int preprocessor = 0;
int octal_number = 0;
int negative_number = 0;
int positive_number = 0;
int operator = 0;
int comment = 0;
int equal = 0;
int open = 0;
int closed = 0;
int wordcase1 = 0; 
int wordcase2 = 0; 
int word = 0; 
int mark = 0; 
int countp = 0; 
int i = 0;
int flag = 0;
int prev = 0;
%}

DIGIT		[0-9]
LETTER		[a-zA-Z]
OCTAL		[0][0-7]+
OPEN		"{"
CLOSED		"}"
OPERATOR 	"+"|"-"|"*"|"/"|"%"|"&&"|"||"|"!"|">"|">="|"<"|"<="|"=="|"!="|"++"|"--"|","|"&"
EQUAL		"="

%x COMMENT
%%

"/*"		{BEGIN(COMMENT); ++comment;}
"//".*\n	{++comment;}

<COMMENT>.|\n	;
<COMMENT>"*/"	{BEGIN(INITIAL);}

"#include".*\n	{preprocessor++;}
"#define".*\n	{preprocessor++;}

{OPEN}		{open++;}
{CLOSED}	{closed++;} 


{LETTER}+	{
		 for (;i < strlen(yytext);i++) if (yytext[i] == 'p') {countp++;}
		 if (yytext[0] == 'e' && yytext[strlen(yytext)-1] == 'm') {flag = 1;} 
		 if(countp == 2) {wordcase1++;}
		 else if (flag) {wordcase2++;}
		 else {word++;}
 		 i = 0; countp = 0; flag = 0;
		}

"-"[1-9]{DIGIT}*	{negative_number++;}
{OCTAL}		{octal_number++;}
[1-9]{DIGIT}*	{positive_number++;}
{OPERATOR}	{operator++;}

{EQUAL}		{equal++;}
.|\n		{mark++;}
%%

int main(){
	yylex();

	printf("preprocessor = %d\n",preprocessor);
	printf("octal number = %d\n",octal_number);
	printf("negative decimal number = %d\n",negative_number);
	printf("positive decimal number = %d\n",positive_number);
	printf("operator = %d\n",operator);
	printf("comment = %d\n",comment);
	printf("'=' = %d\n",equal);
	printf("'{' = %d\n",open);
	printf("'}' = %d\n",closed);
	printf("wordcase1 = %d\n",wordcase1);
	printf("wordcase2 = %d\n",wordcase2);
	printf("word = %d\n",word);
	printf("mark = %d\n",mark);

	return 0;
}

int yywrap(){
	return 1;
}
