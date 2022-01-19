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

GHashTable* table_variable;

typedef struct Variable Variable;
 
struct Variable{
       char* type;
       void* value;
};

typedef struct Quadruple Quadruple;

struct Quadruple{
       void* arg1;
       void* arg2;
       char* result;
};

Quadruple * table_quadruple;


void insertSymbole(char *nom,char *type,void *val);
bool TypeCompatible(Variable* var,char* type);
bool VariableCompatible(char* nom,char* type);
void setValSymbole(char* nom,void* val,char* type);
void* getValSymbole(char *nom);
char* getTypeSymbole(char *nom);

void insertQuadr(int id,void * arg1 , void * arg2 , char * result);
void getQuadr(int id);

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
%type<texte>            constantChaine

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
%token<texte>        TOK_STR         /*variable*/
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
              printf("\n==================================================================================== Fin du script ====================================================================================\n"); 
       };


code:  %empty{};
       |
       code instruction{
              printf("\n------------------------------------- Instruction valide ! --------------------------------------\n\n");
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
                     setValSymbole(strdup($1),strdup($3),"entero"); 
              }
              |
              identificateur TOK_AFFECT expressionBooleenne TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur booleenne ( %s ) sur la variable ( %s )",$3,$1);
                     setValSymbole(strdup($1),strdup($3),"entero");
              }
              |
              identificateur TOK_AFFECT constantChaine TOK_FINSTR{
                     if(VariableCompatible($1,"sarta")){
                            printf("\n\tInstruction type Affectation : Affectation de la valeur chaine de caracteres ( %s ) sur la variable ( %s )",$3,$1);
                            setValSymbole(strdup($1),strdup($3),"sarta");
                     }else{
                            if(VariableCompatible($1,"sarta") && strlen($3)==3){
                                   printf("\n\tInstruction type Affectation : Affectation de la valeur du caratere ( %s ) sur la variable ( %s )",$3,$1);
                                   setValSymbole(strdup($1),strdup($3),"carta");
                            }                                       
                     }
              }
              ;

lecture:      TOK_LEER TOK_PARG identificateur TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Lecture : lire dans la variable ( %s )",$3);
              };              

ecriture:     TOK_ESCRIR TOK_PARG variable TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Ecriture :ecrire la valeur de ( %s )",$3);
              };
                                  
operationBinaire: variable TOK_DECAL expressionArithmetique TOK_FINSTR{
                     printf("\n\t\tOperation binaire");
                     $$=strcat(strcat(strdup($1),strdup("DECAL")),strdup($3));
              };                            

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
              constantTableau{       $$=strdup($1);}
              ;

constantArithmetique:  TOK_NOMBRE{
                            printf("\t\tConstant arithmetique : %s",$1);
                            $$=strdup($1);
                     };   

constantChaine: TOK_STR{
                     printf("\t\tConstant Chaines : %s",$1);
                     $$=strdup($1);
              };  

constantTableau: TOK_BRACKG elements TOK_BRACKD{
                     $$=strcat(strcat(strdup("["),strdup($2)),strdup("]"));
                     printf("\t\tConstant tableau : %s",$$);
              };                 

elements: elements TOK_VIRG element{       $$=strcat( strcat( strdup($1) , strdup(",") ) , strdup($3) ) ;}
       |
       element{       $$=strdup($1);}
       ;
 
element:variable{};                                                         

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
              if(VariableCompatible(strdup($1),"entero")){
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
                     fprintf(stderr,"ERREUR - PROBLEME CREATION VARIABLE !\n");
                     exit(-1);
              }
       }else{
              fprintf(stderr,"ERREUR - PROBLEME ALLOCATION MEMOIRE VARIABLE !\n");
              exit(-1);
       }
}

bool TypeCompatible(Variable* var,char* type){
       return (strcmp(var->type,type)==0) ;
}

bool VariableCompatible(char* nom,char* type){
       Variable* var=g_hash_table_lookup(table_variable,nom); 
       return (TypeCompatible(var,type)) ;
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
                     fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne __. Type incompatible ( %s attendu - valeur : %s ) !\n",var->type,(char*)var->value);
                     error_semantical=true;
              }  
       }else{
              fprintf(stderr,"\tERREUR : Erreur de semantique a la ligne __. Variable %s jamais declaree !\n",nom);
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

void insertQuadr(int id,void * arg1 , void * arg2 , char * result){
       
}

void getQuadr(int id){

}

int main(int argc, char *argv[]){
 	yyin = fopen(argv[1],"r");   

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
              printf("\t-- Succes a lanalyse lexicale ! --\n");
       }
       if(error_syntaxical){
              printf("\t-- Echec a lanalyse syntaxique --\n");
       }
       else{
              printf("\t-- Succes a lanalyse syntaxique ! --\n");
       }

       /* Liberation memoire : suppression de la table */
       /* g_hash_table_destroy(table_variable);*/
       return EXIT_SUCCESS;
}

void yyerror(char *s) {
       fprintf(stderr, "Erreur de syntaxe a la ligne __ : %s\n", s);
}