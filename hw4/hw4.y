%{
#include <stdio.h>
#include <string.h>
#include <assert.h> /* for assert */
#include <stdlib.h> /* for malloc/realloc/free */

#define MAX 2001
char name[21] = "", caller[21]= "", callee[21] = "";

char str2func[MAX][21], pfunc[MAX][21], ptr2func[MAX][21];
// str2func[i] : key : str2func[i] , val : i   (for using map)
// ptr2func[i] : key : ptr2func[i] , val : i   (for using map)
// pfunc[i] : ptr2func[i]이 가리키는 함수

int isfunc = 0, func[MAX];
int funcidx = 1, ptrfuncidx = 1, ptrfunc = 0, line = 1;
int cur, nxt;
int iter, iter2, iter3;

#define cvector_vector_type(type) type *

#define cvector_set_capacity(vec, size)     \
	do {                                    \
		if (vec) {                          \
			((size_t *)(vec))[-1] = (size); \
		}                                   \
	} while (0)


#define cvector_set_size(vec, size)         \
	do {                                    \
		if (vec) {                          \
			((size_t *)(vec))[-2] = (size); \
		}                                   \
	} while (0)


#define cvector_capacity(vec) \
	((vec) ? ((size_t *)(vec))[-1] : (size_t)0)


#define cvector_size(vec) \
	((vec) ? ((size_t *)(vec))[-2] : (size_t)0)


#define cvector_empty(vec) \
	(cvector_size(vec) == 0)

#define cvector_grow(vec, count)                                              \
	do {                                                                      \
		const size_t cv_sz = (count) * sizeof(*(vec)) + (sizeof(size_t) * 2); \
		if (!(vec)) {                                                         \
			size_t *cv_p = malloc(cv_sz);                                     \
			assert(cv_p);                                                     \
			(vec) = (void *)(&cv_p[2]);                                       \
			cvector_set_capacity((vec), (count));                             \
			cvector_set_size((vec), 0);                                       \
		} else {                                                              \
			size_t *cv_p1 = &((size_t *)(vec))[-2];                           \
			size_t *cv_p2 = realloc(cv_p1, (cv_sz));                          \
			assert(cv_p2);                                                    \
			(vec) = (void *)(&cv_p2[2]);                                      \
			cvector_set_capacity((vec), (count));                             \
		}                                                                     \
	} while (0)


#define cvector_pop_back(vec)                           \
	do {                                                \
		cvector_set_size((vec), cvector_size(vec) - 1); \
	} while (0)

#define cvector_erase(vec, i)                                  \
	do {                                                       \
		if (vec) {                                             \
			const size_t cv_sz = cvector_size(vec);            \
			if ((i) < cv_sz) {                                 \
				cvector_set_size((vec), cv_sz - 1);            \
				size_t cv_x;                                   \
				for (cv_x = (i); cv_x < (cv_sz - 1); ++cv_x) { \
					(vec)[cv_x] = (vec)[cv_x + 1];             \
				}                                              \
			}                                                  \
		}                                                      \
	} while (0)

#define cvector_free(vec)                        \
	do {                                         \
		if (vec) {                               \
			size_t *p1 = &((size_t *)(vec))[-2]; \
			free(p1);                            \
		}                                        \
	} while (0)

#define cvector_begin(vec) \
	(vec)

#define cvector_end(vec) \
	((vec) ? &((vec)[cvector_size(vec)]) : NULL)

#define cvector_push_back(vec, value)                               \
	do {                                                            \
		size_t cv_cap = cvector_capacity(vec);                      \
		if (cv_cap <= cvector_size(vec)) {                          \
			cvector_grow((vec), !cv_cap ? cv_cap + 1 : cv_cap * 2); \
		}                                                           \
		vec[cvector_size(vec)] = (value);                           \
		cvector_set_size((vec), cvector_size(vec) + 1);             \
	} while (0)

#define cvector_push_back(vec, value)                   \
	do {                                                \
		size_t cv_cap = cvector_capacity(vec);          \
		if (cv_cap <= cvector_size(vec)) {              \
			cvector_grow((vec), cv_cap + 1);            \
		}                                               \
		vec[cvector_size(vec)] = (value);               \
		cvector_set_size((vec), cvector_size(vec) + 1); \
	} while (0)

#define cvector_copy(from, to)									\
	do {														\
		for(size_t i = 0; i < cvector_size(from); i++) {		\
			cvector_push_back(to, from[i]);						\
		}														\
	} while (0)													\

int query_idx(char *x){
	for (iter = 1; iter < funcidx; iter++)
		if (strcmp(x, str2func[iter]) == 0) 
			return iter;
	return -1;	
}

int query_ptr_idx(char *x){
	for (iter = 1; iter < ptrfuncidx; iter++)
		if (strcmp(x, ptr2func[iter]) == 0) 
			return iter;
	return -1;	
}

int isempty(char *x){
	if (strlen(x) == 0) return 1;
	return 0;
}


typedef struct EDGE{
    cvector_vector_type(int) l;
} e;

e adj[MAX][MAX];
FILE * graph;

void dfs(char *x){
    int u = query_idx(x), v;
    for (v = 1; v < funcidx; v++){
            if (func[v] == 0 || cvector_size(adj[u][v].l) == 0) continue;
            fprintf(graph, "\"%s\" -> \"%s\"", str2func[u], str2func[v]);
			fprintf(graph, "[label=\"");
            fprintf(graph, "%d times line : ", cvector_size(adj[u][v].l));
            for (iter = 0; iter < cvector_size(adj[u][v].l); iter++){
                fprintf(graph, "%d ",adj[u][v].l[iter]);
            }
			fprintf(graph, "\"]\n");
            if (u != v) dfs(str2func[v]);
        }
}

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
	: IDENTIFIER {
			cur = query_idx(caller);
            if (cur < 0){
                strcpy(str2func[funcidx], caller);
                cur = funcidx;
                funcidx++;                
            }
            func[cur] = 1;

			if (isempty(callee)) strcpy(callee, name);
			nxt = query_idx(name);
			if (nxt < 0){
				strcpy(str2func[funcidx], name);
				nxt = funcidx;
				funcidx++;
			}
			cvector_push_back(adj[cur][nxt].l, line);
    }
	| CONSTANT 
	| STRING_LITERAL 
	| '(' expression ')' 
	;

postfix_expression
	: primary_expression 
	| postfix_expression '[' expression ']' 
	| postfix_expression '(' ')' {isfunc = 1;}
	| postfix_expression '(' argument_expression_list ')' {isfunc = 1;}
	| postfix_expression '.' IDENTIFIER 
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP 
	| postfix_expression DEC_OP 
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression 
	;

unary_expression
	: postfix_expression 
	| INC_OP unary_expression 
	| DEC_OP unary_expression 
	| unary_operator cast_expression   
	| SIZEOF unary_expression  
	| SIZEOF '(' type_name ')'
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
	: unary_expression 
	| '(' type_name ')' cast_expression 
	;

multiplicative_expression
	: cast_expression 
	| multiplicative_expression '*' cast_expression 
	| multiplicative_expression '/' cast_expression 
	| multiplicative_expression '%' cast_expression 
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression 
	| additive_expression '-' multiplicative_expression 
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression		
	| shift_expression RIGHT_OP additive_expression		
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression 	
	| relational_expression '>' shift_expression 	
	| relational_expression LE_OP shift_expression 
	| relational_expression GE_OP shift_expression 
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression 	
	| equality_expression NE_OP relational_expression 	
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression 	
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression 	
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression 	
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression 
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression 	
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression 
	| unary_expression assignment_operator assignment_expression 
	;

assignment_operator
	: '=' {
		// 포인터함수 고친다면 여기서
		strcpy(callee, "");
	}
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
	: assignment_expression{
		if (isfunc == 0) strcpy(callee,"");
    }
	| expression ',' assignment_expression{
		if (isfunc == 0) strcpy(callee,"");
    }
	;

constant_expression
	: conditional_expression 
	;

declaration
	: declaration_specifiers ';' {strcpy(callee, "");}
	| declaration_specifiers init_declarator_list ';' {strcpy(callee, "");}
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
	| declarator '=' initializer  
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
	| CHAR 
	| SHORT 
	| INT 
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
	: struct_or_union '{' struct_declaration_list '}' 
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}' 
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
	| IDENTIFIER '=' constant_expression 
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator {ptrfunc = 1;}
	| direct_declarator 
	;

direct_declarator
	: IDENTIFIER {
		// Save caller name (func name)
        if (isempty(caller)) {
            strcpy(caller,name);
            cur = query_idx(caller);
            if (cur < 0){
                strcpy(str2func[funcidx], caller);
                cur = funcidx;
                funcidx++;
            }
        }
    }
	| '(' declarator ')' {
        if (ptrfunc){
			/* save func ptr name*/
            cur = query_idx(caller);
            if (cur < 0){
                strcpy(str2func[funcidx], caller);
                cur = funcidx;
                funcidx++;                
            }
            func[cur] = 1;

            nxt = query_ptr_idx(name);
			if (nxt < 0){
				strcpy(ptr2func[ptrfuncidx], name);
				//printf("######ptr func : %s\n",ptr2func[ptrfuncidx]);
                nxt = ptrfuncidx;
                // connect caller <-> ptr func
				ptrfuncidx++;
			}
        }
        ptrfunc = 0;
    }
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
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator 
	| declaration_specifiers 
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
	: labeled_statement {strcpy(callee, "");}
	| compound_statement {strcpy(callee, "");}
	| expression_statement {strcpy(callee, "");}
	| selection_statement {strcpy(callee, "");}
	| iteration_statement {strcpy(callee, "");}
	| jump_statement {strcpy(callee, "");}
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{'  block_item_list '}'
	;

block_item_list
	: block_item
	| block_item_list block_item
	;

block_item
	: declaration
	| statement
	;

expression_statement
	: ';'
	| expression ';'{
			nxt = query_idx(callee);
			if (nxt < 0){
				strcpy(str2func[funcidx], callee);
				nxt = funcidx;
				funcidx++;
			}
			if(isfunc) func[nxt] = 1; 
			isfunc=0;
			strcpy(callee, "");
        }
	;

selection_statement
	: IF '(' expression ')' statement %prec LOWER_THEN_ELSE 	
	| IF '(' expression ')' statement ELSE statement			
	| SWITCH '(' expression ')' statement 						
	;

iteration_statement
	: WHILE '(' expression ')' statement	
	| DO statement WHILE '(' expression ')' ';' 
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement  
	| FOR '(' declaration expression_statement ')' statement 
	| FOR '(' declaration expression_statement expression ')' statement  
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'  
	| RETURN expression ';'{
			nxt = query_idx(callee);
			if (nxt < 0){
				strcpy(str2func[funcidx], callee);
				nxt = funcidx;
				funcidx++;
			}
			if(isfunc) func[nxt] = 1; 
			isfunc=0;
			strcpy(callee, "");
        }
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration 
	: function_definition{
        cur = query_idx(caller);
        if (cur < 0){
                strcpy(str2func[funcidx], caller);
                cur = funcidx;
                funcidx++;
		}
        if (isfunc) func[cur] = 1;
        strcpy(caller,"");
        isfunc = 0;
    }
	| declaration{
    	strcpy(caller, "");
		strcpy(callee, "");
    }
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement 
	| declaration_specifiers declarator compound_statement 
	| declarator declaration_list compound_statement 
	| declarator compound_statement 
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

%%

int main(void){
    for (iter = 0 ; iter < MAX; iter++){
        for (iter2 = 0; iter2 < MAX; iter2++){
            adj[iter][iter2].l = NULL;
        }
    }
	yyparse();
	graph = fopen("B711016.gv","w");
	fprintf(graph,"digraph{\n");
    fprintf(graph,"edge [color=black]\n");
    dfs("main");
	fprintf(graph,"}");
	fclose(graph);
    system("dot -Tjpg B711016.gv -o B711016.jpg");
	return 0;
}

void yyerror(const char *str)
{
	fprintf(stderr, "error: %s\n", str);
}
