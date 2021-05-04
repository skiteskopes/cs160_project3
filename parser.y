%{
    #include <cstdlib>
    #include <cstdio>
    #include <iostream>

    #define YYDEBUG 1

    int yylex(void);
    void yyerror(const char *);
%}

%define parse.error verbose

%token T_INTEGER T_BOOLEAN   
%token T_WHILE 
%token T_IF T_ELSE   
%token T_EXTENDS T_DO  T_PRINT T_RETURN T_NEW
%token T_NUM T_NONE T_ID  T_FALSE T_TRUE  
%token T_OPENP T_CLOSEP T_OPENB T_CLOSEB T_SEMI T_COMM T_PERIOD T_RET 
%token T_ASSI   
%left T_OR  
%left T_AND 
%left T_GREATEQ  T_GT  T_EQUALS
%left T_ADD T_SUB  
%left T_MULT T_DIV  
%right T_NOT T_UNARYMINUS 

%%

Start : CLASSES  
      ;     

TYPE : T_INTEGER 
      | T_BOOLEAN 
      | T_ID 
      ;   

IF : T_IF EXP T_OPENB BLOCK T_CLOSEB ELSE 
      ;
ELSE: T_ELSE T_OPENB BLOCK T_CLOSEB  
      |  epsilon 
      ; 
DO: T_DO T_OPENB BLOCK T_CLOSEB SPECWHILE 
      ;
WHILE: T_WHILE EXP T_OPENB BLOCK T_CLOSEB 
      ;  
SPECWHILE: T_WHILE EXP T_SEMI 
PRINT: T_PRINT EXP T_SEMI 
      ;
BLOCK: STATEMENT STATEMENT1  
      ;
STATEMENT:  T_ID T_ASSI EXP T_SEMI 
            | T_ID T_PERIOD T_ID T_ASSI EXP T_SEMI 
            | PRINT 
            | IF 
            | DO 
            | WHILE 
            | METHODCALL  
      ;
STATEMENT1: STATEMENT STATEMENT1  
      | epsilon 
      ;
EXP: EXP T_ADD EXP 
      | T_SUB EXP %prec T_UNARYMINUS 
      | EXP T_SUB EXP  
      | EXP T_MULT EXP 
      | EXP T_DIV EXP 
      | EXP T_GT EXP 
      | EXP T_GREATEQ EXP 
      | EXP T_EQUALS EXP 
      | EXP T_AND EXP 
      | EXP T_OR EXP 
      | EXP T_NOT EXP  
      | T_NOT EXP 
      | T_ID  
      | T_ID T_PERIOD T_ID  
      | METHODCALL  
      | T_OPENP EXP T_CLOSEP 
      | T_NUM 
      | T_TRUE 
      | T_FALSE 
      | T_NEW T_ID 
      | T_NEW T_ID T_OPENP ARGUMENTS T_CLOSEP 

      ;
ARGUMENTS: ARGUMENTS1  
      |  epsilon 
            ;
ARGUMENTS1: ARGUMENTS1 T_COMM EXP 
            | EXP 
            ;  

METHODCALL: T_ID T_OPENP ARGUMENTS T_CLOSEP 
      | T_ID T_PERIOD T_ID T_OPENP ARGUMENTS T_CLOSEP
      ;



PARAMETERS: TYPE T_ID PARAMETERS1 
            |  epsilon 
            ;  
PARAMETERS1: T_COMM TYPE T_ID PARAMETERS1 
            |  epsilon 
            ; 



RETURN : T_RETURN EXP T_SEMI 
      |  epsilon 
      ;   

DEC: DEC TYPE T_ID IDLIST  T_SEMI 
      |  epsilon 
            ; 
BODY: DEC STATEMENT1 RETURN   
      
      ;  
IDLIST:  T_COMM T_ID  IDLIST   
       |  %empty 
       ; 
CLASSES: CLASS CLASS1 
      ;  

CLASS: T_ID T_EXTENDS T_ID T_OPENB MEMBERS METHOD T_CLOSEB  
      | T_ID T_OPENB MEMBERS  METHOD T_CLOSEB 
      ; 
 
METHOD: T_ID T_OPENP PARAMETERS T_CLOSEP T_RET MORETYPE T_OPENB BODY T_CLOSEB METHOD 
      | %empty
      ;


MEMBERS: MEMBERS TYPE T_ID T_SEMI    
      | epsilon      
      ; 
CLASS1: CLASS CLASS1 
      |  epsilon 
      ; 

epsilon : %empty ; 

MORETYPE: T_NONE 
      | T_ID 
      | T_INTEGER 
      | T_BOOLEAN 
      ;

%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(1);
}
