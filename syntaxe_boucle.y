

 
%type<texte>            bloc_code
%type<texte>            code
%type<texte>            instruction
%type<texte>            variable
%type<texte>            variable_arithmetique
%type<texte>            variable_booleenne
%type<texte>            affectation
%type<texte>            affichage
%type<texte>            boucle_si
%type<texte>            boucle_si_sinon
%type<texte>            boucle_for
%type<texte>            boucle_tant_que
%type<texte>            declaration

 
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
%token<texte>           TOK_VARE        /* variable arithmetique */
%token<texte>           TOK_VARB        /* variable booleenne */
 
%%
 
/* Nous definissons toutes les regles grammaticales de chaque non terminal de notre langage. Par defaut on commence a definir l'axiome, c'est a dire ici le non terminal code. Si nous le definissons pas en premier nous devons le specifier en option dans Bison avec %start */

bloc_code       TOK_FINB code TOK_FINF{printf("Resultat : C'est la fin du code !\n\n");};
code:           %empty{}
                |
                code instruction{
                        printf("Resultat : C'est une instruction valide !\n\n");
                }
                |
                code error{
                        fprintf(stderr,"\tERREUR : Erreur de syntaxe a la ligne %d.\n",lineno);
                        error_syntaxical=true;
                };
 
instruction:    affectation{
                        printf("\tInstruction type Affectation\n");
                }
                |
                affichage{
                         printf("\tInstruction type Affichage\n");
                }
                |
                suppression{
                        printf("\tInstruction type Suppression\n");
                }
                |
                boucle_for{
                        printf("\tBoucle FOR\n");
                }
                |
                boucle_si{
                        printf("\tBoucle SI\n");
                }
                boucle_si_sinon{
                        printf("\tBoucle SI_SINON\n");
                }
                |
                 boucle_tant_que{
                        printf("\tBoucle SI_SINON\n");
                }
                |
                declaration{
                        printf("\tInstruction type declaration\n");
                }
                ;
 
variable_arithmetique:  TOK_VARE{
                                printf("\t\t\tVariable %s\n",$1);
                                $$=strdup($1);
                        };
 
variable_booleenne:     TOK_VARB{
                                printf("\t\t\tVariable %s\n",$1);
                                $$=strdup($1);
                        };
 
variable:       variable_arithmetique{
                        $$=strdup($1);
                }
                |
                variable_booleenne{
                        $$=strdup($1);
                };
 
affectation:    variable_arithmetique TOK_AFFECT expression_arithmetique TOK_FINL{
                        /* $1 est la valeur du premier non terminal. Ici c'est la valeur du non terminal variable. $3 est la valeur du 2nd non terminal. */
                        printf("\t\tAffectation sur la variable %s\n",$1);
                }
                |
                variable_booleenne TOK_AFFECT expression_booleenne TOK_FINL{
                        printf("\t\tAffectation sur la variable %s\n",$1);
                };
 

affichage:      TOK_AFFICHER expression TOK_FINSTR{
                        printf("\t\tAffichage de la valeur de l'expression %s\n",$2);
                };
boucle_si:      TOK_SI expression_booleenne TOK_ALORS code TOK_FINSI{
                        printf("\t\t\n");
                };
boucle_si_sinon: TOK_SI expression_booleenne TOK_ALORS code TOK_SINON code TOK_FINSI{
                        printf("\t\t\n");
                };
boucle_for:     TOK_FOR variable TOK_DANS variable TOK_FAIRE code TOK_FINPOR{
                        printf("\t\t\n");
                };
boucle_tant_que:  TOK_TANT expression_booleenne TOK_FAIRE code TOK_FINT{
                        printf("\t\t\n");
                };
declaration:  TOK_type variable TOK_FINL{
        printf("\t\t\n");
};
 
