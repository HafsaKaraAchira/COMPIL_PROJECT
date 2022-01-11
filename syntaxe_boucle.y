

 

%type<texte>            code
%type<texte>            instruction
%type<texte>            variable
%type<texte>            variable_arithmetique
%type<texte>            variable_booleenne
%type<texte>            affectation
%type<texte>            affichage



 
/* Nous avons la liste de nos tokens (les terminaux de notre grammaire) */
 
%token                  TOK_FINF                         /* FINITO */
%token                  TOK_FINB 
%token<texte>           TOK_NOMBRE
%token                  TOK_VRAI        /* true */
%token                  TOK_FAUX        /* false */
%token                  TOK_AFFECT      /* = */
%token                  TOK_FINL      /* ; */
%token                  TOK_AFFICHER    /* afficher */
%token                  TOK_SUPPR       /* supprimer *

%token                  TOK_SI
%token                  TOK_SINON
%token                  TOK_ALORS
%token                  TOK_FINSI

%token                  TOK_FOR
%token                  TOK_DANS
%token                  TOK_FAIRE
%token                  TOK_FINPOR

%token                  TOK_TANT
%token                  TOK_FINT

%token                  TOK_type
%token<texte>           TOK_VARE        /*variable arithmetique*/
%token<texte>           TOK_VARB        /*variable booleenne*/
 
%%
 
/* Nous definissons toutes les regles grammaticales de chaque non terminal de notre langage. Par defaut on commence a definir l'axiome, c'est a dire ici le non terminal code. Si nous le definissons pas en premier nous devons le specifier en option dans Bison avec %start */


 
