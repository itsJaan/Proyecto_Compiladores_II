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
        BinaryOp(int left, int right, int line, string op){
            this->left = left;
            this->right = right;
            this->line = line;
            this->op = op;
        }
        int left;
        int right;
        int line;
        string op;
        void evaluate();
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
};

