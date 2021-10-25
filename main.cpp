#include <stdio.h>
#include <string>

using namespace std;

extern FILE * yyin;
extern char* yytext;
int yylex(void);

int main(int argc, char* argv[]){
    if(argc != 2){
        fprintf(stderr, "Hace falta el archivo de entrada %s\n", argv[0]);
        return 1;
    }
    
    FILE * f = fopen(argv[1], "r");
    if (f == NULL)
    {
        fprintf(stderr, "No se pudo abrir el archivo %s\n", argv[1]);
        return 1;
    }

    yyin = f;

    int token = yylex();
    while(token != 0){
        printf("%d - %s\n", token, yytext);
        token = yylex();
    }

    return 0;
}