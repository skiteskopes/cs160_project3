alpha [a-zA-Z] 
digit [0-9]
%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
	void yyerror(const char *);
%}
%% 
[ \t]   ; 
[ \n] {yylineo = yylineo +1;}
"if" return T_IF; 
"else" return T_ELSE; 
"while" return T_WHILE; 
"print" return T_PRINT; 
"return" return T_RETURN;  
"new" return T_NEW; 
"integer" return T_INTEGER; 
"boolean" return T_BOOLEAN; 
"none" return T_NONE; 
"equals" return T_EQUALS; 
"and" return T_AND; 
"or" return T_OR; 
"not" return T_NOT; 
"true" return T_TRUE; 
"false" return T_FALSE; 
"extends" return T_EXTENDS; 
"do" return T_DO;  
"not" return T_NOT; 
{digit}+ return T_NUM; 
{alpha}({alpha}|{digit})* return T_ID; 
"=" return T_ASSI; 
">=" return T_GREATEQ; 
">" return T_GT; 
"+" return T_ADD;  
"-" return T_SUB; 
"*" return T_MULT; 
"/" return T_DIV; 
"/*" {comment();}

.                 { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}  

void comment(void)
{
	char c, prev = 0;
  
	while ((c = input()) != 0)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	yyerror("dangling comment");
}
