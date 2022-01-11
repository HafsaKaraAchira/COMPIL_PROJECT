%{
#include "analyzer.h"
bool error_syntaxical=false;
extern unsigned int lineno;
extern bool error_lexical;
char *buff;
extern FILE *yyin ;
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
%left         TOK_COMP                        /*eq__nq__lt__gt__le__ge*/
%precedence NEG
%right        TOK_PARG        TOK_PARD        /* ( ) */




/*
%type<texte>            script
*/
%type<texte>            code

%type<texte>            instruction
%type<texte>            affectation
%type<texte>            declaration
%type<texte>            lecture
%type<texte>            ecriture
%type<texte>            expression

%type<texte>            identificateur
%type<texte>            variable
%type<texte>            constant
%type<texte>            constantArithmetique
%type<texte>            constantChaine
%type<texte>            constantTableau
%type<texte>            elements
%type<texte>            element

%type<texte>            expressionArithmetique
%type<texte>            addition
%type<texte>            soustraction
%type<texte>            inversionSigne
%type<texte>            multiplication
%type<texte>            division
%type<texte>            puissance

/**/
%type<texte>            expressionBooleenne
%type<texte>            comparaison

%type<texte>            operationBinaire

%type<texte>            boucleSi
%type<texte>            boucleSiSinon

%type<texte>            bouclePour
%type<texte>            boucleTantQue
/**/


/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token               TOK_TYPE        /*type*/
%token<texte>        TOK_NOMBRE      /*nombre*/
%token<texte>        TOK_STR         /*variable*/
%token<texte>        TOK_VAR         /*variable*/
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
%token               TOK_FINB        /*FINITOPOR__finittosi__finitocambiar*/

%token               TOK_SI          /*si*/
%token               TOK_ALORS        /*alors*/
%token               TOK_SINON       /*sinon*/
%token               TOK_FINSI
%token               TOK_CAMBIAR     /*switch*/
%token               TOK_CASE        /*case__defecto*/

%token               TOK_FOR         /*FOR*/
%token               TOK_DANS        /*DANS*/
%token               TOK_FAIRE       /*case__defecto*/
%token               TOK_FINFOR

%token               TOK_TANT     /*case__defecto*/
%token               TOK_FINT


%token               TOK_LEER        /*Lecture*/
%token               TOK_ESCRIR      /*Ecriture*/


%%

/*
script:
       %empty{}
       |
       TOK_FINI TOK_FINF{
              printf("Script vide , Rien a faire \n\n"); 
       }
       |
       TOK_FINI code TOK_FINF{
              printf("Fin du script\n\n"); 
       };
*/


code:  %empty{}
       |
       code instruction{
              printf("\n------------------------------------- Instruction valide ! --------------------------------------\n\n");
       }
       |
       code error{
              fprintf(stderr,"\t\t!!!!!!ERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
              error_syntaxical=true;
       };

instruction:  
              declaration{
              }
              |
              affectation{
              }
              |
              lecture{
              }
              |
              ecriture{
              }
              |
              operationBinaire{
              }
              |
              bouclePour{
              }
              |
              boucleSi{
              }
              |
              boucleSiSinon{
              }
              |
              boucleTantQue{
              }             
              ;

declaration:  TOK_TYPE identificateur TOK_FINSTR{
                     printf("\n\tDecalaration de la variable : ( %s )",$2);
              };

affectation:  identificateur TOK_AFFECT expression TOK_FINSTR{
                     printf("\n\tInstruction type Affectation : Affectation de la valeur ( %s ) sur la variable ( %s )",$3,$1);
              };

lecture:      TOK_LEER TOK_PARG identificateur TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Lecture : lire dans la variable ( %s )",$3);
              };              

ecriture:     TOK_ESCRIR TOK_PARG variable TOK_PARD TOK_FINSTR{
                     printf("\n\tInstruction type Ecriture :ecrire la valeur de ( %s )",$3);
              };              

expression:   expressionArithmetique{
       	}
       	|
              expressionBooleenne{
              };

variable:     identificateur{
              }
              |
              constant{
              }              
 
identificateur:     TOK_VAR{
                     printf("\t\tVariable : %s",$1);
                     $$=strdup($1);
              }              

constant:     constantArithmetique{
                     $$=strdup($1);
              }
              |
              constantChaine{
                     $$=strdup($1);
              }
              |
              constantTableau{
                     $$=strdup($1);
              }
              ;       

constantArithmetique:  
                     TOK_NOMBRE{
                            printf("\t\tConstant arithmetique : %s",$1);
                            $$=strdup($1);
                     };

constantChaine:   
              TOK_STR{
                     printf("\t\tConstant Chaines : %s",$1);
                     $$=strdup($1);
              };  

constantTableau:   
              TOK_BRACKG elements TOK_BRACKD{
                     $$=strcat(strcat(strdup("["),strdup($2)),strdup("]"));
                     printf("\t\tConstant tableau : %s",$$);
              };                 

elements:
       elements TOK_VIRG element{
              $$=strcat( strcat( strdup($1) , strdup(",") ) , strdup($3) ) ;
       }
       |
       element{
              $$=strdup($1);
       };
 
element:
       variable{
       };

expressionArithmetique: 
       identificateur{
       }
       |
       constantArithmetique{
       }
       |
       addition{
       }
       |
       soustraction{
       }
       |
       inversionSigne{
       }
       |
       multiplication{
       }
       |
       division{
       }
       |
       puissance{
       };

addition:     expressionArithmetique TOK_PLUS expressionArithmetique{      
                     $$=strcat(strcat(strdup($1),strdup("+")),strdup($3));
                     printf("\t\tAddition %s",$$);
              };

soustraction: expressionArithmetique TOK_MOINS expressionArithmetique{
                     $$=strcat(strcat(strdup($1),strdup("-")),strdup($3));
                     printf("\t\tSoustraction %s",$$);
              };
              
inversionSigne:      TOK_MOINS expressionArithmetique %prec NEG {              
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

/**/

expressionBooleenne:       
                     variable{
                            $$=strdup($1);
                     }
                     |
                     comparaison{
                            $$=strdup($1);
                     }
                     |
                     TOK_NON expressionBooleenne{
                            $$=strcat( strdup("non "), strndup($2,sizeof(char)*strlen($2)) );
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }
                     |
                     expressionBooleenne TOK_ET expressionBooleenne{
                            $$=strcat(strcat(strdup($1),strdup(" et ")),strdup($3));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }
                     |
                     expressionBooleenne TOK_OU expressionBooleenne{
                            $$=strcat(strcat(strdup($1),strdup(" ou ")),strdup($3));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }
                     |
                     TOK_PARG expressionBooleenne TOK_PARD{
                            $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
                            printf("\t\tOperation booleenne : %s \n",$$);
                     }
                     ;

comparaison:  expression TOK_COMP expression{
                     $$=strcat(strcat(strdup($1),strdup(" COMP ")),strdup($3));
                     printf("\n\t\tComparaison : %s comp %s",$1,$3);
              }
              ;                     

operationBinaire:
              variable TOK_DECAL expressionArithmetique TOK_FINSTR{
                     printf("\t\tOperation binaire\n");
                     $$=strcat(strcat(strdup($1),strdup("DECAL")),strdup($3));
              }              

boucleSi:     TOK_SI expressionBooleenne TOK_ALORS code TOK_FINSI{
                     printf("\tBLock SI");
              };

boucleSiSinon: TOK_SI expressionBooleenne TOK_ALORS code TOK_SINON code TOK_FINSI{
                     printf("\tBLock SI_SINON");
              };
              

bouclePour:   TOK_FOR identificateur TOK_DANS variable TOK_FAIRE code TOK_FINFOR{
                     printf("\tBLock POUR");
              };

boucleTantQue:  TOK_TANT expressionBooleenne TOK_FAIRE code TOK_FINT{
                        printf("\tBLock TANTQUE");
              };                     

/**/

%%

/********************************************/


int main(int argc, char *argv[]){
 	yyin = fopen(argv[1],"r");

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

       return EXIT_SUCCESS;
}

void yyerror(char *s) {
       fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}