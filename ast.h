#include <string>
#include <list>
#include <map>
#include "code.h"
using namespace std;

string getIntTemp();
void releaseIntTemp(string temp);

string getFloatTemp();
void releaseFloatTemp(string temp);
enum type{
    STRING,
    BOOL,
    INT,
    FLOAT  
};

class Program{
    public:
        void printLists();
        void ProgramPushContext();
        void ProgramPopContext();
        void saveFuncType(int type);
        void isArray();
        void enteringFor();
        void exitingFor();
        void writeFile();
};

class Declaration{
    public:
        Declaration(int type , int line , bool isArray , int size){
            this->type = type;
            this->line = line;
            this->isArray = isArray;
            this->size = size;
        }
        int type;
        int line;
        bool isArray=false;
        int size=0;

        bool evaluate(string key , int line);
        void validArraySize(int type, int size); // verificar si el tipo es int y si es menor o igual a 0
        int addDeclaration();
        void evaluateReturn(int type);
        void evaluateBreak();
        void evaluateContinue();
        void genCode(Code &code);
};
class Assignment{
    public:
        Assignment(int line){
            this->line = line;
        } 
        int line;
        void evaluateAssignment();
        void evaluateIncreDecre(string name);
        void evaluateArray(int type, int size, int value);
        void genCode(Code &code);
};

class Ids{
    public:
        Ids(string name){
            this->name = name;
        }
        string name;
        void addToList();
        int getType();
        int getSize();
        void addTypeToList(int type);
        void genCode(Code &code);
};

class BinaryOp{
    public:
        BinaryOp(int left, int right, int line){
            this->left = left;
            this->right = right;
            this->line = line;
        }
        int left;
        int right;
        int line;
        void evaluate();
        void evaluateBinaryOperator();
        void genCode(Code &code);
};

class Arith{
    public:
        Arith(int line){
            this->line = line;
        }
        int line;
        void evaluate();
        void addOp(int type);
        void addSign(int sign);
        void clearList();
        void genCode(Code &code);
};

class Function{
    public:
        Function(string name, int type, int line){
            this->name = name;
            this->type = type;
            this->line = line;
        }
        string name;
        int type;
        int params;
        int line;
        
        void addFunction();
        int evaluateCall(string name);
        void idNameGenCode(string name);
        void funcStackGenCode();
        void endFuncGenCode();
        
};
class Parameter{
    public:
        Parameter(string name , int type){
            this->name = name;
            this->type = type;
        }
        string name;
        int type;
        void addParameter();
        void paramGenCode();
};
class CalledParam{
    public:
        CalledParam(int type, int line){
            this->type= type;
            this->line= line;
        }
        int type;
        int line;
        void addCalledParam();
        void genCode(Code &code);
};

struct FunctionS{
    int type;
    list<Parameter> params;
    bool isImport=false;
    void genCode(Code &code);
};

struct Decl{
    int type;
    int size;
    int value;
};


class Array{
    public:
        Array(int line){
            this->line= line;
        }
        int line;
        void newArrayValue();
        void clearArrayValues();
        void genCode(Code &code);;
};