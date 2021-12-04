#include <string>
#include <list>
#include <map>

using namespace std;

enum type{
    STRING,
    INT,
    FLOAT,
    BOOL
};


class Declaration{
    public:
        Declaration(int type , int line){
            this->type = type;
            this->line = line;
        }
        int type;
        int line;

        bool evaluate(string key , int line);
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