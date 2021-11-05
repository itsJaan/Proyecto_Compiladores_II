%option noyywrap
%option yylineno

%{
    #include "tokens.h"
    extern int yylval;
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
BOOL "bool"
TRUE "true"
FALSE "false"
INT "int"
FLOAT "float"
STRING "string"

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

[ \t\r\n] {/*nada*/}
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
{BOOL} {return TK_BOOL;}
{TRUE} {return TK_TRUE;}
{FALSE} {return TK_FALSE;}
{INT} {return TK_INT;}
{FLOAT} {return TK_FLOAT;}
{STRING} {return TK_STRING;}

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
