%{
#include <glib.h>
#include <regex.h>
#include "analyzer.h"
bool error_syntaxical=false;
bool error_semantical=false;
extern bool error_lexical;

extern unsigned int lineno;
char *buff;
extern FILE *yyin ;
extern FILE *yyout ;

char* typeTable = NULL;

GHashTable* table_variable;

typedef struct Variable Variable;
 
struct Variable{
       char* type;
       void* value;

};

typedef struct Quadruple Quadruple;

struct Quadruple{
       char* op;
       void* arg1;
       void* arg2;
       char* result;
};

Quadruple **table_quadruple;
int qc = 0 ;


void insertSymbole(char *nom,char *type,void *val);
bool TypeCompatible(Variable* var,char* type);
bool VariableCompatible(char* nom,char* type);
void setValSymbole(char* nom,void* val,char* type);
void* getValSymbole(char *nom);
char* getTypeSymbole(char *nom);

int insertQuadr(char* op,void * arg1 , void * arg2 , char * result);
Quadruple* getQuadr(int id);
void writeQuadr(int id,Quadruple * quad);

void RoutineAffectation(char* arg1 ,char* arg2,char* type);
void RoutineTableau(char* arg1,char* type);

%}


%union {
       long nombre;
       char* texte;
}

%left         TOK_DECAL                       /*DG__DD*/
%left         TOK_MOD        		    /*MOD*/
%left         TOK_PLUS        TOK_MOINS       /* +- */
%left         TOK_MUL         TOK_DIV         /* /* */
%right        TOK_PUISS                       /*^*/
%left         TOK_OU          		    /*ou */
%left         TOK_ET                          /*et*/
%left         TOK_NON                         /*nay*/
%left         TOK_EQ                          /*eq*/
%left         TOK_NQ                          /*nq*/
%left         TOK_LT                          /*lt*/
%left         TOK_GT                          /*gt*/
%left         TOK_LE                          /*le*/
%left         TOK_GE                          /*ge*/
%right        TOK_PARG        TOK_PARD        /* ( ) */
%precedence NEG


%type<texte>            script
%type<texte>            code

%type<texte>            instruction
%type<texte>            affectation
%type<texte>            type
%type<texte>            declaration
%type<texte>            expression
%type<texte>            expressionArithmetique
%type<texte>            expressionBooleenne

%type<texte>            identificateur
%type<texte>            variable
%type<texte>            constant
%type<texte>            constantArithmetique
%type<texte>            constantEntier
%type<texte>            constantReelle
%type<texte>            constantChaine
%type<texte>            constantCaractere

%type<texte>            operationBinaire

%type<texte>            lecture
%type<texte>            ecriture

%type<texte>            constantTableau
%type<texte>            elements
%type<texte>            element

%type<texte>            addition
%type<texte>            soustraction
%type<texte>            inversionSigne
%type<texte>            multiplication
%type<texte>            division
%type<texte>            puissance

%type<texte>            comparaison
%type<texte>            boucleSi
%type<texte>            boucleSiSinon
%type<texte>            boucleSwitch
%type<texte>            cases
%type<texte>            defaultcase
%type<texte>            case

%type<texte>            bouclePour
%type<texte>            boucleTantQue


/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token<texte>        TOK_NOMBRE      /*nombre*/
%token<texte>        TOK_FLOAT       /*reel*/
%token<texte>        TOK_STR         /*chaine*/
%token<texte>        TOK_CHAR         /*caracteres*/
%token<texte>        TOK_VAR         /*variable*/
%token<texte>        TOK_CSTB        /*variable_booleeen*/
%token<texte>        TOK_VARB        /*variable_booleeen*/
%token<texte>        TOK_TYPE        /*type*/
%token               TOK_AFFECT      /*<-*/

%token               TOK_OUVR        /*<*/        
%token               TOK_FERM        /*>*/
%token               TOK_BRACKG      /*[*/        
%token               TOK_BRACKD      /*]*/
%token               TOK_ACCOLG      /*{*/
%token               TOK_ACCOLD      /*}*/
%token               TOK_VIRG        /*,*/        
%token               TOK_DPTS        /*:*/
%token               TOK_PIPE        /*|*/
%token               TOK_FINSTR      /*;*/

%token               TOK_FINI        /*INITIO*/
%token               TOK_FINF        /*FINITO*/

%token               TOK_SI          /*si*/
%token               TOK_ALORS        /*alors*/
%token               TOK_SINON       /*sinon*/
%token               TOK_FINSI

%token               TOK_SWITCH         /*switch*/
%token               TOK_CASE           /*case*/
%token               TOK_DEFAULT        /*defecto*/
%token               TOK_CASEDEF        /*case ... * */
%token               TOK_FINSWITCH      /*finitocambiar*/

%token               TOK_FOR         /*FOR*/
%token               TOK_DANS        /*DANS*/
%token               TOK_FAIRE       /*case__defecto*/
%token               TOK_FINFOR

%token               TOK_TANT     /*case__defecto*/
%token               TOK_FINT


%token               TOK_LEER        /*Lecture*/
%token               TOK_ESCRIR      /*Ecriture*/

%%



script: TOK_FINI code TOK_FINF{
              printf("\n========================================================= Fin du script =========================================================\n"); 
       };


code:  %empty{};
       |
       code instruction{
              printf("\n------------------------------------- Instruction valide en syntaxique ! --------------------------------------\n\n");
       }
       |
       code error{
              fprintf(stderr,"\t\t!!!!!!ERREUR : Erreur de syntaxe .\n");
              error_syntaxical=true;
       };

instruction:  declaration{}
              |
              affectation{}
              |
              lecture{}
              |
              ecriture{}             
              |
              operationBinaire{}  
              |
              boucleSi{}           
              | 
              boucleSiSinon{}
              |
              boucleSwitch{}
              |
              bouclePour{}
              |
              boucleTantQue{}
              ;

type: TOK_TYPE{
              $$=strdup($1);
       };              

declaration:  type identificateur TOK_FINSTR{
                     insertSymbole(strdup($2),strdup($1),NULL);
                     printf("\n\tDecalaration de la variable : ( %s )",$2);
              };
            

affectation:  identificateur TOK_AFFECT expressionArithmetique TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur arithmetique ( %s ) sur la variable ( %s )",$3,$1);
                     RoutineAffectation(strdup($1),strdup($3),NULL);
              }
              |
              identificateur TOK_AFFECT expressionBooleenne TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur booleenne ( %s ) sur la variable ( %s )",$3,$1);
                     RoutineAffectation(strdup($1),strdup($3),"entero");
              }
              |
              identificateur TOK_AFFECT constantChaine TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur chaine de caracteres ( %s ) sur la variable ( %s )",$3,$1);
                     RoutineAffectation(strdup($1),strdup($3),"sarta");
              }           
              |                 
              identificateur TOK_AFFECT constantCaractere TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur du caratere ( %s ) sur la variable ( %s )",$3,$1);
                     RoutineAffectation(strdup($1),strdup($3),"carta");
              }
              |
              identificateur TOK_AFFECT constantTableau TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la structure tableau ( %s ) sur la variable ( %s )",$3,$1);
                     RoutineAffectation(strdup($1),strdup($3),"tablero");
              }
              
              ;

lecture:      TOK_LEER TOK_PARG identificateur TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Lecture : lire dans la variable ( %s )",$3);
              };              

ecriture:     TOK_ESCRIR TOK_PARG variable TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Ecriture :ecrire la valeur de ( %s )",$3);
              };
                                  
operationBinaire: variable TOK_DECAL constantEntier TOK_FINSTR{
                     printf("\n\t\tOperation binaire");
                     $$=strcat(strcat(strdup($1),strdup("DECAL")),strdup($3));
              }
              |
              variable TOK_DECAL identificateur TOK_FINSTR{
                     printf("\n\t\tOperation binaire");
                     if(VariableCompatible($3,"entero")){
                            $$=strcat(strcat(strdup($1),strdup("DECAL")),strdup($3));
                     }
                     else{
                            fprintf(stderr,"\tERREUR : Erreur de semantique , Ligne %d . Type incompatible ( entier attendu - valeur : %s ) !\n",lineno,strdup($3));
                            error_semantical=true;
                     }  
              }
              ;                            

variable:     identificateur{}
              |
              constant{}        
              ;                    
 
identificateur:     TOK_VAR{
                     printf("\t\tVariable : %s",$1);                           
                     $$=strdup($1);
              }
              ;              

constant:     constantArithmetique{       $$=strdup($1);}
              |
              constantChaine{       $$=strdup($1);}
              |
              constantCaractere{    $$=strdup($1);}
              |
              constantTableau{       $$=strdup($1);}
              ;

constantArithmetique:  constantEntier{}
                     |
                     constantReelle{}
                     ;   

constantEntier: TOK_NOMBRE{
                     printf("\t\tConstant arithmetique entier : %s",$1);
                     $$=strdup($1);
              };

constantReelle:TOK_FLOAT{
                     printf("\t\tConstant arithmetique reelle : %s",$1);
                     $$=strdup($1);
              }
              ;                    


constantChaine: TOK_STR{
                     printf("\t\tConstant Chaines : %s",$1);
                     $$=strdup($1);
              }; 

constantCaractere: TOK_CHAR{
                     printf("\t\tConstant Caractere : %s",$1);
                     $$=strdup($1);
              };  

constantTableau: TOK_BRACKG elements TOK_BRACKD{
                     $$=strcat(strcat(strdup("["),strdup($2)),strdup("]"));
                     printf("\t\tConstant tableau de type %s : %s",typeTable,$$);
              }
              |
              TOK_BRACKG TOK_BRACKD{
                     $$=strcat( strdup("[") , strdup("]") );
                     printf("\t\tConstant tableau vide : %s",$$);
              }
              ;                 

elements: elements TOK_VIRG element{ $$=strcat( strcat( strdup($1) , strdup(",") ) , strdup($3) ) ; }
       |
       element{ $$=strdup($1); }
       ;
 
element:identificateur{ RoutineTableau(strdup($1),NULL); }
       |
       constantEntier{ RoutineTableau(strdup($1),"entero"); }
       |
       constantReelle{ RoutineTableau(strdup($1),"float");  }
       |
       constantChaine{ RoutineTableau(strdup($1),"sarta");  }
       |
       constantCaractere{ RoutineTableau(strdup($1),"carta"); }
       |
       constantTableau{ RoutineTableau(strdup($1),"tablero"); }
       ;                                                         

expression:   expressionArithmetique{}             
       	|
              expressionBooleenne{}
              |
              constantChaine{}
              |
              TOK_PARG constantChaine TOK_PARD{
                    $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
              }
              |
              constantTableau{}
              |
              TOK_PARG constantTableau TOK_PARD{
                    $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
              }
              ;

expressionArithmetique: 
       identificateur{
              if(VariableCompatible(strdup($1),"entero")|VariableCompatible(strdup($1),"float")){
                     $$=strdup($1);
              }                     
       }
       |
       constantArithmetique{}
       |
       addition{}
       |
       soustraction{}
       |
       inversionSigne{}
       |
       multiplication{}
       |
       division{}
       |
       puissance{}
       |
       TOK_PARG expressionArithmetique TOK_PARD{
              $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
       }
       ;

addition:     expressionArithmetique TOK_PLUS expressionArithmetique{      
                     $$=strcat(strcat(strdup($1),strdup("+")),strdup($3));
                     printf("\t\tAddition %s",$$);
              };

soustraction: expressionArithmetique TOK_MOINS expressionArithmetique{
                     $$=strcat(strcat(strdup($1),strdup("-")),strdup($3));
                     printf("\t\tSoustraction %s",$$);
              };
              
inversionSigne:      TOK_MOINS expressionArithmetique %prec NEG{
                            $$=strcat(strdup("-"),strdup($2));
                            printf("\t\tInversion du signe %s",$$);
                     }
                     ;

multiplication:      expressionArithmetique TOK_MUL expressionArithmetique{
                            $$= strcat(strcat(strdup($1),strdup("*")),strdup($3));
                            printf("\t\tMultiplication %s",$$);
                     };

division:     expressionArithmetique TOK_DIV expressionArithmetique{
                     $$=strcat(strcat(strdup($1),strdup("/")),strdup($3));
                     printf("\t\tDivision %s",$$);
              };

puissance:    expressionArithmetique TOK_PUISS expressionArithmetique{
                     $$=strcat(strcat(strdup($1),strdup("^")),strdup($3));
                     printf("\t\tPuissance %s",$$);
              };                                  
       
expressionBooleenne: TOK_CSTB{
                            $$=strdup($1);
                            printf("\t\tConstant booleenne : %s",$$);
                     }       
                     |
                     TOK_VARB{
                            char* val = getValSymbole($1);
                            regex_t regex;
                            if( val == NULL ){$$="faux";}
                            else{
                                   regcomp(&regex, "^[0-9]+$", 0) ;
                                   int c = regexec(&regex,val, (size_t) 0, NULL, 0);
                                   if( c ){ 
                                          $$=(atoi(val)?"vrai":"faux") ; }
                                   else{
                                          regcomp(&regex, "^\".*\"$", 0) ;
                                          c = regexec(&regex,val, (size_t) 0, NULL, 0);

                                          if( c ){(strndup(val+1,strlen(val)-2)?"vrai":"faux"); }
                                          else{ $$= "vrai" ; }                            
                                   }
                            }
                            printf("\t\tVariable booleenne : %s == %s",$1,$$);
                     }                          
                     |                                                              
                     TOK_NON expressionBooleenne{
                            $$=strncat(strdup("non "),strdup($2),2*strlen($2));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }                         
                     |
                     expressionBooleenne TOK_ET expressionBooleenne{
                            $$=strncat(strcat(strdup($1),strdup(" et ")),strdup($3),2*strlen($1)+2*strlen($3));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }
                     |
                     expressionBooleenne TOK_OU expressionBooleenne{
                            $$=strncat(strcat(strdup($1),strdup(" ou ")),strdup($3),2*strlen($1)+2*strlen($3));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }                     
                     |
                     TOK_PARG expressionBooleenne TOK_PARD{
                            $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
                            printf("\t\tOperation booleenne entre parenteses : %s \n",$$);
                     }                              
                     |
                     comparaison{
                            $$=strdup($1);
                     }                           
                     ;

boucleSi:     TOK_SI expressionBooleenne TOK_ALORS code TOK_FINSI{
                     printf("\tBLock SI");
              };


boucleSiSinon: TOK_SI expressionBooleenne TOK_ALORS code TOK_SINON code TOK_FINSI{
                     printf("\tBLock SI_SINON");
              }
              ;

boucleSwitch: TOK_SWITCH expression cases defaultcase TOK_FINSWITCH{
                     printf("\tBLock SWITCH sur expression %s\n",$2);
              }
              ;

cases:        case {}
              |
              case cases {}
              ;

case:         TOK_CASE constant TOK_CASEDEF code{
                     printf("\tcas d evaluation == %s\n",$2);
              }
              ;              

defaultcase:  TOK_DEFAULT TOK_CASEDEF code{
                     printf("\tcas d evaluation par defaut\n");
              };             

bouclePour:   TOK_FOR identificateur TOK_DANS variable TOK_FAIRE code TOK_FINFOR{
                     printf("\tBLock POUR");
              }
              |
              TOK_FOR identificateur TOK_DANS TOK_OUVR variable TOK_DPTS variable TOK_FERM  TOK_FAIRE code TOK_FINFOR{
                     printf("\tBLock POUR");
              }
              ;

boucleTantQue:  TOK_TANT expressionBooleenne TOK_FAIRE code TOK_FINT{
                     printf("\tBLock TANTQUE");
              };               
                                 
comparaison:  expressionBooleenne TOK_EQ expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" == ")),strdup($3));
                     printf("\n\t\tComparaison : %s == %s",$1,$3);
              }
              |
              expressionBooleenne TOK_NQ expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" != ")),strdup($3));
                     printf("\n\t\tComparaison : %s != %s",$1,$3);
              }
              |
              expressionBooleenne TOK_LT expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" < ")),strdup($3));
                     printf("\n\t\tComparaison : %s < %s",$1,$3);
              }
              |
              expressionBooleenne TOK_GT expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" > ")),strdup($3));
                     printf("\n\t\tComparaison : %s > %s",$1,$3);
              }
              |
              expressionBooleenne TOK_LE expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" <= ")),strdup($3));
                     printf("\n\t\tComparaison : %s <= %s",$1,$3);
              }
              |
              expressionBooleenne TOK_GE expressionBooleenne{
                     $$=strcat(strcat(strdup($1),strdup(" >= ")),strdup($3));
                     printf("\n\t\tComparaison : %s >= %s",$1,$3);
              }
              ;             

%%

/********************************************/



void insertSymbole(char *nom,char *type,void *val){
       Variable* var=malloc(sizeof(Variable));
       if(var!=NULL){
              var->type=type;
              var->value=val;
              if(!g_hash_table_insert(table_variable,nom,var)){
                     fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE , LIGNE %d \n",lineno);
                     /* exit(-1);*/
              }
       }else{
              fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE , LIGNE %d \n",lineno);
              /* exit(-1);*/
       }
}

bool TypeCompatible(Variable* var,char* type){
       if( !strcmp(var->type,"float") && !strcmp(type,"entero") ){return true ;}
       else{return (strcmp(var->type,type)==0) ;}
}

bool VariableCompatible(char* nom,char* type){
       Variable* var=g_hash_table_lookup(table_variable,nom); 
       if(var!=NULL){ 
              return (TypeCompatible(var,type)) ;
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique , Ligne %d . Variable %s jamais declaree !\n",lineno,nom);
              error_semantical=true;
       }
}

void setValSymbole(char* nom,void* val,char* type){
       /* recuperer la valeur et le type de lídentificateur*/
       Variable* var=g_hash_table_lookup(table_variable,nom); 
       if(var!=NULL){ 
              if( TypeCompatible(var,type) ){                     
                     var->value = val ;
                     g_hash_table_replace(table_variable,nom,var) ;  
              }      
              else{
                     fprintf(stderr,"\tERREUR : Erreur de semantique , Ligne %d . Type incompatible ( %s attendu - valeur : %s ) !\n",lineno,var->type,(char*)var->value);
                     error_semantical=true;
              }  
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique , Ligne %d . Variable %s jamais declaree !\n",lineno,nom);
              error_semantical=true;
       }
}

/*
void setTypeSymbole(char *nom,char *t){
       Variable* var=g_hash_table_lookup(table_variable,nom); 
       if(var!=NULL){ 
              return var ;                   
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne __. Variable %s jamais declaree !\n",nom);
              error_semantical=true;
       }
} 
*/

void* getValSymbole(char *nom){
        Variable* var=g_hash_table_lookup(table_variable,nom); 
       if(var!=NULL){ 
              return var->value ;                   
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne __. Variable %s jamais declaree !\n",nom);
              error_semantical=true;
              return NULL ;
       }
}

char* getTypeSymbole(char *nom){
       Variable* var=g_hash_table_lookup(table_variable,nom); 
       if(var!=NULL){ 
              return var->type ;                   
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne __. Variable %s jamais declaree !\n",nom);
              error_semantical=true;
              return NULL ;
       }
}

int insertQuadr(char* op,void * arg1 , void * arg2 , char* result){
       Quadruple* quad=malloc(sizeof(Quadruple));
       if(quad!=NULL){
              quad->op=op;
              quad->arg1=arg1;
              quad->arg2=arg2;
              quad->result=result;
              table_quadruple[qc] = quad ;
              writeQuadr(qc,quad);
              return qc++;
       }else{
              fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
              /* exit(-1);*/
       }
}

void writeQuadr(int id,Quadruple * quad){
       if (yyout != NULL){
              fprintf(yyout,"@%d ( %s , %s , %s , %s )\n",id,quad->op,(char*)quad->arg1,(char*)quad->arg2,quad->result);
       }
}

Quadruple* getQuadr(int id){
      return (table_quadruple[id]); 
}


/*************/

void RoutineAffectation(char* arg1 ,char* arg2,char* type){
       setValSymbole( strdup(arg1) , strdup(arg2) , (type==NULL?getTypeSymbole(arg1):type) ); 
       insertQuadr(strdup("<-"),arg2,strdup("_"),arg1);
}

void RoutineTableau(char* arg1,char* type){
       if(typeTable ==NULL){
              typeTable = (type==NULL?getTypeSymbole(arg1):type);
       }else{
              int c = (type==NULL?!VariableCompatible(arg1,typeTable):strcmp("entero",typeTable)) ;
              if(c){
                     fprintf(stderr,"\tERREUR : Erreur de semantique , Ligne %d . Type incompatible ( %s attendu - valeur : %s ) !\n",lineno,typeTable,arg1);
                     error_semantical=true;             
              }
       }
}

int main(int argc, char *argv[]){
 	yyin = fopen(argv[1],"r");      
       yyout = fopen("code_genere.txt","w");  
       table_quadruple = malloc(100*sizeof(Quadruple*)); 

       /* Creation de la table de hachage */
       table_variable=g_hash_table_new(g_str_hash,
                                          g_str_equal
                                          );    

       printf("Debut de analyse syntaxique :\n\n");

       yyparse();

       printf("\n\nFin de lanalyse !\n\n");
       printf("Resultat :\n");
       if(error_lexical){
              printf("\t-- Echec a lanalyse lexicale --\n");
       }
       else{
              printf("\t-- Succès a lanalyse lexicale ! --\n");
       }
       if(error_syntaxical){
              printf("\t-- Echec a lanalyse syntaxique --\n");
       }
       else{
              printf("\t-- Succès a lanalyse syntaxique ! --\n");
       }
       if(error_semantical){
              printf("\t-- Echec a lanalyse sémantique !--\n\n");
       }
       else{
              printf("\t-- Succès a lanalyse sémantique ! --\n\n");
       }

       /* Liberation memoire : suppression de la table */
       g_hash_table_destroy(table_variable);
       
       fclose(yyout);
       return EXIT_SUCCESS;
}

void yyerror(char *s) {
       fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}