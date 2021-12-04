%code requires{
  #include "ast.h"
}
%{

    #include <cstdio>
    #include <list>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
    #define YYDEBUG 1
%}

%union{
    int int_t;
    float float_t;
    bool bool_t;
    char * string_t;
    Declaration * decl_t;
    Ids * id;
}

%token TK_BREAK TK_FUNC TK_ELSE TK_IF TK_PACKAGE TK_CONTINUE TK_FOR TK_IMPORT TK_RETURN TK_VAR  TK_BOOL TK_INT TK_FLOAT TK_STRING 
%token <string_t> TK_ID TK_LIT_STRING 
%token <string_t> TK_OR TK_AND TK_NOT_EQUAL TK_GREATER_EQUAL TK_LESS_EQUAL TK_GREATER TK_LESS TK_EQUAL
%token <int_t> TK_LIT_INT 
%token <float_t> TK_LIT_FLOAT 
%token <bool_t> TK_TRUE TK_FALSE
%token TK_PLUS TK_MINUS TK_DIV TK_MULT 
%token TK_PAR_A TK_PAR_C TK_BRACKET_A TK_BRACKET_C TK_LLAVE_A TK_LLAVE_C TK_PUNTO TK_COMA TK_SEMICOLUMN TK_COLUMN TK_POT   TK_PORC TK_NOT 
%token TK_PLUS_EQUAL TK_MINUS_EQUAL TK_PLUS_PLUS TK_MINUS_MINUS  TK_OR_EQUAL  TK_AND_EQUAL TK_MULT_EQUAL TK_POT_EQUAL TK_DIV_EQUAL  TK_COLUMN_EQUAL TK_PORC_EQUAL 
%token TK_COMMENT TK_MULTLINE_COMMENT 
%token EOL

%type <int_t> assign_types op types arithmetic X V T U list_assign_types
%type <decl_t> declaration
%type <id> list_id
%type <string_t> binary_operator rel_operator
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

types: TK_INT { $$ = 3; }
     | TK_FLOAT {$$ = 4;}
     | TK_STRING {$$ = 1;}
     | TK_BOOL {$$ = 2;}
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

declaration: TK_VAR list_id types { $$ = new Declaration($3, yylineno);
                                    $$->addDeclaration();
                                  }
           | TK_VAR list_id TK_EQUAL list_assign_types {
              $$ = new Declaration(0, yylineno);
              $$->addDeclaration();
           }
           | list_id TK_COLUMN_EQUAL list_assign_types {
              $$ = new Declaration(0, yylineno);
              $$->addDeclaration();
           } 
           | breakers
           | call_function
           | array
           ;

array: TK_VAR TK_ID array_type
     ;


array_type: TK_BRACKET_A arithmetic TK_BRACKET_C types



list_assign_types: assign_types { Ids * tmp = new Ids("") ; tmp->addTypeToList($1); }
                 | binary_operation { Ids * tmp = new Ids("") ; tmp->addTypeToList(2); }
                 | assign_types TK_COMA list_assign_types { Ids * tmp = new Ids("") ; tmp->addTypeToList($1); }
                 | binary_operation TK_COMA list_assign_types  { Ids * tmp = new Ids("") ; tmp->addTypeToList(2); }
                 ;

list_id: TK_ID { $$ = new Ids($1); $$->addToList(); }
       | TK_ID TK_COMA list_id { $$ = new Ids($1); $$->addToList(); }
       ;
       

assign_types:
             TK_TRUE {$$=2;}
            | TK_FALSE {$$=2;}
            | arithmetic { $$ = $1; 
                           Arith * tmp = new Arith(yylineno);
                           tmp->evaluate();
                         }
            | TK_ID TK_BRACKET_A arithmetic TK_BRACKET_C {Ids  * tmp = new Ids($1);
                                                          $$ = tmp->getType();
                                                        }
            | TK_BRACKET_A arithmetic TK_BRACKET_C types TK_LLAVE_A list_assign_types TK_LLAVE_C { $$ = $4; }
            ;

arithmetic: op V { $$ = $1; 
                   
                 }
          | TK_PAR_A arithmetic C V { $$ = $4; }
          ;


V: TK_MULT T X  {$$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(3);
}
 | TK_DIV T X { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(4);
 }
 | TK_PORC T X { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(5);
 }
 | TK_PLUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(1);
 }
 | TK_MINUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(2);
 }
 | /* */
 ;


X: /* */
 | TK_PLUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(1);
 }
 | TK_MINUS arithmetic { $$ = $2; 
     Arith * tmp = new Arith(yylineno);
    tmp->addSign(2);
 }
 ;

T: op U {$$ = $1;} 
 | TK_PAR_A arithmetic C U { $$ = $2; }
 ;

U: TK_MULT T {$$ = $2;
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(3);
}
 | TK_DIV T { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(4);
 }
 | /* */
 ;

C: TK_PAR_C
 ;

op: TK_LIT_INT {$$ = 3;
                Arith * tmp = new Arith(yylineno);
                tmp->addOp(3);
               }
  | TK_LIT_FLOAT {$$ = 4;
                  Arith * tmp = new Arith(yylineno);
                  tmp->addOp(4);  
                 }
  |TK_LIT_STRING {$$=1;
                  Arith * tmp = new Arith(yylineno);
                  tmp->addOp(1); 
                 }
  | TK_ID {Ids  * tmp = new Ids($1);
          $$ = tmp->getType();
          Arith * tmp2 = new Arith(yylineno);
          tmp2->addOp(tmp->getType());
  }
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

rel_operator: TK_EQUAL TK_EQUAL { $$ = $1;}
            | TK_NOT_EQUAL { $$ = $1;}
            | TK_LESS { $$ = $1;}
            | TK_GREATER { $$ = $1;}
            | TK_LESS_EQUAL { $$ = $1;}
            | TK_GREATER_EQUAL { $$ = $1;}
            ;

binary_operator: TK_AND { $$ = $1;}
               | TK_OR { $$ = $1;}
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

binary_operation: assign_types rel_operator assign_types { BinaryOp * tmp = new BinaryOp($1, $3, yylineno, $2); 
                                                           tmp->evaluate();
                                                         }
                | assign_types binary_operator assign_types { BinaryOp * tmp = new BinaryOp($1, $3, yylineno, $2);
                                                              tmp->evaluate();
                                                            }
                ;

%%
