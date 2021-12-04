#include "ast.h"
#include <iostream>


map<string,int> variables;
list<Ids> ids;
list<int> id_types;
list<int> op_types;
list<int> sign_types;

type getTypeByIndexPosition(int i){
     return static_cast<type>(i); 
};

int Declaration::addDeclaration(){
   list<Ids>::iterator it= ids.begin();
   list<int>::iterator its= id_types.begin();
   if (ids.size() != id_types.size())
   {
       cout<<"Error: La cantidad de variables y asignaciones no coinciden,  Linea: "<<this->line<<endl;
       return 0;
   }

   if (this->type == 0)
   {
       while(it!= ids.end()){
        Ids id = *it; 
        int cont = * its;
        auto search = variables.find(id.name);
        if(search != variables.end()){
            cout<<"Error: Variable '"<< id.name<< "' existente, Linea: "<<this->line<<endl;
        }else{
            variables[id.name] = cont;
            cout<<"Variable '"<< id.name<< "' Linea: "<<this->line<<endl;
        }
        it++;
        cont++;
        }    
   }else{

        while(it!= ids.end()){
             Ids id = *it; 
             auto search = variables.find(id.name);
             if(search != variables.end()){
                 cout<<"Error: Variable '"<< id.name<< "' existente, Linea: "<<this->line<<endl;
             }else{
                 variables[id.name] = this->type;
                 cout<<"Variable '"<< id.name<< "' Linea: "<<this->line<<endl;
             }
             it++;
        }
   }
    ids.clear();
    id_types.clear();
    return 0;
};

bool Declaration::evaluate(string key , int line){
    auto search = variables.find(key);
    if(search == variables.end()){
        cout<<"Error: Variable '"<< key << "' no existe Linea: "<<line<<endl;
        return false;
    }
    return true;
};

void Ids::addToList(){
    ids.push_back(this->name);
};


int Ids::getType(){
    auto search = variables.find(this->name);
    if(search == variables.end()){
        cout<<"Error: Variable '" << this->name <<"' no existe\n";
        return 0;
    }
    return search->second;
};

void Ids::addTypeToList(int type){
    id_types.push_back(type);
}


void BinaryOp::evaluate(){

    if( this->left != this->right ){
        cout<<"Error: operación invalida. Tipos incompatibles. Linea: " << this->line<<endl; 
    }

};


void Arith::addOp(int type){
    op_types.push_back(type);
}

void Arith::evaluate(){
    list<int>::iterator its= op_types.begin();
    list<int>::iterator sign_it= sign_types.begin();
    int string_type = 0;
    int int_type = 0;
    int bool_type = 0;
    int float_type = 0;
    int validConcat = 0;
    
    while(its!= op_types.end()){
        int cont = * its; 
        // cout<<"valor: '"<< cont <<endl;
        if (cont == 1)
        {
            string_type++;
        }else if(cont == 2){
            bool_type++;
        }else if(cont == 3){
            int_type++;
        }else if(cont == 4){
            float_type++;
        }
        
        its++;

    }

    while(sign_it != sign_types.end()){
        int s = * sign_it; 
        // cout<<"valor: '"<< s <<endl;
        
        if (s != 1)
        {
            validConcat++;
        }
        sign_it++;
    }
   
//    cout<<"string: '"<< string_type <<endl;
//    cout<<"valid: '"<< validConcat <<endl;
    if (bool_type > 0)
    {
        cout<<"Error: No se pueden operar valores booleanos. Linea: " << this->line<<endl; 
    }else if(string_type > 0 && int_type > 0 || string_type > 0 && float_type > 0){
        cout<<"Error: No se pueden operar string con valores numericos. Linea: " << this->line<<endl;
    }else if(string_type > 0 && validConcat > 0){
        cout<<"Error: Operador no definido para strings. Linea: " << this->line<<endl;
    }
    clearList();
}

void Arith::clearList(){
    op_types.clear();
    sign_types.clear();
}

void Arith::addSign(int sign){
    sign_types.push_back(sign);
}