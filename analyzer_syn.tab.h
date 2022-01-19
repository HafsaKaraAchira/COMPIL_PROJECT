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
    TOK_STR = 278,
    TOK_VAR = 279,
    TOK_CSTB = 280,
    TOK_VARB = 281,
    TOK_TYPE = 282,
    TOK_AFFECT = 283,
    TOK_OUVR = 284,
    TOK_FERM = 285,
    TOK_BRACKG = 286,
    TOK_BRACKD = 287,
    TOK_ACCOLG = 288,
    TOK_ACCOLD = 289,
    TOK_VIRG = 290,
    TOK_DPTS = 291,
    TOK_PIPE = 292,
    TOK_FINSTR = 293,
    TOK_FINI = 294,
    TOK_FINF = 295,
    TOK_SI = 296,
    TOK_ALORS = 297,
    TOK_SINON = 298,
    TOK_FINSI = 299,
    TOK_SWITCH = 300,
    TOK_CASE = 301,
    TOK_DEFAULT = 302,
    TOK_CASEDEF = 303,
    TOK_FINSWITCH = 304,
    TOK_FOR = 305,
    TOK_DANS = 306,
    TOK_FAIRE = 307,
    TOK_FINFOR = 308,
    TOK_TANT = 309,
    TOK_FINT = 310,
    TOK_LEER = 311,
    TOK_ESCRIR = 312
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 47 "analyzer_syn.y"

       long nombre;
       char* texte;

#line 120 "analyzer_syn.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ANALYZER_SYN_TAB_H_INCLUDED  */
