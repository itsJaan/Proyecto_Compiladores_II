%code requires{
  #include "ast.h"
}
%{

    #include <cstdio>
    #include <list>
    #include "asm.h"
    #include <fstream>
    #include <iostream>

    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
    #define YYDEBUG 1

    Asm assemblyFile;

    void writeFile(string name){
        ofstream file;
        file.open(name);
        file << assemblyFile.data << endl
        << assemblyFile.global <<endl
        << assemblyFile.text << endl;
        
        file.close();
    }
%}

%union{
    int int_t;
    float float_t;
    bool bool_t;
    char * string_t;
    Declaration * decl_t;
    Assignment  * assign_t;
    Function * func_t;
    Parameter * param_t;
    Ids * id;
    Decl * de_t;
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

%type <int_t> assign_types n_types types list_assign_types params_call bool
%type <decl_t> declaration array tk_id
%type <assign_t> assignment dec_inc 
%type <de_t> array_type op X V T U arithmetic
%type <id> list_id 
%type <string_t> binary_operator rel_operator call_function func_id
%type <func_t> function import
%type <param_t> param;
%%


uc: package import functions {
    Program * p = new Program();
    p->writeFile();
};

package: TK_PACKAGE TK_ID ;

import: TK_IMPORT TK_LIT_STRING     { Program *tmp = new Program(); tmp->ProgramPushContext(); $$= new Function($2,0, yylineno); $$->addFunction();}
      | TK_IMPORT TK_PAR_A list_lit_strings TK_PAR_C 
      ;

list_lit_strings: TK_LIT_STRING      {Program *tmp1 = new Program(); tmp1->ProgramPushContext(); Function *tmp = new Function($1,0, yylineno); tmp->addFunction();}
                | TK_LIT_STRING list_lit_strings {Program *tmp1 = new Program(); tmp1->ProgramPushContext(); Function *tmp = new Function($1,0, yylineno); tmp->addFunction();}
                ;

functions: function 
         | function functions 
         ;

function: func_id TK_PAR_A params TK_PAR_C isArray n_types TK_LLAVE_A infunctions TK_LLAVE_C {$$= new Function($1, ($6+10), yylineno);
                                                                                                                   $$->addFunction();
                                                                                                                   $$->endFuncGenCode();}
        | func_id TK_PAR_A params TK_PAR_C n_types TK_LLAVE_A infunctions TK_LLAVE_C {$$= new Function($1, $5, yylineno);
                                                                                          $$->addFunction();
                                                                                          $$->endFuncGenCode();
                                                                                    }
        ;
isArray : TK_BRACKET_A TK_BRACKET_C {Program *tmp = new Program(); tmp->isArray();} 
        ;
func_id:TK_FUNC TK_ID {$$= $2; Program *tmp = new Program(); tmp->ProgramPushContext();
                       Function * f = new Function(" ", 0, 0);
                       f->idNameGenCode($2);
}
            ;
n_types : types  { $$ = $1; Program *tmp = new Program(); tmp->saveFuncType(($1));
                  Function * f = new Function(" ", 0, 0);
                  f->funcStackGenCode();
}
        | /* E */{ $$ = 0;
                   Function * f = new Function(" ", 0, 0);
                   f->funcStackGenCode();}
        ; 


types: TK_STRING {$$ = 1;}
     | TK_BOOL   {$$ = 2;}
     | TK_INT    {$$ = 3;}
     | TK_FLOAT  {$$ = 4;}
     ;

params: /* E */ 
      | param TK_COMA params_no_empty 
      | param                                               
      ;

params_no_empty: param
      | param TK_COMA params_no_empty
      ;


param: TK_ID TK_BRACKET_A TK_BRACKET_C types {$$ = new Parameter($1 , ($4+10));
                                              $$->addParameter();
                                              $$->paramGenCode();} 
     |TK_ID types {$$ = new Parameter($1 , $2);
                   $$->addParameter();
                   $$->paramGenCode();}
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
//VALIDAR ASSIGNACIONES
assignment: list_id TK_EQUAL list_assign_types  {$$ = new Assignment(yylineno); $$->evaluateAssignment();
                                                 Array * arr = new Array(yylineno); arr->clearArrayValues();
                                                }
          | TK_ID TK_BRACKET_A arithmetic TK_BRACKET_C TK_EQUAL assign_types {$$ = new Assignment(yylineno); $$->evaluateAssignment();}
          | dec_inc 
          ;

breakers: TK_CONTINUE            {Declaration *tmp  = new Declaration(0,yylineno,false, 0); tmp->evaluateContinue();} 
        | TK_BREAK               {Declaration *tmp  = new Declaration(0,yylineno,false, 0); tmp->evaluateBreak();} 
        | TK_RETURN assign_types {Declaration *tmp  = new Declaration(0,yylineno,false, 0); tmp->evaluateReturn($2);}
        ;

declaration: TK_VAR list_id types { $$ = new Declaration($3, yylineno, false , 0);
                                    $$->addDeclaration();
                                  }
           | TK_VAR list_id TK_EQUAL list_assign_types {
              Array * arr = new Array(yylineno); arr->clearArrayValues();
              $$ = new Declaration(0, yylineno, false , 0);
              $$->addDeclaration();
           }
           | list_id TK_COLUMN_EQUAL list_assign_types {
              Array * arr = new Array(yylineno); arr->clearArrayValues();
              $$ = new Declaration(0, yylineno , false, 0);
              $$->addDeclaration();
           } 
           | breakers
           | call_function   {Function * tmp = new Function("",0,yylineno); tmp->evaluateCall($1);}
           | array           
           ;

array: TK_VAR TK_ID array_type { 
                                 
                                 Ids * tmp = new Ids($2);
                                 // printf("valor de: %d\n", $3->type);
                                 tmp->addToList(); 
                                 tmp->addTypeToList($3->type);
                                 $$ = new Declaration(($3->type+10), yylineno, true , $3->size); 
                                 $$->addDeclaration(); }
     ;


array_type: TK_BRACKET_A arithmetic TK_BRACKET_C types { 
                                                         Decl * s = new Decl();
                                                         s->type =  $2->type; 
                                                         s->size =  $2->size; 
                                                         // printf("valor del entero3: %d\n", $2->size);
                                                         // printf("valor de tipo: %d\n", s->type);
                                                         // printf("valor de size: %d\n", s->size);
                                                         Declaration * tmp = new Declaration(0, yylineno, false , 0);
                                                         tmp->validArraySize($2->type, $2->size);
                                                         $$ = s;
                                                      }//Ids * tmp = new Ids("") ; tmp->addTypeToList($4); }



list_assign_types: assign_types { Ids * tmp = new Ids("") ; tmp->addTypeToList($1);  Array * arr = new Array(yylineno); arr->newArrayValue();}
                 | binary_operation { Ids * tmp = new Ids("") ; tmp->addTypeToList(2); Array * arr = new Array(yylineno); arr->newArrayValue();}
                 | assign_types TK_COMA list_assign_types { Ids * tmp = new Ids("") ; tmp->addTypeToList($1); Array * arr = new Array(yylineno); arr->newArrayValue();}
                 | binary_operation TK_COMA list_assign_types  { Ids * tmp = new Ids("") ; tmp->addTypeToList(2); Array * arr = new Array(yylineno); arr->newArrayValue();}

                 ;

list_id: TK_ID { $$ = new Ids($1); $$->addToList(); }
       | TK_ID TK_COMA list_id { $$ = new Ids($1); $$->addToList(); }
       ;
       

assign_types:
            
            arithmetic { $$ = $1->type; 
                           Arith * tmp = new Arith(yylineno);
                           tmp->evaluate();
                         }
            | TK_ID TK_BRACKET_A arithmetic TK_BRACKET_C {Ids  * tmp = new Ids($1);
                                                          $$ = tmp->getType();
                                                        }
            | TK_BRACKET_A arithmetic TK_BRACKET_C types TK_LLAVE_A list_assign_types TK_LLAVE_C { $$ = ($4+10); 
                                                                                                   Assignment *tmp = new Assignment(yylineno); 
                                                                                                   tmp->evaluateArray($4, $2->size, $2->value); 
                                                                                                 }
            ;

arithmetic: op V {$$ = $1;}
          | TK_PAR_A arithmetic C V { $$ = $4;}
          ;


V: TK_MULT T X  {$$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(3);
    tmp->multGenCode();
}
 | TK_DIV T X { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(4);
    tmp->divGenCode();
 }
 | TK_PORC T X { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(5);
 }
 | TK_PLUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(1);
    tmp->sumGenCode();
 }
 | TK_MINUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(2);
    tmp->subGenCode();
 }

 | /* */
 ;

X: /* */
 | TK_PLUS arithmetic { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(1);
    tmp->sumGenCode();
 }
 | TK_MINUS arithmetic { $$ = $2; 
     Arith * tmp = new Arith(yylineno);
    tmp->addSign(2);
    tmp->subGenCode();
 }
 ;

T: op U {$$ = $1;} 
 | TK_PAR_A arithmetic C U { $$ = $2; }
 ;

U: TK_MULT T {$$ = $2;
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(3);
    tmp->multGenCode();
}
 | TK_DIV T { $$ = $2; 
    Arith * tmp = new Arith(yylineno);
    tmp->addSign(4);
    tmp->divGenCode();
 }
 | /* */
 ;

C: TK_PAR_C
 ;

op: TK_LIT_INT { Decl * s = new Decl();
                s-> type = 3;
                Arith * tmp = new Arith(yylineno);
                tmp->addOp(3);
               //   printf("valor del entero: %d\n", $1);
                s->size = 3;
                s->value = $1;
                $$ = s;
                Declaration *d = new Declaration(0,yylineno,false, 0);
                d->intDeclGenCode($1);
               }
  | TK_LIT_FLOAT {Decl * s = new Decl();
                  s-> type = 4;
                  Arith * tmp = new Arith(yylineno);
                  tmp->addOp(4);
                  s->size = 0;  
                  $$ = s;
                  Declaration *d = new Declaration(0,yylineno,false, 0);
                  d->floatDeclGenCode($1);
                 }
  |TK_LIT_STRING {Decl * s = new Decl();
                  s-> type = 1;
                  Arith * tmp = new Arith(yylineno);
                  tmp->addOp(1); 
                  s->size = 0; 
                  $$ = s;
                  Declaration *d = new Declaration(0,yylineno,false, 0);
                  d->stringDeclGenCode($1);
                 }
  | TK_ID { Decl * s = new Decl();
          Ids  * tmp = new Ids($1);
          s-> type = tmp->getType();
          Arith * tmp2 = new Arith(yylineno);
          tmp2->addOp(s->type);
         //  printf("valor del id: %d\n", tmp->getSize());
          s->size = s->type == 3 ? 3 : 0; 
          $$ = s;
  }
  | TK_TRUE {Decl * s = new Decl();
            s-> type = 2;
          Arith * tmp2 = new Arith(yylineno);
          tmp2->addOp(2);
          s->size = 0; 
          $$ = s;
          Declaration *d = new Declaration(0,yylineno,false, 0);
          d->boolDeclGenCode(1);
  }
  | TK_FALSE {Decl * s = new Decl();
              s-> type = 2;
              Arith * tmp2 = new Arith(yylineno);
              tmp2->addOp(2);  
              s->size = 0; 
              $$ = s;
              Declaration *d = new Declaration(0,yylineno,false, 0);
              d->boolDeclGenCode(0);
  }
  
  | call_function {Decl * s = new Decl(); Function * tmp = new Function("",0,yylineno);  
                  s-> type = tmp->evaluateCall($1);
                   s->size = 0; 
                   $$ = s;}
  ;

statement: statement_if
         | statement_for
         ;

statement_if: tk_if condition_if TK_LLAVE_A infunctions llave_c              
            | tk_if condition_if TK_LLAVE_A infunctions llave_c statement_else   
            ;
llave_c: TK_LLAVE_C {Program * tmp2 = new Program(); tmp2->ProgramPopContext();}
       ;

statement_else: tk_else TK_IF condition_if TK_LLAVE_A infunctions llave_c 
              | tk_else TK_LLAVE_A infunctions llave_c   
              | tk_else TK_IF condition_if TK_LLAVE_A infunctions llave_c statement_else
              ;
tk_if : TK_IF {Program * tmp2 = new Program(); tmp2->ProgramPushContext();}
      ;
tk_else:TK_ELSE {Program * tmp2 = new Program(); tmp2->ProgramPushContext();}
       ;
condition_if: assign_types rel_operator assign_types binary_operator condition_if {BinaryOp * tmp  = new BinaryOp($1,$3, yylineno); tmp->evaluate();}
            | assign_types binary_operator condition_if                           {BinaryOp * tmp  = new BinaryOp($1,0, yylineno); tmp->evaluate();}
            | assign_types                                                        {BinaryOp * tmp  = new BinaryOp($1,0, yylineno); tmp->evaluate(); }
            | assign_types rel_operator assign_types                              {BinaryOp * tmp  = new BinaryOp($1,$3, yylineno); tmp->evaluate();}
            | TK_NOT bool                                                         {BinaryOp * tmp  = new BinaryOp($2,0, yylineno); tmp->evaluate(); }
            | TK_NOT bool binary_operator condition_if                            {BinaryOp * tmp  = new BinaryOp($2,0, yylineno); tmp->evaluate();}
            ;
bool: TK_ID    {Ids * tmp = new Ids($1); $$ = tmp->getType(); }
    | TK_FALSE {$$ = 2;}
    | TK_TRUE  {$$ = 2;}
    ;
statement_for: tk_for condition_for TK_LLAVE_A infunctions llave_c {Program * tmp2 = new Program(); tmp2->exitingFor();}

condition_for: condition_if
             | tk_id TK_SEMICOLUMN condition_if TK_SEMICOLUMN  dec_inc 
             |/* E */
             ;
tk_for: TK_FOR {Program * tmp2 = new Program(); tmp2->ProgramPushContext(); tmp2->enteringFor();}
      ;
tk_id: TK_ID TK_COLUMN_EQUAL assign_types {Ids *id = new Ids($1); id->addToList();id->addTypeToList($3);
                                           $$ = new Declaration(0, yylineno , false, 0); $$->addDeclaration();}
     ;

dec_inc: TK_ID TK_PLUS_PLUS {$$ = new Assignment(yylineno); $$->evaluateIncreDecre($1);}
       | TK_ID TK_MINUS_MINUS {$$ = new Assignment(yylineno); $$->evaluateIncreDecre($1);}
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



call_function: TK_ID TK_PAR_A params_call TK_PAR_C    {$$=$1;}
             | TK_ID TK_PUNTO TK_ID TK_PAR_A params_call TK_PAR_C   //{$$=$1;}
             ;

params_call: /* */                                       
           | assign_types                         {CalledParam *tmp = new CalledParam($1, yylineno); tmp->addCalledParam();}               
           | binary_operation                     {CalledParam *tmp = new CalledParam(2, yylineno); tmp->addCalledParam();}
           | assign_types TK_COMA params_call     {CalledParam *tmp = new CalledParam($1, yylineno); tmp->addCalledParam();}     
           | binary_operation TK_COMA params_call {CalledParam *tmp = new CalledParam(2, yylineno); tmp->addCalledParam();}
           ;


binary_operation: assign_types rel_operator assign_types { BinaryOp * tmp = new BinaryOp($1, $3, yylineno); 
                                                           tmp->evaluate();
                                                         }
                | assign_types binary_operator assign_types { BinaryOp * tmp = new BinaryOp($1, $3, yylineno);
                                                              tmp->evaluateBinaryOperator();
                                                            }
                ;

%%