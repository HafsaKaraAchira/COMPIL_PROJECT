/*** Definition Section ***/
%{
#include "analyzer.h"
bool error_lexical=false; 

char * send_error(char *error ,int line);
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
signe [-]
entier {nombre}
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

%s boolean
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
<string>[^\"]*\" 		{	yy_pop_state(); 
							yylval.texte = yytext;
							return (YY_START==boolean?TOK_VARB:TOK_STR) ;
						}
<string>[^\"]*\"/{blanc}+(?i:"eq"|"nq"|"lt"|"gt"|"le"|"ge"|"et"|"ou") 		{	yy_pop_state(); 
																				yylval.texte = (strcmp(yytext,"\"\"") || strspn(yytext,"\r\n\t")==strlen(yytext) ?"false":"true");
																				if(YY_START != boolean){yy_push_state(boolean);}
																				return TOK_CSTB ;
																			}						

 /****************************************** constants ******************************************/

{entier} {
			yylval.texte = yytext; 
			return (YY_START == boolean?TOK_VARB:TOK_NOMBRE) ;
		}		

{entier}/{blanc}+(?i:"eq"|"nq"|"lt"|"gt"|"le"|"ge"|"et"|"ou") 	{ 
																	yylval.texte = (atoi(yytext)?"true":"false") ;
																	if(YY_START != boolean){yy_push_state(boolean);}
																	return TOK_CSTB ;
																}

 /****************************************** block_fonctions ******************************************/
 
(?i:"inicio")/{separateur}+ { return TOK_FINI ; }
(?i:"finito") { return TOK_FINF ; }

 /****************************************** types ******************************************/

(?i:"global"|"sarta"|"carta"|"entero"|"float"|"etiqueta"|"tablero"|"estrectura")/{blanc}+ { yylval.texte = yytext; return TOK_TYPE ; }
 
 /****************************************** conditions ******************************************/

(?i:"si")							{yy_push_state(if_block); yy_push_state(boolean); return TOK_SI ; }
<boolean>(?i:"ento") 				{yy_pop_state(); return TOK_ALORS ; }
<if_block>(?i:"contrario")  		{return TOK_SINON ;}
<if_block,if_else>(?i:"finitosi")	{yy_pop_state(); return TOK_FINSI ; }

(?i:"cambiar")        			  {yy_push_state(matching); return TOK_SWITCH ;}
<matching>(?i:"caso") 	    	  {yy_push_state(case_block);  return TOK_CASE ;}
<matching>(?i:"defecto") 		  {yy_push_state(case_block);  return TOK_DEFAULT ;}
<case_block>"*"				      {yy_pop_state(); return TOK_CASEDEF ;}
<matching>(?i:"finitocambiar")	  {yy_pop_state(); return TOK_FINSWITCH ;}

 /****************************************** boucles ******************************************/

(?i:"por")							{ yy_push_state(for_block); return TOK_FOR ;}
<for_block>(?i:"en") 			 	{return TOK_DANS ;}
<for_block>(?i:"darse") 		 	{return TOK_FAIRE ;}
<for_block>(?i:"finitopor") 		{yy_pop_state(); return TOK_FINFOR ;}

(?i:"tanto") 						{yy_push_state(while_block); yy_push_state(boolean); return TOK_TANT ;}
<while_block,boolean>(?i:"darse")       		{yy_pop_state(); return TOK_FAIRE ;}
<while_block>(?i:"finitotanto") 	{yy_pop_state(); return TOK_FINT ;}

 /****************************************** E/S ******************************************/

(?i:"leer")/{blanc}*"("{blanc}*{identificateur}    {return TOK_LEER ;}
(?i:"escrir")/{blanc}*"("{blanc}*  {return TOK_ESCRIR ;}

 /****************************************** operateurs arithmetiques ******************************************/

("+") 		{return TOK_PLUS ; }
("-") 		{return TOK_MOINS ;}
("*") 		{return TOK_MUL ;}
("/") 		{return TOK_DIV ;}
(?i:"mod") 	{return TOK_MOD ;}
("^") 		{return TOK_PUISS ;}

 /****************************************** operateurs logiques ******************************************/

(?i:"NAY") 	{ if(YY_START != boolean){yy_push_state(boolean);} return TOK_NON ;}
<boolean>(?i:"ET") 	{return TOK_ET ;}
<boolean>(?i:"OU") 	{return TOK_OU ;}

 /****************************************** operateurs logiques ******************************************/
 
"<-" { return TOK_AFFECT ;}

 /****************************************** operateurs comparaison ******************************************/

(?i:"eq")/{blanc}+ {return TOK_EQ ;}
(?i:"nq")/{blanc}+ {return TOK_NQ ;}
(?i:"lt")/{blanc}+ {return TOK_LT ;}
(?i:"gt")/{blanc}+ {return TOK_GT ;}
(?i:"le")/{blanc}+ {return TOK_LE ;}
(?i:"ge")/{blanc}+ {return TOK_GE ;}

 /****************************************** operateurs decalage ******************************************/

(?i:"DD"|"DG")/{blanc}{nombre}  {return TOK_DECAL ;}
						
 /****************************************** ponctuation ******************************************/	
 /*{reel} {yylval.decimal=atof(yytext);	return TOK_NOMBRE;}*/

"(" 	{return TOK_PARG ;}
")" 	{return TOK_PARD ;}

"{" 	{return TOK_ACCOLG ;}
"[" 	{return TOK_BRACKG ;}
"<" 	{return TOK_OUVR ;}

"}" 	{return TOK_ACCOLD ;}
"]" 	{return TOK_BRACKD ;}
">" 	{return TOK_FERM ;}

"," 	{return TOK_VIRG ;}
"|" 	{return TOK_PIPE ;}
":" 	{return TOK_DPTS ;}

";" 	{ 	if(YY_START == boolean) { yy_pop_state(); }
			return TOK_FINSTR ;
		}

 /****************************************** identificateurs ******************************************/

{identificateur}/{blanc}+(?i:"eq"|"nq"|"lt"|"gt"|"le"|"ge"|"et"|"ou") { if(YY_START != boolean){yy_push_state(boolean);} yylval.texte = yytext; return TOK_VARB ;}				
{identificateur} {	yylval.texte = yytext; return (YY_START == boolean?TOK_VARB:TOK_VAR) ;}

	
 /****************************************** commentaires ******************************************/

"**" 						{yy_push_state(comment); yymore();}
<comment>[^"**"]*("**") 	{yy_pop_state(); }
<comment>[^"**"]*[^"**"] 	{send_error(yytext,yylineno);}
!!							{yy_push_state(inlin_comm); yymore();}
<inlin_comm>.*				{yy_pop_state(); }

 /****************************************** blanks ******************************************/
"\n"
{separateur}	;



 /****************************************** other caracters ******************************************/
 
. 	{send_error(yytext,yylineno);}

 /****************************************** EOF ******************************************/

<<EOF>>  { return 0; }

%%

/****************************************** Code Section ******************************************/

char * send_error(char *error ,int line){
	error_lexical=true ;
	return error ;
}
//gcc `pkg-config --cflags glib-2.0` -I/usr/include/glib-2.0 -I/usr/lib/x-86_64-linux-gnu/glib-2.0/include -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wall -Wextra -g *.c -lglib-2.0 -lm

