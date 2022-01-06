/*** Definition Section ***/
%{

void store_token(int index,char *token ,int line) ;
void store_error(char *error ,int line);  
 
 char ENTITES_LEXIQ[13][100][200] ;
 int counts[13] ;
 int cpt = 0 ;

 char errors[100][1000];
 int nb_errors = 0 ;
  
#include<stdio.h>
#include<string.h>
 
%}

%option stack
%option noyywrap
%option yylineno
/*%option debug*/

separateur [ \t\n\r]+
blanc [ \t]+
lettre [a-zA-Z]
chiffre [0-9]
nombre {chiffre}+
signe [-+]
entier {signe}?{nombre}
reel {entier}"."{nombre}
string1 \"[^\"]*\"
string2 \'[^\']*\'
string {string1}|{string2}
cst {entier}|{reel}|{string}
identificateur {lettre}({lettre}|{nombre})*

/*** state Section ***/
%x comment
%x inlin_comm
%x string



%s block
%s if_block
%s if_else
%s for_block
%s while_block
%s matching
%s case_block


/****************************************** Rule Section ******************************************/
%%

 /****************************************** Strings ******************************************/
\"				 					{cpt=5; yy_push_state(string); yymore();}
<string>[^\"]*\" 		{cpt=5; store_token(cpt,yytext,yylineno); yy_pop_state();}

 /****************************************** block_fonctions ******************************************/
 
<INITIAL>(?i:"inicio") {cpt=0 ; store_token(cpt,yytext,yylineno); yy_push_state(block);}
<block>(?i:"finito")   {cpt=0 ; store_token(cpt,yytext,yylineno); yy_pop_state();}
(?i:"finito")   			 {cpt=0 ; store_error(yytext,yylineno);}

 /****************************************** types ******************************************/

(?i:"global"|"sarta"|"carta"|"entero"|"float"|"etiqueta"|"tablero"|"estrectura") {cpt=1; store_token(cpt,yytext,yylineno);}
 
 /****************************************** conditions ******************************************/

(?i:"si")  												{cpt=2; store_token(cpt,yytext,yylineno); yy_push_state(if_block);}
<if_block>(?i:"ento") 						{cpt=2; store_token(cpt,yytext,yylineno);}
<if_block>(?i:"contrario")  			{cpt=2; store_token(cpt,yytext,yylineno);}
<if_block,if_else>(?i:"finitosi") {cpt=2; store_token(cpt,yytext,yylineno); yy_pop_state();}

(?i:"cambiar")        										{cpt=2; store_token(cpt,yytext,yylineno); yy_push_state(matching);}
<matching>(?i:"caso"|"defecto") 					{cpt=2; store_token(cpt,yytext,yylineno); yy_push_state(case_block);}
<case_block>"*"  													{cpt=2; store_token(cpt,yytext,yylineno); yy_pop_state();}
<matching,case_block>(?i:"finitocambiar") {cpt=2; store_token(cpt,yytext,yylineno); yy_pop_state();}

 /****************************************** boucles ******************************************/

(?i:"por")								 	{cpt=3; store_token(cpt,yytext,yylineno); yy_push_state(for_block);}
<for_block>(?i:"en") 			 	{cpt=3; store_token(cpt,yytext,yylineno);}
<for_block>"<"  					 	{cpt=3; store_token(cpt,yytext,yylineno);}
<for_block>":"  					 	{cpt=3; store_token(cpt,yytext,yylineno);}
<for_block>">"  	 		 		 	{cpt=3; store_token(cpt,yytext,yylineno);}
<for_block>(?i:"darse") 	 	{cpt=3; store_token(cpt,yytext,yylineno);}
<for_block>(?i:"finitopor") {cpt=3; store_token(cpt,yytext,yylineno); yy_pop_state();}

(?i:"tanto") 									  {cpt=3; store_token(cpt,yytext,yylineno); yy_push_state(while_block);}
<while_block>(?i:"darse")       {cpt=3; store_token(cpt,yytext,yylineno);}
<while_block>(?i:"finitotanto") {cpt=3; store_token(cpt,yytext,yylineno); yy_pop_state();}

 /****************************************** E/S ******************************************/

(?i:"leer")/"("{blanc}*{identificateur}   {cpt=4; store_token(cpt,yytext,yylineno);}
(?i:"escrir")/"("{blanc}*{identificateur} {cpt=4; store_token(cpt,yytext,yylineno);}

 /****************************************** operateurs arithmetiques ******************************************/

("+"|"-"|"*"|"/"|"mod"|"MOD"|"^")/({blanc}*({identificateur}|{cst})) {cpt=7; store_token(cpt,yytext,yylineno);}

 /****************************************** operateurs logiques ******************************************/

(?i:"NAY"|"AND"|"OR") {cpt=8; store_token(cpt,yytext,yylineno);}

 /****************************************** operateurs logiques ******************************************/
 
"<-" {cpt=9; store_token(cpt,yytext,yylineno);}

 /****************************************** operateurs comparaison ******************************************/

(?i:"eq"|"nq"|"lt"|"gt"|"le"|"ge")/{blanc} {cpt=10; store_token(cpt,yytext,yylineno);}

 /****************************************** operateurs decalage ******************************************/

(?i:"DD"|"DG")/{blanc}{nombre}  {cpt=11; store_token(cpt,yytext,yylineno);}

 /****************************************** constants ******************************************/

{cst} {cpt=5; store_token(cpt,yytext,yylineno);}

 /****************************************** ponctuation ******************************************/	

","|";"|"("|")"|"{"|"}"|"["|"]"|":"|"<"|">" {cpt=6; store_token(cpt,yytext,yylineno);}

 /****************************************** identificateurs ******************************************/

{identificateur} {cpt=12; store_token(cpt,yytext,yylineno);}

 /****************************************** commentaires ******************************************/

"**" 											{yy_push_state(comment); yymore();}
<comment>[^"**"]*("**") 	{printf("COMMENTAIRE:\n%s\n",yytext); yy_pop_state(); }/*strcpy(errors[++nb_errors],yytext);*/
<comment>[^"**"]*[^"**"] 	{store_error(yytext,yylineno);}
!!												{yy_push_state(inlin_comm); yymore();}
<inlin_comm>.*						{printf("COMMENTAIRE:\n%s\n",yytext); yy_pop_state(); }

 /****************************************** blanks ******************************************/

{separateur}	;

 /****************************************** other caracters ******************************************/
 
. 	{store_error(yytext,yylineno);}

 /****************************************** EOF ******************************************/

<<EOF>> {return 0;}

%%

/****************************************** Code Section ******************************************/

void store_token(int index,char *token ,int line){
	char chain[200] ;
	snprintf(chain,200,"%s <line:%d>",token,yylineno);
	strcpy(ENTITES_LEXIQ[index][++counts[index]],chain);
}

void store_error(char *error ,int line){
	char chain[200] ;
	snprintf(chain,200,"%s <line:%d>",error,yylineno);
	strcpy(errors[++nb_errors],chain);
}

int main(){
extern FILE *yyin;//, *yyout;
 char filename[50];
 printf("Enter the filename: ");
 scanf("%s",filename);
 //yyout = fopen("output","w");
 yyin = fopen(filename,"r");
 
 
 for(int i=0;i<13;i++){counts[i] = 0; }
 
strcpy(ENTITES_LEXIQ[0][0],"mot-cles-blocs de fonctions");
strcpy(ENTITES_LEXIQ[1][0],"mot-cles-type");
strcpy(ENTITES_LEXIQ[2][0],"mot-cles-conditionnelles");
strcpy(ENTITES_LEXIQ[3][0],"mot-cles-boucles");
strcpy(ENTITES_LEXIQ[4][0],"mot-cles-E/S");
strcpy(ENTITES_LEXIQ[5][0],"constants");
strcpy(ENTITES_LEXIQ[6][0],"ponctuations");
strcpy(ENTITES_LEXIQ[7][0],"operateurs arithmetiques");
strcpy(ENTITES_LEXIQ[8][0],"operateurs logiques");
strcpy(ENTITES_LEXIQ[9][0],"operateurs affectation");
strcpy(ENTITES_LEXIQ[10][0],"operateurs comparaison");
strcpy(ENTITES_LEXIQ[11][0],"operateurs decalages");
strcpy(ENTITES_LEXIQ[12][0],"identificateurs"); 

	BEGIN(INITIAL);
	yylex();
	for(int i=0;i<13;i++){
		printf("--------------------------------------------------------------------------------------------------\n");
		printf("ENTITE LEXICALE : %s , Count : %d\n\n",ENTITES_LEXIQ[i][0],counts[i]);
		for(int j=0;j<counts[i];j++){
			printf("%s",ENTITES_LEXIQ[i][j+1]);
			for(int k=0; k<30-strlen(ENTITES_LEXIQ[i][j+1]);k++) printf(" ");
			if((j+1)%4 == 0) printf("\n");		
		}
		printf("\n");
	}
	                                                                                                                                         
	printf("\n--------------------------------------------------------------------------------------------------\n--------------------------------------------------------------------------------------------------\n");
	printf("ERREURS LEXICALES , Count : %d\n\n",nb_errors);
	for(int k=0;k<nb_errors;k++){printf("ERROR : %s\n",errors[k]);}

	return 0;
}

