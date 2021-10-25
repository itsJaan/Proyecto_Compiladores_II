%option noyywrap
%option yylineno

%{
    #include <stdio.h>
    #include "main.cpp"
    enum yytokentype{
    //PALABRAS RESERVADAS
        TK_BREAK = 258,
        TK_FUNC = 259,
        TK_ELSE = 260,
        TK_IF = 261,
        TK_PACKAGE = 262,
        TK_CONTINUE = 263,
        TK_FOR = 264,
        TK_IMPORT = 265,
        TK_RETURN = 266,
        TK_VAR = 267,
        TK_TRUE = 268,
        TK_FALSE = 269,

        //TIPOS DATOS
        TK_ID = 270,
        TK_LIT_INT = 271,
        TK_LIT_FLOAT =272,
        TK_LIT_STRING =273,
        
        //OPERACIONES ARIMETICAS
        TK_PLUS = 274,
        TK_MINUS = 275,
        TK_DIV = 276,
        TK_MULT = 277,
        
        //SIGNOS
        TK_PAR_A = 278,
        TK_PAR_C = 279,
        TK_BRACKET_A = 280,
        TK_BRACKET_C = 281,
        TK_LLAVE_A = 282,
        TK_LLAVE_C = 283,
        TK_PUNTO = 284,
        TK_COMA = 285,
        TK_SEMICOLUMN = 286,
        TK_COLUMN = 287, 
        TK_POT = 288,
        TK_EQUAL = 289,
        TK_GREATER = 290,
        TK_LESS = 291,
        TK_PORC = 292,
        TK_NOT = 293,
        

        TK_PLUS_EQUAL =294,
        TK_MINUS_EQUAL =295,
        TK_PLUS_PLUS =296,
        TK_MINUS_MINUS =297,
        TK_OR = 298,
        TK_AND = 299,
        TK_NOT_EQUAL = 300,
        TK_OR_EQUAL = 301,
        TK_GREATER_EQUAL = 302,
        TK_LESS_EQUAL = 303,
        TK_AND_EQUAL = 304,
        TK_MULT_EQUAL = 305,
        TK_POT_EQUAL = 306, 
        TK_DIV_EQUAL = 307,
        TK_COLUMN_EQUAL = 308,
        TK_PORC_EQUAL = 309,

        TK_COMMENT = 310,
        TK_MULTLINE_COMMENT = 311
    };
    int yylval;
%}

DIGIT [0-9]
COMMENT [/][/].*[^\n]
MULTILINECOMMENT [/][\*]((.)*\n*)*[\*][/]

BREAK "break"
FUNC "func"
ELSE "else"
IF "if"
PACKAGE "package"
CONTINUE "continue"
FOR "for"
IMPORT "import"
RETURN "return"
VAR "var"
TRUE "true"
FALSE "false"

ID [A-Za-z][a-zA-Z0-9]* 
LIT_FLOAT {DIGIT}+"."{DIGIT}+ 
LIT_STRING [\"].*[\"] 

PLUS "+"
MINUS "-"
DIV "/"
MULT "*"

PAR_A "("
PAR_C ")"
BRACKET_A "["
BRACKET_C "]"
LLAVE_A "{"
LLAVE_C "}"
PUNTO "."
COMA ","
SEMICOLUMN ";"
COLUMN ":" 
POT "^"
EQUAL "="
GREATER ">"
LESS "<"
PORC "%"
NOT "!"

PLUS_EQUAL "+="
MINUS_EQUAL "-="
PLUS_PLUS  "++"
MINUS_MINUS "--"
OR "||"
AND "&&"
NOT_EQUAL "!=" 
OR_EQUAL  "|="
GREATER_EQUAL ">="
LESS_EQUAL "<="
AND_EQUAL "&="
MULT_EQUAL "*="
POT_EQUAL  "^="
DIV_EQUAL  "/="
COLUMN_EQUAL ":="
PORC_EQUAL  "%="


%%

[ \t\n\r] {/*nada*/}
{DIGIT}+ {return TK_LIT_INT;}
{BREAK} {return TK_BREAK;}
{FUNC} {return TK_FUNC;}
{ELSE} {return TK_ELSE;}
{IF} {return TK_IF;}
{PACKAGE} {return TK_PACKAGE;}
{CONTINUE} {return TK_CONTINUE;}
{FOR} {return TK_FOR;}
{IMPORT} {return TK_IMPORT;}
{RETURN} {return TK_RETURN;}
{VAR} {return TK_VAR;}
{TRUE} {return TK_TRUE;}
{FALSE} {return TK_FALSE;}

{ID} {return TK_ID;}
{LIT_FLOAT} {return TK_LIT_FLOAT;}
{LIT_STRING} {return TK_LIT_STRING;}

{PLUS} {return TK_PLUS;}
{MINUS} {return TK_MINUS;}
{DIV} {return TK_DIV;}
{MULT} {return TK_MULT;}

{PAR_A} {return TK_PAR_A;}
{PAR_C} {return TK_PAR_C;}
{BRACKET_A} {return TK_BRACKET_A;}
{BRACKET_C} {return TK_BRACKET_C;}
{LLAVE_A} {return TK_LLAVE_A;}
{LLAVE_C} {return TK_LLAVE_C;}
{PUNTO} {return TK_PUNTO;}
{COMA} {return TK_COMA;}
{SEMICOLUMN} {return TK_SEMICOLUMN;}
{COLUMN} {return TK_COLUMN;}
{POT} {return TK_POT;}
{EQUAL} {return TK_EQUAL;}
{GREATER} {return TK_GREATER;}
{LESS} {return TK_LESS;}
{PORC} {return TK_PORC;}
{NOT} {return TK_NOT;}
{PLUS_EQUAL} {return TK_PLUS_EQUAL;}
{MINUS_EQUAL} {return TK_MINUS_EQUAL;}
{PLUS_PLUS} {return TK_PLUS_PLUS;}
{MINUS_MINUS} {return TK_MINUS_MINUS;}
{OR} {return TK_OR;}
{AND} {return TK_AND;}
{NOT_EQUAL} {return TK_NOT_EQUAL;}
{OR_EQUAL} {return TK_OR_EQUAL;}
{GREATER_EQUAL} {return TK_GREATER_EQUAL;}
{LESS_EQUAL} {return TK_LESS_EQUAL;}
{AND_EQUAL} {return TK_AND_EQUAL;}
{MULT_EQUAL} {return TK_MULT_EQUAL;}
{POT_EQUAL} {return TK_POT_EQUAL;}
{DIV_EQUAL} {return TK_DIV_EQUAL;}
{COLUMN_EQUAL} {return TK_COLUMN_EQUAL;}
{PORC_EQUAL} {return TK_PORC_EQUAL;}


{COMMENT} {return TK_COMMENT;}
{MULTILINECOMMENT} {return TK_MULTLINE_COMMENT;}
. {printf("Error Lexico Linea %d signo %s no existe\n" , yylineno , yytext);}

%%