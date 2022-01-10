/*** Definition Section ***/
%{

void send_error(char *error ,int line);  
   
#include<stdio.h>
#include<string.h>

bool error_lexical=false;
 
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
/*%x string*/



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
\"				 		{yy_push_state(string); yymore();}
<string>[^\"]*\" 		{ yy_pop_state(); return TOK_VAR}

 /****************************************** block_fonctions ******************************************/
 
<INITIAL>(?i:"inicio") {yy_push_state(block); return TOK_FINF ; }
<block>(?i:"finito")   {yy_pop_state(); return TOK_FINF ; }

 /****************************************** types ******************************************/

(?i:"global"|"sarta"|"carta"|"entero"|"float"|"etiqueta"|"tablero"|"estrectura") {return TOK_TYPE ; }
 
 /****************************************** conditions ******************************************/

(?i:"si")							{yy_push_state(if_block); return TOK_SI ; }
<if_block>(?i:"ento") 				{return TOK_ENTO ; }
<if_block>(?i:"contrario")  		{return TOK_CONTRARIO ;}
<if_block,if_else>(?i:"finitosi")	{yy_pop_state(); return TOK_FINB ; }

(?i:"cambiar")        					  {yy_push_state(matching); return TOK_SWITCH ;}
<matching>(?i:"caso"|"defecto") 		  {yy_push_state(case_block); return TOK_CASE ;}
<matching,case_block>(?i:"finitocambiar") {yy_pop_state(); return TOK_FINB ;}

 /****************************************** boucles ******************************************/

(?i:"por")							{yy_push_state(for_block); return TOK_POR ;}
<for_block>(?i:"en") 			 	{return TOK_EN ;}
<for_block>(?i:"darse") 		 	{return TOK_POR ;}
<for_block>(?i:"finitopor") 		{yy_pop_state(); return TOK_FINB ;}

(?i:"tanto") 						{yy_push_state(while_block); return TOK_PONC ;}
<while_block>(?i:"darse")       	{return TOK_PONC ;}
<while_block>(?i:"finitotanto") 	{yy_pop_state(); return TOK_PONC ;}

 /****************************************** E/S ******************************************/

(?i:"leer")/"("{blanc}*{identificateur}   {return TOK_INPUT ;}
(?i:"escrir")/"("{blanc}*{identificateur} {return TOK_OUTPUT ;}

 /****************************************** operateurs arithmetiques ******************************************/

("+")/({blanc}*({identificateur}|{cst})) 		{return TOK_PLUS ;}
("-")/({blanc}*({identificateur}|{cst})) 		{return TOK_MOINS ;}
("*")/({blanc}*({identificateur}|{cst})) 		{return TOK_MULT ;}
("/")/({blanc}*({identificateur}|{cst})) 		{return TOK_DIV ;}
(?i:"mod")/({blanc}*({identificateur}|{cst})) 	{return TOK_MOD ;}
("^")/({blanc}*({identificateur}|{cst})) 		{return TOK_PUISS ;}

 /****************************************** operateurs logiques ******************************************/

(?i:"NAY") 	{return TOK_NAY ;}
(?i:"AND") 	{return TOK_AND ;}
(?i:"OR") 	{return TOK_OR ;}

 /****************************************** operateurs logiques ******************************************/
 
"<-" {return TOK_AFFECT ;}

 /****************************************** operateurs comparaison ******************************************/

(?i:"eq"|"nq"|"lt"|"gt"|"le"|"ge")/{blanc} {return TOK_COMP ;}

 /****************************************** operateurs decalage ******************************************/

(?i:"DD"|"DG")/{blanc}{nombre}  {return TOK_DECAL ;}

 /****************************************** constants ******************************************/

{cst} {return TOK_VAR ;}

 /****************************************** ponctuation ******************************************/	

"("|"{"|"["|"<" 	{return TOK_OUVR ;}
")"|"}"|"]"|">" 	{return TOK_FERM ;}
","|"|"|":" 		{return TOK_PONC ;}
";" 				{return TOK_FINSTR ;}

 /****************************************** identificateurs ******************************************/

{identificateur} {return TOK_VAR ;}

 /****************************************** commentaires ******************************************/

"**" 						{yy_push_state(comment); yymore();}
<comment>[^"**"]*("**") 	{printf("COMMENTAIRE:\n%s\n",yytext); yy_pop_state(); }
<comment>[^"**"]*[^"**"] 	{send_error(yytext,yylineno);}
!!							{yy_push_state(inlin_comm); yymore();}
<inlin_comm>.*				{yy_pop_state(); }

 /****************************************** blanks ******************************************/

{separateur}	;

 /****************************************** other caracters ******************************************/
 
. 	{send_error(yytext,yylineno);}

 /****************************************** EOF ******************************************/

<<EOF>> {return 0;}

%%

/****************************************** Code Section ******************************************/

void send_error(char *error ,int line){
	gprintf(strerr,"%s <line:%d>",error,yylineno);
	error_lexical=true ;
}

int main(){
	extern FILE *yyin ;
 	char filename[50];
 	printf("Enter the filename: ");
 	scanf("%s",filename);
 	yyin = fopen(filename,"r");
 
	BEGIN(INITIAL);
	yylex();

	return 0;
}

