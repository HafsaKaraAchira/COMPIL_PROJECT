%{
#include "analyzer.h"
bool error_syntaxical=false;
extern unsigned int lineno;
extern bool error_lexical;
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




%type<texte>            code
%type<texte>            instruction
%type<texte>            affectation
%type<texte>            variable
%type<texte>            variable_arithmetique
%type<texte>            expressionArithmetique
%type<texte>            E

/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */
    
%token               TOK_VRAI        /*true*/
%token               TOK_FAUX        /*false*/
%token               TOK_TYPE        /*type*/
%token<texte>       TOK_NOMBRE         /*variable*/
%token<texte>        TOK_STR         /*variable*/
%token<texte>        TOK_VAR         /*variable*/
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
              printf("Resultat : instruction valide !\n\n");
       }
       |
       code error{
              fprintf(stderr,"\tERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
              error_syntaxical=true;
       };
instruction:  affectation{
                     printf("\tInstruction type Affectation\n");
              };

variable_arithmetique:  TOK_NOMBRE{
                            printf("\t\t\tVariable %s\n",$1);
                            $$=strdup($1);
                     };

variable:     variable_arithmetique{
                     $$=strdup($1);
              };
 
affectation:   variable TOK_AFFECT expressionArithmetique TOK_FINSTR{
                        printf("\t\tAffectation sur la variable %s\n",$1);
              };

expressionArithmetique: E{
              printf("\nResult=%s\n", $$);
              return 0;
       };

 E:E TOK_PLUS E {$$=strcat(strcat(strdup($1),strdup("+")),strdup($3));}
  
 |E TOK_MOINS E {$$=strcat(strcat(strdup($1),strdup("-")),strdup($3));}
  
 |E TOK_MUL E {$$=strcat(strcat(strdup($1),strdup("*")),strdup($3));}
  
 |E TOK_DIV E {$$=strcat(strcat(strdup($1),strdup("/")),strdup($3));}
  
 |E TOK_MOD E {$$=strcat(strcat(strdup($1),strdup("MOD")),strdup($3));}

 |E TOK_PUISS E {$$=strcat(strcat(strdup($1),strdup("^")),strdup($3));}
  
 |TOK_PARG E TOK_PARD {$$=$2;}
  
 | TOK_VAR {$$=strdup($1);}
  
 ;  

%%

/********************************************/


int main(int argc, char *argv[]){
       extern FILE *yyin ;
 	//char filename[50];
 	//scanf("%s",filename);
 	yyin = fopen(argv[0],"r");

       printf("Debut de l'analyse syntaxique :\n");
       
       yyparse();

       printf("Fin de l'analyse !\n");
       printf("Resultat :\n");
       if(error_lexical){
              printf("\t-- Echec a l'analyse lexicale --\n");
       }
       else{
              printf("\t-- Succes a l'analyse lexicale ! --\n");
       }
       if(error_syntaxical){
              printf("\t-- Echec a l'analyse syntaxique --\n");
       }
       else{
              printf("\t-- Succes a l'analyse syntaxique ! --\n");
       }

       return EXIT_SUCCESS;
}

void yyerror(char *s) {
       fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}