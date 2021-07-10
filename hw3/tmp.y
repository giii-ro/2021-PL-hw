%{
#include <stdio.h>
int ary[9] = {0,0,0,0,0,0,0,0,0};
int inc = 0, dec = 0;
int prev_else = 0;
int isif = 0;
int findchar = 0;
int findint = 0;
int cnt_char = 0;
int cnt_int = 0;
%}
%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE
%start translation_unit
%%

primary_expression
	: IDENTIFIER {printf("IDENTIFIER -> primary_expression\n");}
	| CONSTANT {printf("CONSTANT -> primary_expression\n");}
	| STRING_LITERAL {printf("STRING_LITERAL -> primary_expression\n");}
	| '(' expression ')' {printf("'(' expression ')' -> primary_expression\n");}
	;

postfix_expression
	: primary_expression {printf("primary_expression -> postfix_expression\n");}
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')' {printf("postfix_expression liked(1) :  f() 매칭\n"); ary[0]++;}
	| postfix_expression '(' argument_expression_list ')' {printf("postfix_expression(2) what is this.. 매칭\n"); ary[0]++;}
	| postfix_expression '.' IDENTIFIER {printf("참조 연산자(1) : .\n"); ary[1]++;} /* ex : moo.i */
	| postfix_expression PTR_OP IDENTIFIER {printf("참조 연산자(2) : ->\n"); ary[1]++;} /* ex : moo->i */
	| postfix_expression INC_OP {printf("후위++\n"); inc++; ary[1]++;}
	| postfix_expression DEC_OP {printf("후위--\n"); dec++; ary[1]++;}
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression {printf("postfix_expression -> unary_expression\n");}
	| INC_OP unary_expression {printf("전위++\n"); inc++; ary[1]++;}
	| DEC_OP unary_expression {printf("전위--\n"); dec++; ary[1]++;}
	| unary_operator cast_expression /* ex : +(int), -(int) ...*/ 
	| SIZEOF unary_expression  /* ex : sizeof(++x), sizeof(x) ... */
	| SIZEOF '(' type_name ')' /* ex : sizeof(int), sizeof(double) ... */
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression {printf("unary_expression -> cast_expression\n");}
	| '(' type_name ')' cast_expression {printf("캐스팅연산자\n"); ary[1]++;} /* ex : (int), (char) ... */
	;

multiplicative_expression
	: cast_expression {printf("cast_expression -> multiplicative_expression\n");}
	| multiplicative_expression '*' cast_expression {printf("* 매칭\n"); ary[1]++;}	/* * */
	| multiplicative_expression '/' cast_expression {printf("/ 매칭\n"); ary[1]++;}	/* / */
	| multiplicative_expression '%' cast_expression {printf("% 매칭\n"); ary[1]++;}	/* % */
	;

additive_expression
	: multiplicative_expression {printf("multiplicative_expression -> additive_expression\n");}
	| additive_expression '+' multiplicative_expression {printf("+ 매칭\n"); ary[1]++;}	/* + */
	| additive_expression '-' multiplicative_expression {printf("- 매칭\n"); ary[1]++;}	/* - */
	;

shift_expression
	: additive_expression {printf("additive_expression -> shift_expression\n");}
	| shift_expression LEFT_OP additive_expression	{printf("<< 매칭\n"); ary[1]++;}	/* << */
	| shift_expression RIGHT_OP additive_expression	{printf(">> 매칭\n"); ary[1]++;}	/* >> */
	;

relational_expression
	: shift_expression {printf("shift_expression -> relational_expression\n");}
	| relational_expression '<' shift_expression {printf("< 매칭\n"); ary[1]++;}	/* < */
	| relational_expression '>' shift_expression {printf("> 매칭\n"); ary[1]++;}	/* > */
	| relational_expression LE_OP shift_expression {printf("<= 매칭\n"); ary[1]++;}	/* <= */
	| relational_expression GE_OP shift_expression {printf(">= 매칭\n"); ary[1]++;}	/* >= */
	;

equality_expression
	: relational_expression {printf("relational_expression -> equality_expression\n");}
	| equality_expression EQ_OP relational_expression {printf("== 매칭\n"); ary[1]++;}	/* == */
	| equality_expression NE_OP relational_expression {printf("!= 매칭\n"); ary[1]++;}	/* != */
	;

and_expression
	: equality_expression {printf("equality_expression -> and_expression\n");}
	| and_expression '&' equality_expression {printf("& 매칭\n"); ary[1]++;}	/* < */
	;

exclusive_or_expression
	: and_expression {printf("and_expression -> exclusive_or_expression\n");}
	| exclusive_or_expression '^' and_expression {printf("^ 매칭\n"); ary[1]++;}	/* < */
	;

inclusive_or_expression
	: exclusive_or_expression {printf("exclusive_or_expression -> inclusive_or_expression\n");}
	| inclusive_or_expression '|' exclusive_or_expression {printf("| 매칭\n"); ary[1]++;}	/* < */
	;

logical_and_expression
	: inclusive_or_expression {printf("inclusive_or_expression -> logical_and_expression\n");}
	| logical_and_expression AND_OP inclusive_or_expression {printf("&& 매칭\n"); ary[1]++;}	/* && */
	;

logical_or_expression
	: logical_and_expression {printf("logical_and_expression -> logical_or_expression\n");}
	| logical_or_expression OR_OP logical_and_expression {printf("|| 매칭\n"); ary[1]++;}	/* || */
	;

conditional_expression
	: logical_or_expression {printf("logical_or_expression -> conditional_expression\n");}
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression {printf("conditional_expression -> assignment_expression\n");}
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '=' {printf("= 매칭\n"); ary[1]++;}	/* = */
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';' /* "int;" 와 같이 변수 선언이 아님. */
	| declaration_specifiers init_declarator_list ';' {
												printf("선언 2 dec_spe init_... ;\n");
												if (findchar && findint) {printf("int, char매칭\n"); ary[3]+=cnt_char; ary[2] += cnt_int; cnt_int = cnt_char = 0; findchar = findint = 0;} 
												else if (findchar) {ary[3]+=cnt_char; printf("char 매칭, 개수 : %d\n",ary[3]); cnt_char = findchar = 0;} 
												else if (findint) {ary[2]+=cnt_int; printf("int 매칭, 개수 : %d\n", ary[2]); cnt_int = findint = 0;} 
													   }
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers
	| storage_class_specifier 
	| type_specifier declaration_specifiers 
	| type_specifier 
	| type_qualifier declaration_specifiers
	| type_qualifier 
	;

init_declarator_list
	: init_declarator 
	| init_declarator_list ',' init_declarator 
	;

init_declarator
	: declarator
	| declarator '=' initializer {printf("= 매칭\n"); ary[1]++;}	/* = */
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID 
	| CHAR {findchar = 1; cnt_char++;}
	| SHORT 
	| INT {findint = 1; cnt_int++;}
	| LONG 
	| FLOAT 
	| DOUBLE 
	| SIGNED 
	| UNSIGNED 
	| struct_or_union_specifier 
	| enum_specifier 
	| TYPE_NAME 
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression {printf("= 매칭\n"); ary[1]++;}	/* = */
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator {printf("포인터 선언\n"); ary[4]++;} /* int **p 같은 걸 제외하려고 여기서 추가*/
	| direct_declarator 
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration 
	;

parameter_declaration
	: declaration_specifiers declarator {
		 if (findchar) {ary[3]++; printf("char 매칭, 개수 : %d\n",ary[3]); cnt_char = 0; findchar= 0;} 
		 else if (findint) {ary[2]++; printf("int 매칭, 개수 : %d\n", ary[2]); cnt_int = 0; findint = 0;} 
		 printf("declaration_specifiers with declarator\n");
      }
	| declaration_specifiers abstract_declarator /* 추상 선언자의 경우 카운트하지 x, (ex : int *, int *[3] ...)*/
	| declaration_specifiers {printf("declaration_specifiers 혼자만\n");}/* 타입만 정의하는 경우도 카운트하지 x, (ex : int, char ... )*/
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement {printf("선택문 매칭\n");}
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement %prec LOWER_THEN_ELSE 	{
																printf("현재 if개수 : %d, 현재 prev_else : %d", ary[6], prev_else);
																if(prev_else == 0) ary[6]++;
																else ary[6]--,prev_else--;}
	| IF '(' expression ')' statement ELSE statement			{printf("if else 매칭, %d\n", prev_else); if (prev_else == 0) ary[6]++; prev_else++;} /* if else, else if 구분 */
	| SWITCH '(' expression ')' statement 						{printf("switch 매칭\n"); ary[6]++;}
	;

iteration_statement
	: WHILE '(' expression ')' statement		{printf("while 매칭\n"); ary[7]++;}
	| DO statement WHILE '(' expression ')' ';' {printf("do while 매칭\n"); ary[7]++;}
	| FOR '(' expression_statement expression_statement ')' statement {printf("for(1) 매칭\n"); ary[7]++;}
	| FOR '(' expression_statement expression_statement expression ')' statement {printf("for(2) 매칭\n"); ary[7]++;} /* ex : for (i = 0; i < 4; i++) f(); */
	| FOR '(' declaration expression_statement ')' statement {printf("for(3) 매칭\n"); ary[7]++;}
	| FOR '(' declaration expression_statement expression ')' statement {printf("for(4) 매칭\n"); ary[7]++;} /* ex : for (int i = 0; i < 4; i++) f(); */
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';' {printf("return(1) 매칭\n"); ary[8]++;} /* ex : return ;*/
	| RETURN expression ';' {printf("return(2) 매칭\n"); ary[8]++;} /* when func return value like "return (a, b);, return a = 1; ..."*/
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition{
												printf("일단 매칭1\n"); // isok
												
						 }
	| declaration 		 
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement {printf("function_definition -> [declaration_specifiers, declarator, declaration_list, compound_statement]\n");};
	| declaration_specifiers declarator compound_statement {
															if (findchar) {printf("char 매칭\n"); ary[3]++; findchar = 0;} 
															else if (findint) {printf("int 매칭\n"); ary[2]++; findint = 0;} 
                                                            printf("int 개수는 : %d\n", ary[2]);
															ary[0]++; printf("normal func : [ void f(int a, int b){} ~ ]\n");
															};
	| declarator declaration_list compound_statement {printf("function_definition -> [declarator, declaration_list, compound_statement]\n");};
	| declarator compound_statement {printf("function_definition -> [declarator, compound_statement]\n");};
%%

int main(void)
{
	yyparse();
	printf("function = %d\n", ary[0]);
	printf("operator = %d\n", ary[1]);
	printf("int = %d\n", ary[2]);
	printf("char = %d\n", ary[3]);
	printf("pointer = %d\n", ary[4]);
	printf("array = %d\n", ary[5]);
	printf("selection = %d\n", ary[6]);
	printf("loop = %d\n", ary[7]);
	printf("return = %d\n", ary[8]);
	return 0;
}

void yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}
