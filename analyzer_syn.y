%{
#include "analyzer.h"
bool error_syntaxical=false;
extern unsigned int lineno;
extern bool error_lexical;
char *buff;
char b[256];
extern FILE *yyin ;
%}

%union {
       long nombre;
       char* texte;
}


%left         TOK_COMP                        /*eq__nq__lt__gt__le__ge*/
%left         TOK_DECAL                       /*DG__DD*/
%left         TOK_MOD        		    /*MOD*/
%left         TOK_PLUS        TOK_MOINS       /* +- */
%left         TOK_MUL         TOK_DIV         /* /* */
%left         TOK_PUISS                       /*^*/
%left         TOK_OU          		    /*ou */
%left         TOK_ET                          /*et*/
%left         TOK_NON                         /*nay*/
%right        TOK_PARG        TOK_PARD        /* () */



/**/
%type<texte>            script
/**/
%type<texte>            code

%type<texte>            instruction
%type<texte>            affectation
%type<texte>            declaration
%type<texte>            expression

%type<texte>            identificateur
%type<texte>            variable
%type<texte>            constant
%type<texte>            constantArithmetique
%type<texte>            constantChaine

%type<texte>            expressionArithmetique
%type<texte>            addition
%type<texte>            soustraction
%type<texte>            multiplication
%type<texte>            division
%type<texte>            puissance

/**/
%type<texte>            expressionBooleenne

%type<texte>            boucle_si
%type<texte>            boucle_si_sinon
%type<texte>            boucle_for
%type<texte>            boucle_tant_que
/**/


/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */

%token               TOK_TYPE        /*type*/
%token<texte>        TOK_NOMBRE      /*nombre*/
%token<texte>        TOK_STR         /*variable*/
%token<texte>        TOK_VAR         /*variable*/
%token               TOK_AFFECT      /*<-*/
%token               TOK_FINSTR      /*;*/
%token               TOK_OUVR        /*< { [*/        
%token               TOK_FERM        /*> } ]*/
%token               TOK_PONC        /*, | :*/

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


code:  %empty{}
       |
       code instruction{
              printf("----------------------------------- Instruction valide ! ----------------------------------\n\n");
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
              boucle_for{
              }
              |
              boucle_si{
              }
              boucle_si_sinon{
              }
              |
              boucle_tant_que{
              }             
              ;

declaration:  TOK_TYPE identificateur TOK_FINSTR{
                     printf("\t\tDecalaration de la variable : %s\n",$2);
              };

affectation:  identificateur TOK_AFFECT expression TOK_FINSTR{
                     printf("\t\tInstruction type Affectation : Affectation sur la variable %s\n",$1);
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
                     printf("\t\t\tVariable : %s\n",$1);
                     $$=strdup($1);
              }              

constant:     constantArithmetique{
                     $$=strdup($1);
              }
              |
              constantChaine{
                     $$=strdup($1);
              }
              ;       

constantArithmetique:  
                     TOK_NOMBRE{
                            printf("\t\t\tConstant arithmetique : %s\n",$1);
                            $$=strdup($1);
                     };

constantChaine:   
              TOK_STR{
                     printf("\t\t\tConstant Chaines : %s\n",$1);
                     $$=strdup($1);
              };                     

 

expressionArithmetique: 
       constantArithmetique{
       }
       |
       addition{
       }
       |
       soustraction{
       }
       |
       multiplication{
       }
       |
       division{
       }
       |
       puissance{
       }

addition:     expressionArithmetique TOK_PLUS expressionArithmetique{      
                     printf("\t\t\tAddition %s\n",buff);
                     $$=strcat(strcat(strdup($1),strdup("+")),strdup($3));
              };

soustraction: expressionArithmetique TOK_MOINS expressionArithmetique{
                     printf("\t\t\tSoustraction %s\n",buff);
                     $$=strcat(strcat(strdup($1),strdup("-")),strdup($3));
              };

multiplication:      expressionArithmetique TOK_MUL expressionArithmetique{
                            buff = strcat(strcat(strdup($1),strdup("*")),strdup($3));
                            printf("\t\t\tMultiplication %s\n",buff);
                            $$= strdup(buff);
                     };

division:     expressionArithmetique TOK_DIV expressionArithmetique{
                     printf("\t\t\tDivision %s\n",buff);
                     $$=strcat(strcat(strdup($1),strdup("/")),strdup($3));
              };

puissance:    expressionArithmetique TOK_PUISS expressionArithmetique{
                     printf("\t\t\tPuissance %s\n",buff);
                     $$=strcat(strcat(strdup($1),strdup("^")),strdup($3));
              };

/**/

expressionBooleenne:       
                     variable{
                            $$=strdup($1);
                     }
                     |
                     TOK_NON expressionBooleenne{
                            printf("\t\t\tOperation booleenne NON\n");
                            $$=strcat(strdup("non "), strndup($2,sizeof(char)*strlen($2)));
                     }
                     |
                     expressionBooleenne TOK_ET expressionBooleenne{
                            printf("\t\t\tOperation booleenne ET\n");
                            $$=strcat(strcat(strdup($1),strdup(" et ")),strdup($3));
                     }
                     |
                     expressionBooleenne TOK_OU expressionBooleenne{
                            printf("\t\t\tOperation booleenne OU\n");
                            $$=strcat(strcat(strdup($1),strdup(" ou ")),strdup($3));
                     }
                     |
                     TOK_PARG expressionBooleenne TOK_PARD{
                            printf("\t\t\texpression booleenne entre parentheses\n");
                            $$=strcat(strcat(strdup("("),strdup($2)),strdup(")"));
                     };

boucle_si:    TOK_SI expressionBooleenne TOK_ALORS code TOK_FINSI{
                     printf("\t\t\tBLock SI\n");
              };

boucle_si_sinon: TOK_SI expressionBooleenne TOK_ALORS code TOK_SINON code TOK_FINSI{
                     printf("\t\t\tBLock SI-SINON\n");
              };

boucle_for:   TOK_FOR identificateur TOK_DANS variable TOK_FAIRE code TOK_FINFOR{
                     printf("\t\t\tBLock POUR\n");
              };

boucle_tant_que:  TOK_TANT expressionBooleenne TOK_FAIRE code TOK_FINT{
                        printf("\t\t\tBLock TANTQUE\n");
              };                     

/**/

%%

/********************************************/


int main(int argc, char *argv[]){
 	yyin = fopen(argv[1],"r");

       printf("Debut de analyse syntaxique :\n");

       yyparse();

       printf("Fin de lanalyse !\n");
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