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
    TOK_COMP = 258,
    TOK_DECAL = 259,
    TOK_MOD = 260,
    TOK_PLUS = 261,
    TOK_MOINS = 262,
    TOK_MUL = 263,
    TOK_DIV = 264,
    TOK_PUISS = 265,
    TOK_OU = 266,
    TOK_ET = 267,
    TOK_NON = 268,
    TOK_PARG = 269,
    TOK_PARD = 270,
    TOK_TYPE = 271,
    TOK_NOMBRE = 272,
    TOK_STR = 273,
    TOK_VAR = 274,
    TOK_AFFECT = 275,
    TOK_FINSTR = 276,
    TOK_OUVR = 277,
    TOK_FERM = 278,
    TOK_PONC = 279,
    TOK_FINI = 280,
    TOK_FINF = 281,
    TOK_FINB = 282,
    TOK_SI = 283,
    TOK_ALORS = 284,
    TOK_SINON = 285,
    TOK_FINSI = 286,
    TOK_CAMBIAR = 287,
    TOK_CASE = 288,
    TOK_FOR = 289,
    TOK_DANS = 290,
    TOK_FAIRE = 291,
    TOK_FINFOR = 292,
    TOK_TANT = 293,
    TOK_FINT = 294,
    TOK_LEER = 295,
    TOK_ESCRIR = 296
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 11 "analyzer_syn.y"

       long nombre;
       char* texte;

#line 104 "analyzer_syn.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ANALYZER_SYN_TAB_H_INCLUDED  */
