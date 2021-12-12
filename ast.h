#include <string>
#include <list>
#include <map>

using namespace std;

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
        void enteringFor();
        void exitingFor();
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
};

struct FunctionS{
    int type;
    list<Parameter> params;
    bool isImport=false;
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
};