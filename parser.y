%{

    #include <cstdio>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
    #define YYDEBUG 1
%}

%token TK_BREAK TK_FUNC TK_ELSE TK_IF TK_PACKAGE TK_CONTINUE TK_FOR TK_IMPORT TK_RETURN TK_VAR TK_TRUE TK_FALSE TK_BOOL TK_INT TK_FLOAT TK_STRING 

%token TK_ID TK_LIT_INT TK_LIT_FLOAT TK_LIT_STRING 

%token TK_PLUS TK_MINUS TK_DIV TK_MULT 

%token  TK_PAR_A TK_PAR_C TK_BRACKET_A TK_BRACKET_C TK_LLAVE_A TK_LLAVE_C TK_PUNTO TK_COMA TK_SEMICOLUMN TK_COLUMN TK_POT TK_EQUAL TK_GREATER TK_LESS TK_PORC TK_NOT 

%token  TK_PLUS_EQUAL TK_MINUS_EQUAL TK_PLUS_PLUS TK_MINUS_MINUS TK_OR TK_AND TK_NOT_EQUAL TK_OR_EQUAL TK_GREATER_EQUAL TK_LESS_EQUAL TK_AND_EQUAL TK_MULT_EQUAL TK_POT_EQUAL TK_DIV_EQUAL  TK_COLUMN_EQUAL TK_PORC_EQUAL 

%token TK_COMMENT TK_MULTLINE_COMMENT 
    
%token EOL

%%

uc: package import functions ;

package: TK_PACKAGE TK_ID;

import: TK_IMPORT TK_LIT_STRING
      | TK_IMPORT TK_PAR_A list_lit_strings TK_PAR_C
      ;

list_lit_strings: TK_LIT_STRING
                | TK_LIT_STRING list_lit_strings
                ;

functions: function
         | function functions
         ;

function: TK_FUNC TK_ID TK_PAR_A params TK_PAR_C TK_BRACKET_A TK_BRACKET_C types TK_LLAVE_A infunctions TK_LLAVE_C
        | TK_FUNC TK_ID TK_PAR_A params TK_PAR_C types TK_LLAVE_A infunctions TK_LLAVE_C
        | TK_FUNC TK_ID TK_PAR_A params TK_PAR_C TK_LLAVE_A infunctions TK_LLAVE_C
        ;

types: TK_INT
     | TK_FLOAT
     | TK_STRING
     | TK_BOOL
     ;

params: /* E */
      | param TK_COMA params_no_empty 
      | param
      ;

params_no_empty: param
      | param TK_COMA params_no_empty
      ;


param: TK_ID TK_BRACKET_A TK_BRACKET_C types
     |TK_ID types
     ;

infunctions: /* E */
           | infunction infunctions
           ;

infunction:  declaration
          |  statement
          |  assignment
          |  comments
          ;
comments: TK_MULTLINE_COMMENT
        | TK_COMMENT
        ;

assignment: list_id TK_EQUAL list_assign_types
          | TK_ID TK_BRACKET_A arithmetic TK_BRACKET_C TK_EQUAL assign_types
          ;

breakers: TK_CONTINUE
        | TK_BREAK
        | TK_RETURN assign_types
        ;

declaration: TK_VAR list_id types
           | TK_VAR list_id TK_EQUAL list_assign_types
           | list_id TK_COLUMN_EQUAL list_assign_types  
           | breakers
           | call_function
           | array
           ;

array: TK_VAR TK_ID array_type
     ;


array_type: TK_BRACKET_A arithmetic TK_BRACKET_C types



list_assign_types: assign_types
                 | binary_operation
                 | assign_types TK_COMA list_assign_types
                 | binary_operation TK_COMA list_assign_types
                 ;

list_id: TK_ID
       | TK_ID TK_COMA list_id
       ;
       

assign_types:TK_LIT_STRING
            | TK_TRUE
            | TK_FALSE
            | arithmetic
            | TK_ID TK_BRACKET_A arithmetic TK_BRACKET_C
            | TK_BRACKET_A arithmetic TK_BRACKET_C types TK_LLAVE_A list_assign_types TK_LLAVE_C
            ;

arithmetic: op V
          | TK_PAR_A arithmetic C V
          ;


V: TK_MULT T X
 | TK_DIV T X
 | TK_PORC T X
 | TK_PLUS arithmetic
 | TK_MINUS arithmetic
 | /* */
 ;


X: /* */
 | TK_PLUS arithmetic
 | TK_MINUS arithmetic
 ;

T: op U
 | TK_PAR_A arithmetic C U
 ;

U: TK_MULT T
 | TK_DIV T
 | /* */
 ;

C: TK_PAR_C
 ;

op: TK_LIT_INT
  | TK_LIT_FLOAT
  | TK_ID
  | call_function
  ;

statement: statement_if
         | statement_for
         ;

statement_if: TK_IF condition_if TK_LLAVE_A infunctions TK_LLAVE_C
            | TK_IF condition_if TK_LLAVE_A infunctions TK_LLAVE_C statement_else
            ;

statement_else: TK_ELSE TK_IF condition_if TK_LLAVE_A infunctions TK_LLAVE_C 
              | TK_ELSE TK_LLAVE_A infunctions TK_LLAVE_C
              | TK_ELSE TK_IF condition_if TK_LLAVE_A infunctions TK_LLAVE_C statement_else
              ;

condition_if: assign_types rel_operator assign_types binary_operator condition_if
            | assign_types binary_operator condition_if
            | assign_types
            | assign_types rel_operator assign_types
            | TK_NOT bool
            | TK_NOT bool binary_operator condition_if
            ;
bool: TK_ID
    | TK_FALSE
    | TK_TRUE
    ;
statement_for: TK_FOR condition_for TK_LLAVE_A infunctions TK_LLAVE_C

condition_for: condition_if
             | TK_ID TK_COLUMN_EQUAL assign_types TK_SEMICOLUMN condition_if TK_SEMICOLUMN TK_ID dec_inc 
             |/* E */
             ;

dec_inc: TK_PLUS_PLUS
       | TK_MINUS_MINUS
       ;

rel_operator: TK_EQUAL TK_EQUAL
            | TK_NOT_EQUAL
            | TK_LESS
            | TK_GREATER
            | TK_LESS_EQUAL
            | TK_GREATER_EQUAL
            ;

binary_operator: TK_AND
               | TK_OR
               ;


call_function: TK_ID TK_PAR_A params_call TK_PAR_C
             | TK_ID TK_PUNTO TK_ID TK_PAR_A params_call TK_PAR_C
             ;

params_call: assign_types
           | binary_operation
           | assign_types TK_COMA list_assign_types 
           | binary_operation TK_COMA list_assign_types
           | /* */
           ;

binary_operation: assign_types rel_operator assign_types
                | assign_types binary_operator assign_types
                ;
                
%%