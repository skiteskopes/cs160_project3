%{
    #include <cstdlib>
    #include <cstdio>
    #include <iostream>

    #define YYDEBUG 1

    int yylex(void);
    void yyerror(const char *);
%}

%error-verbose

%token T_INTEGER T_BOOLEAN  
%token T_WHILE 
%token T_IF T_ELSE   
%token T_EXTENDS T_DO  T_PRINT T_RETURN T_NEW
%token T_NUM T_NONE T_ID  
%right T_ASSI  
%left T_OR  
%left T_AND 
%left T_GREATEQ  T_GT  T_EQUALS
%left T_ADD T_SUB  
%left T_MULT T_DIV  
%right T_NOT T_UNARYMINUS 

%%

/* WRITEME: This rule is a placeholder, since Bison requires
            at least one rule to run successfully. Replace
            this with your appropriate start rules. */
Start : TYPE  ID '(' ')' STATEMS
      ;        

TYPE : T_INTEGER 
      | T_BOOLEAN 
      | T_ID 
      ; 
  
EXP :   NEW ClassName 
        TRUE 

STATEMS : '{'STATEM'}'  /*inside curly bracket*/
      ;  

STATEM : STATEM1 STATEM   
      ; 

STATEM1 :  ASSIGN 
      | S_IF 
      | S_ELSE 
      | S_WHILE 
      | S_DO 
      | S_PRINT   
      | S_METHOD 
      | ';' 
      ;   

S_IF : T_IF EXP STATEMS  ELSE       
  ;
ELSE : T_ELSE  STATEMS        
  ;
S_WHILE : T_WHILE  EXP   STATEMS   
  ;
S_DO : T_DO STATEMS S_WHILE  

S_METHOD : ID '(' ARG ')' "->" TYPE 
          | ID '.' ID '(' ARG ')' "->" TYPE  
        ;
ARG : ARG1 
    |  
    ;   

ARG1 : ARG1 ',' EXP 
    | EXP 
    ;  

TYPE: INTEGER 
      | BOOLEAN 
      | NONE  
      | ID 
    ;  






/* WRITME: Write your Bison grammar specification here */  



%%

extern int yylineno;

void yyerror(const char *s) {
  fprintf(stderr, "%s at line %d\n", s, yylineno);
  exit(1);
}
