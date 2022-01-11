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



/*
%type<texte>            E
%type<texte>            expressionBooleenne
%type<texte>            variableBooleenne
*/
%type<texte>            code
%type<texte>            instruction
%type<texte>            affectation
%type<texte>            variable
%type<texte>            variableArithmetique
%type<texte>            expressionArithmetique
%type<texte>            addition
%type<texte>            soustraction
%type<texte>            multiplication
%type<texte>            division
%type<texte>            puissance



/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */
    
%token               TOK_VRAI        /*true*/
%token               TOK_FAUX        /*false*/
%token               TOK_TYPE        /*type*/
%token<texte>        TOK_NOMBRE      /*nombre*/
%token<texte>        TOK_STR         /*variable*/
%token<texte>        TOK_VAR         /*variable*/
%token<texte>        TOK_VARB        /*variable*/
%token               TOK_AFFECT      /*<-*/
%token               TOK_FINSTR      /*;*/
%token               TOK_OUVR        /*< { [*/        
%token               TOK_FERM        /*> } ]*/
%token               TOK_PONC        /*, | :*/

%token         TOK_FINF        /*FINITO__INITIO*/
%token         TOK_FINB       /*FINITOPO__finittosi__finitocambiar*/

%token  TOK_SI         /*si*/
%token  TOK_ENTO       /*alors*/
%token  TOK_SINON      /*sinon*/
%token  TOK_CAMBIAR    /*switch*/
%token  TOK_CASE       /*case__defecto*/

%token  TOK_POR       /*case__defecto*/
%token  TOK_EN       /*case__defecto*/
%token  TOK_DARSE       /*case__defecto*/
%token  TOK_TANTQUE       /*case__defecto*/

%token  TOK_LEER                   /*Lecture*/
%token  TOK_ESCRIR                 /*Ecriture*/


%%


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

instruction:  affectation{
              };

affectation:   variable TOK_AFFECT expressionArithmetique TOK_FINSTR{
              printf("\t\t\tInstruction type Affectation : Affectation sur la variable %s\n",$1);
       };

 
variable:     variableArithmetique{
                     $$=strdup($1);
              };       

variableArithmetique:  TOK_VAR{
                                printf("\t\t\tVariable arithmetique : %s\n",$1);
                                $$=strdup($1);
                     }
                     |
                     TOK_NOMBRE{
                            printf("\t\t\tconstant arithmetique : %s\n",$1);
                            $$=strdup($1);
                     };

/*
variable_arithmetique:  
                     |
                     TOK_VAR{
                            //sprintf(a, "%ld", $1);
                            printf("\t\t\tVariable arithmetique %s\n",$1);
                            $$=strdup($1);
                           // free(a);
                     };
*/
 

expressionArithmetique: 
       variableArithmetique{
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

addition:            expressionArithmetique TOK_PLUS expressionArithmetique{      
                            printf("\t\t\tAddition %s\n",buff);
                            $$=strcat(strcat(strdup($1),strdup("+")),strdup($3));
                     };

soustraction:        expressionArithmetique TOK_MOINS expressionArithmetique{
                            printf("\t\t\tSoustraction %s\n",buff);
                            $$=strcat(strcat(strdup($1),strdup("-")),strdup($3));
                     };

multiplication:      expressionArithmetique TOK_MUL expressionArithmetique{
                            buff = strcat(strcat(strdup($1),strdup("*")),strdup($3));
                            printf("\t\t\tMultiplication %s\n",buff);
                            $$= strdup(buff);
                     };

division:            expressionArithmetique TOK_DIV expressionArithmetique{
                            printf("\t\t\tDivision %s\n",buff);
                            $$=strcat(strcat(strdup($1),strdup("/")),strdup($3));
                     };

puissance:           expressionArithmetique TOK_PUISS expressionArithmetique{
                            printf("\t\t\tPuissance %s\n",buff);
                            $$=strcat(strcat(strdup($1),strdup("^")),strdup($3));
                     };

%%

/********************************************/


int main(int argc, char *argv[]){
 	yyin = fopen(argv[1],"r");

       printf("Debut de analyse syntaxique :\n");
       /*char buff[255];
       fgets(buff, 255, yyin);
       printf("1 : %s\n", buff );*/
       
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