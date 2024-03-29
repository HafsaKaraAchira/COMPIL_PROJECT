/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_ANALYZER_SYN_TAB_H_INCLUDED
# define YY_YY_ANALYZER_SYN_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_DECAL = 258,
    TOK_MOD = 259,
    TOK_PLUS = 260,
    TOK_MOINS = 261,
    TOK_MUL = 262,
    TOK_DIV = 263,
    TOK_PUISS = 264,
    TOK_OU = 265,
    TOK_ET = 266,
    TOK_NON = 267,
    TOK_EQ = 268,
    TOK_NQ = 269,
    TOK_LT = 270,
    TOK_GT = 271,
    TOK_LE = 272,
    TOK_GE = 273,
    TOK_PARG = 274,
    TOK_PARD = 275,
    NEG = 276,
    TOK_NOMBRE = 277,
    TOK_FLOAT = 278,
    TOK_STR = 279,
    TOK_CHAR = 280,
    TOK_VAR = 281,
    TOK_CSTB = 282,
    TOK_VARB = 283,
    TOK_TYPE = 284,
    TOK_AFFECT = 285,
    TOK_OUVR = 286,
    TOK_FERM = 287,
    TOK_BRACKG = 288,
    TOK_BRACKD = 289,
    TOK_ACCOLG = 290,
    TOK_ACCOLD = 291,
    TOK_VIRG = 292,
    TOK_DPTS = 293,
    TOK_PIPE = 294,
    TOK_FINSTR = 295,
    TOK_FINI = 296,
    TOK_FINF = 297,
    TOK_SI = 298,
    TOK_ALORS = 299,
    TOK_SINON = 300,
    TOK_FINSI = 301,
    TOK_SWITCH = 302,
    TOK_CASE = 303,
    TOK_DEFAULT = 304,
    TOK_CASEDEF = 305,
    TOK_FINSWITCH = 306,
    TOK_FOR = 307,
    TOK_DANS = 308,
    TOK_FAIRE = 309,
    TOK_FINFOR = 310,
    TOK_TANT = 311,
    TOK_FINT = 312,
    TOK_LEER = 313,
    TOK_ESCRIR = 314
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 56 "analyzer_syn.y"

       long nombre;
       char* texte;

#line 122 "analyzer_syn.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ANALYZER_SYN_TAB_H_INCLUDED  */
