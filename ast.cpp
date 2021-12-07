#include "ast.h"
#include <iostream>


map<string,Decl> variables;
map<string, FunctionS> functions;
list<Ids> ids;
list<Parameter> aux_params;
list<int> id_types;
list<int> called_params;
list<int> op_types;
list<int> sign_types;
int cont_params = 0;
void clearIdList();
int countParams();

type getTypeByIndexPosition(int i){
     return static_cast<type>(i); 
};
///////////////////////////////////////////////////////////////////////////////////
void Program::printLists(){
    auto iter = variables.begin();
    cout<<"Variables:\n";
    while (iter != variables.end()) {
        cout<<"["<<iter->first<<"]\n";
        ++iter;
    }
    auto its = functions.begin();
    cout<<"Funciones:\n";
    while (its != functions.end()) {
        cout<<"["<<its->first<<"]\n";
        ++its;
    }
}
///////////////////////////////////////////////////////////////////////////////////
int Declaration::addDeclaration(){
   list<Ids>::iterator it= ids.begin();
   list<int>::iterator its= id_types.begin();
//    cout<<ids.size()<<","<<id_types.size()<<endl;
   if (ids.size() != id_types.size())
   {
       cout<<"Error: La cantidad de variables y asignaciones no coinciden,  Linea: "<<this->line<<endl;
       clearIdList();
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
            Decl s;
            s.type = cont;
            s.size = this->size;
            variables[id.name] = s;
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
                 Decl s;
                 s.type = this->type;
                 s.size = this->size;  
                 variables[id.name] = s;
                 cout<<"Variable '"<< id.name<< "' Linea: "<<this->line<<endl;
             }
             it++;
        }
   }
   clearIdList();
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

void Declaration::validArraySize(int type, int size){
    if (type != 3 || size <= 0)
    {
       cout<<"Error: Tamaño de arreglo no valido, "<<  "Linea: "<<line<<endl;
    }
    
}
///////////////////////////////////////////////////////////////////////////////////
void Ids::addToList(){
    ids.push_back(this->name);
};

int Ids::getType(){
    auto search = variables.find(this->name);
    if(search == variables.end()){
        cout<<"Error: Variable '" << this->name <<"' no existe\n";
        return 0;
    }
    return search->second.type;
};

int Ids::getSize(){
    auto search = variables.find(this->name);
    if(search == variables.end()){
        cout<<"Error: Variable '" << this->name <<"' no existe\n";
        return 0;
    }
    return search->second.size;
};

void Ids::addTypeToList(int type){
    id_types.push_back(type);
};
///////////////////////////////////////////////////////////////////////////////////
void BinaryOp::evaluate(){

    if( this->left != this->right ){
        cout<<"Error: operación invalida. Tipos incompatibles. Linea: " << this->line<<endl; 
    }

};
///////////////////////////////////////////////////////////////////////////////////
void Arith::addOp(int type){
    op_types.push_back(type);
};

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
        //cout<<"valor: '"<< cont <<endl;
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
        //cout<<"valor: '"<< s <<endl;
        
        if (s != 1)
        {
            validConcat++;
        }
        sign_it++;
    }
   
    //cout<<"string: '"<< string_type <<endl;
    //cout<<"valid: '"<< validConcat <<endl;
    if (bool_type > 0 && sign_types.size() > 0)
    {
        cout<<"Error: No se pueden operar valores booleanos. Linea: " << this->line<<endl; 
    }else if(string_type > 0 && int_type > 0 || string_type > 0 && float_type > 0){
        cout<<"Error: No se pueden operar string con valores numericos. Linea: " << this->line<<endl;
    }else if(string_type > 0 && validConcat > 0){
        cout<<"Error: Operador no definido para strings. Linea: " << this->line<<endl;
    }
    clearList();
};

void Arith::clearList(){
    op_types.clear();
    sign_types.clear();
};

void Arith::addSign(int sign){
    sign_types.push_back(sign);
};
//////////////////////////////////////////////////////////////////////////////////
void Function::addFunction(){
    FunctionS tmp;
    if(this->name[0] =='\"'){
        this->name = this->name.replace(0,1,"");
        int pos = this->name.length()-1;
        this->name = this->name.replace(pos,1,""); 
        tmp.isImport = true;
    }
    auto search = functions.find(this->name);
    if(search != functions.end()){
        cout<<"Error: Funcion '"<<this->name<< "' existente, Linea: "<<this->line<<endl;
        cont_params =0;
        return;

    }
    tmp.params = aux_params;
    tmp.type = this->type;

    functions[this->name] = tmp;
    cout<<"Funcion '"<< this->name<< "' Linea: "<<this->line<<endl;
    cont_params=0;
    aux_params.clear();
    clearIdList();   
};

int Function::evaluateCall(string name){
    auto search = functions.find(name);
    if(search == functions.end()){
        cout<<"Error: Funcion '"<< name << "' no existe Linea: "<<this->line<<endl;
        called_params.clear();
        return 0;
    }
    int cont = countParams();
    FunctionS tmp = search->second;
    if(!tmp.isImport){
        // cout<<"parametros func:"<<tmp.params<<endl;
        // cout<<"parametros call:"<<cont<<endl;
        if(cont!= tmp.params.size()){
            cout<<"Error: Funcion '"<<name<< "', cantidad de parametros erronea, Linea: "<<this->line<<endl;
            called_params.clear();
            return 0;
        }

        called_params.reverse();
        list<Parameter> lista =  tmp.params;
        list<Parameter>::iterator itd = lista.begin();

        list<int>:: iterator its = called_params.begin();

        while(itd!= lista.end() && its != called_params.end()){
            Parameter aux = *itd;
            int type_p = * its;
            cout<<"tipo func: "<<aux.type<<endl;
            cout<<"tipo res: "<<type_p<<endl;
        
            if(type_p != aux.type){
                cout<<"Tipo de parametro incorrecto, Linea: "<<this->line<<endl;
            }
            itd++;
            its++;
        }
    }
    called_params.clear();
    return tmp.type;
};
//////////////////////////////////////////////////////////////////////////////////
void Parameter::addParameter(){
    auto search = variables.find(this->name);
    if(search != variables.end()){
        cout<<"Error: Variable '"<< this->name<< "' existente"<<endl;
    }
    
    cout<<"tipo: "<<this->type<<endl;
    Decl s;
    s.type = this->type;
    s.size = 0;
    variables[this->name] = s;
    Parameter newpar = Parameter(this->name ,this->type);
    aux_params.push_back(newpar);
    cout<<"Variable '"<< this->name<<endl;
    cont_params++;
};
///////////////////////////////////////////////////////////////////////////////////
void CalledParam::addCalledParam(){
    called_params.push_back(this->type);
};

///////////////////////////////////////////////////////////////////////////////////
int countParams(){
    list<int>:: iterator it = called_params.begin();
    int cont_aux=0;
    while(it!= called_params.end()){
        cont_aux++;
        it++;
    }
    return cont_aux;
}
void clearIdList(){
    ids.clear();
    id_types.clear();
}
