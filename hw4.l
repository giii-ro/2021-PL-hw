D [0-9]
L [a-zA-Z_]
H [a-fA-F0-9]
E [Ee][+-]?{D}+
FS (f|F|l|L)
IS (u|U|l|L)*
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

extern char name[21];   
extern int line;
static int check_type(void);

void print(){
    //printf("%s\n",yytext);
}

%}

%x COMMENT
%%
"/*"	{BEGIN(COMMENT);} 
"//".*	{;} 

<COMMENT>.|\n	{if(strcmp(yytext,"\n") == 0) line++;}
<COMMENT>"*/"	{BEGIN(INITIAL);}

"#include".*\n	{print(); line++;}
"#define".*\n	{print(); line++;}
"auto" {print();  return(AUTO); }
"break" {print();  return(BREAK); }
"case" {print(); return(CASE); }
"char" {print(); return(CHAR); }
"const" {print(); return(CONST); }
"continue" {print(); return(CONTINUE); }
"default" {print(); return(DEFAULT); }
"do" {print(); return(DO); }
"double" {print(); return(DOUBLE); }
"else" {print(); return(ELSE); }
"enum" {print(); return(ENUM); }
"extern" {print(); return(EXTERN); }
"float" {print(); return(FLOAT); }
"for" {print(); return(FOR); }
"goto" {print(); return(GOTO); }
"if" {print(); return(IF); }
"int" {print(); return(INT); }
"long" {print(); return(LONG); }
"register" {print(); return(REGISTER); }
"return" {print(); return(RETURN); }
"short" {print(); return(SHORT); }
"signed" {print(); return(SIGNED); }
"sizeof" {print(); return(SIZEOF); }
"static" {print(); return(STATIC); }
"struct" {print(); return(STRUCT); }
"switch" {print(); return(SWITCH); }
"typedef" {print(); return(TYPEDEF); }
"union" {print(); return(UNION); }
"unsigned" {print(); return(UNSIGNED); }
"void" {print(); return(VOID); }
"volatile" {print(); return(VOLATILE); }
"while" {print(); return(WHILE); }
{L}({L}|{D})* {strcpy(name, yytext); return(check_type()); }
0[xX]{H}+{IS}? {print(); return(CONSTANT); }
0{D}+{IS}? {print(); return(CONSTANT); }
{D}+{IS}? {print(); return(CONSTANT); }
L?'(\\.|[^\\'])+' {print(); return(CONSTANT); }
{D}+{E}{FS}? {print(); return(CONSTANT); }
{D}*"."{D}+({E})?{FS}? {print(); return(CONSTANT); }
{D}+"."{D}*({E})?{FS}? {print(); return(CONSTANT); }
L?\"(\\.|[^\\"])*\" {print(); return(STRING_LITERAL); }
"..." {print(); return(ELLIPSIS); }
">>=" {print(); return(RIGHT_ASSIGN); }
"<<=" {print(); return(LEFT_ASSIGN); }
"+=" {print(); return(ADD_ASSIGN); }
"-=" {print(); return(SUB_ASSIGN); }
"*=" {print(); return(MUL_ASSIGN); }
"/=" {print(); return(DIV_ASSIGN); }
"%=" {print(); return(MOD_ASSIGN); }
"&=" {print(); return(AND_ASSIGN); }
"^=" {print(); return(XOR_ASSIGN); }
"|=" {print(); return(OR_ASSIGN); }
">>" {print(); return(RIGHT_OP); }
"<<" {print(); return(LEFT_OP); }
"++" {print(); return(INC_OP); }
"--" {print(); return(DEC_OP); }
"->" {print(); return(PTR_OP); }
"&&" {print(); return(AND_OP); }
"||" {print(); return(OR_OP); }
"<=" {print(); return(LE_OP); }
">=" {print(); return(GE_OP); }
"==" {print(); return(EQ_OP); }
"!=" {print(); return(NE_OP); }
";" {print(); return(';'); }
("{"|"<%") {print(); return('{'); }
("}"|"%>") {print(); return('}'); }
"," {print(); return(','); }    
":" {print(); return(':'); }
"=" {print(); return('='); }
"(" {print(); return('('); }
")" {print(); return(')'); }
("["|"<:") {print(); return('['); }
("]"|":>") {print(); return(']'); }
"." {print(); return('.'); }
"&" {print(); return('&'); }
"!" {print(); return('!'); }
"~" {print(); return('~'); }
"-" {print(); return('-'); }
"+" {print(); return('+'); }
"*" {print(); return('*'); }
"/" {print(); return('/'); }
"%" {print(); return('%'); }
"<" {print(); return('<'); }
">" {print(); return('>'); }
"^" {print(); return('^'); }
"|" {print(); return('|'); }
"?" {print(); return('?'); }
[ \t\v\f] ;
"\n" {line++;}
. { /* ignore bad characters */ }

%%

static int check_type(void){
    return IDENTIFIER;
}
int yywrap(void){
    return 1;
}

