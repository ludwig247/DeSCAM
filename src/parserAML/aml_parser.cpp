// A Bison parser, made by GNU Bison 3.0.4.

// Skeleton implementation for Bison LALR(1) parsers in C++

// Copyright (C) 2002-2015 Free Software Foundation, Inc.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// As a special exception, you may create a larger work that contains
// part or all of the Bison parser skeleton and distribute that work
// under terms of your choice, so long as that work isn't itself a
// parser generator using the skeleton or a modified version thereof
// as a parser skeleton.  Alternatively, if you modify or redistribute
// the parser skeleton itself, you may (at your option) remove this
// special exception, which will cause the skeleton and the resulting
// Bison output files to be licensed under the GNU General Public
// License without this special exception.

// This special exception was added by the Free Software Foundation in
// version 2.2 of Bison.


// First part of user declarations.

#line 37 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:404

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

#include "aml_parser.hpp"

// User implementation prologue.

#line 51 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:412
// Unqualified %code blocks.
#line 51 "aml_parser.ypp" // lalr1.cc:413

#include "aml_driver.h"

#line 57 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:413


#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> // FIXME: INFRINGES ON USER NAME SPACE.
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K].location)
/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

# ifndef YYLLOC_DEFAULT
#  define YYLLOC_DEFAULT(Current, Rhs, N)                               \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).begin  = YYRHSLOC (Rhs, 1).begin;                   \
          (Current).end    = YYRHSLOC (Rhs, N).end;                     \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).begin = (Current).end = YYRHSLOC (Rhs, 0).end;      \
        }                                                               \
    while (/*CONSTCOND*/ false)
# endif


// Suppress unused-variable warnings by "using" E.
#define YYUSE(E) ((void) (E))

// Enable debugging if requested.
#if YYDEBUG

// A pseudo ostream that takes yydebug_ into account.
# define YYCDEBUG if (yydebug_) (*yycdebug_)

# define YY_SYMBOL_PRINT(Title, Symbol)         \
  do {                                          \
    if (yydebug_)                               \
    {                                           \
      *yycdebug_ << Title << ' ';               \
      yy_print_ (*yycdebug_, Symbol);           \
      *yycdebug_ << std::endl;                  \
    }                                           \
  } while (false)

# define YY_REDUCE_PRINT(Rule)          \
  do {                                  \
    if (yydebug_)                       \
      yy_reduce_print_ (Rule);          \
  } while (false)

# define YY_STACK_PRINT()               \
  do {                                  \
    if (yydebug_)                       \
      yystack_print_ ();                \
  } while (false)

#else // !YYDEBUG

# define YYCDEBUG if (false) std::cerr
# define YY_SYMBOL_PRINT(Title, Symbol)  YYUSE(Symbol)
# define YY_REDUCE_PRINT(Rule)           static_cast<void>(0)
# define YY_STACK_PRINT()                static_cast<void>(0)

#endif // !YYDEBUG

#define yyerrok         (yyerrstatus_ = 0)
#define yyclearin       (yyla.clear ())

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYRECOVERING()  (!!yyerrstatus_)


namespace yy {
#line 143 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:479

  /* Return YYSTR after stripping away unnecessary quotes and
     backslashes, so that it's suitable for yyerror.  The heuristic is
     that double-quoting is unnecessary unless the string contains an
     apostrophe, a comma, or backslash (other than backslash-backslash).
     YYSTR is taken from yytname.  */
  std::string
  aml_parser::yytnamerr_ (const char *yystr)
  {
    if (*yystr == '"')
      {
        std::string yyr = "";
        char const *yyp = yystr;

        for (;;)
          switch (*++yyp)
            {
            case '\'':
            case ',':
              goto do_not_strip_quotes;

            case '\\':
              if (*++yyp != '\\')
                goto do_not_strip_quotes;
              // Fall through.
            default:
              yyr += *yyp;
              break;

            case '"':
              return yyr;
            }
      do_not_strip_quotes: ;
      }

    return yystr;
  }


  /// Build a parser object.
  aml_parser::aml_parser (aml_driver& driver_yyarg)
    :
#if YYDEBUG
      yydebug_ (false),
      yycdebug_ (&std::cerr),
#endif
      driver (driver_yyarg)
  {}

  aml_parser::~aml_parser ()
  {}


  /*---------------.
  | Symbol types.  |
  `---------------*/



  // by_state.
  inline
  aml_parser::by_state::by_state ()
    : state (empty_state)
  {}

  inline
  aml_parser::by_state::by_state (const by_state& other)
    : state (other.state)
  {}

  inline
  void
  aml_parser::by_state::clear ()
  {
    state = empty_state;
  }

  inline
  void
  aml_parser::by_state::move (by_state& that)
  {
    state = that.state;
    that.clear ();
  }

  inline
  aml_parser::by_state::by_state (state_type s)
    : state (s)
  {}

  inline
  aml_parser::symbol_number_type
  aml_parser::by_state::type_get () const
  {
    if (state == empty_state)
      return empty_symbol;
    else
      return yystos_[state];
  }

  inline
  aml_parser::stack_symbol_type::stack_symbol_type ()
  {}


  inline
  aml_parser::stack_symbol_type::stack_symbol_type (state_type s, symbol_type& that)
    : super_type (s, that.location)
  {
      switch (that.type_get ())
    {
      case 95: // sections
        value.move<  std::map<std::string,std::vector<SCAM::Stmt*>>  > (that.value);
        break;

      case 109: // statements
      case 110: // statement
      case 111: // assign_statement
      case 120: // opt_else
        value.move<  std::vector<SCAM::Stmt*>  > (that.value);
        break;

      case 104: // datatype
        value.move< SCAM::DataType* > (that.value);
        break;

      case 123: // expr
        value.move< SCAM::Expr* > (that.value);
        break;

      case 119: // if_statement
        value.move< SCAM::ITE* > (that.value);
        break;

      case 113: // nb_read_statement
      case 116: // get_statement
        value.move< SCAM::NBRead* > (that.value);
        break;

      case 115: // nb_write_statement
      case 117: // set_statement
        value.move< SCAM::NBWrite* > (that.value);
        break;

      case 101: // port_decl
        value.move< SCAM::Port* > (that.value);
        break;

      case 112: // read_statement
      case 118: // req_statement
        value.move< SCAM::Read* > (that.value);
        break;

      case 106: // var_ref
      case 107: // var_ref_parent
      case 108: // var_ref_child
        value.move< SCAM::VariableOperand* > (that.value);
        break;

      case 114: // write_statement
        value.move< SCAM::Write* > (that.value);
        break;

      case 5: // "boolean value"
        value.move< bool > (that.value);
        break;

      case 4: // "number"
        value.move< int > (that.value);
        break;

      case 103: // var_list_comma
        value.move< std::map<std::string,SCAM::Variable*> > (that.value);
        break;

      case 3: // "identifier"
      case 96: // name_header
      case 97: // name_header_list
      case 98: // name_header_el
      case 99: // blocking_key
      case 100: // direction_key
        value.move< std::string > (that.value);
        break;

      case 91: // opt_init
      case 121: // expr_list_comma
        value.move< std::vector<SCAM::Expr*> > (that.value);
        break;

      case 102: // name_list_comma
        value.move< std::vector<std::string> > (that.value);
        break;

      default:
        break;
    }

    // that is emptied.
    that.type = empty_symbol;
  }

  inline
  aml_parser::stack_symbol_type&
  aml_parser::stack_symbol_type::operator= (const stack_symbol_type& that)
  {
    state = that.state;
      switch (that.type_get ())
    {
      case 95: // sections
        value.copy<  std::map<std::string,std::vector<SCAM::Stmt*>>  > (that.value);
        break;

      case 109: // statements
      case 110: // statement
      case 111: // assign_statement
      case 120: // opt_else
        value.copy<  std::vector<SCAM::Stmt*>  > (that.value);
        break;

      case 104: // datatype
        value.copy< SCAM::DataType* > (that.value);
        break;

      case 123: // expr
        value.copy< SCAM::Expr* > (that.value);
        break;

      case 119: // if_statement
        value.copy< SCAM::ITE* > (that.value);
        break;

      case 113: // nb_read_statement
      case 116: // get_statement
        value.copy< SCAM::NBRead* > (that.value);
        break;

      case 115: // nb_write_statement
      case 117: // set_statement
        value.copy< SCAM::NBWrite* > (that.value);
        break;

      case 101: // port_decl
        value.copy< SCAM::Port* > (that.value);
        break;

      case 112: // read_statement
      case 118: // req_statement
        value.copy< SCAM::Read* > (that.value);
        break;

      case 106: // var_ref
      case 107: // var_ref_parent
      case 108: // var_ref_child
        value.copy< SCAM::VariableOperand* > (that.value);
        break;

      case 114: // write_statement
        value.copy< SCAM::Write* > (that.value);
        break;

      case 5: // "boolean value"
        value.copy< bool > (that.value);
        break;

      case 4: // "number"
        value.copy< int > (that.value);
        break;

      case 103: // var_list_comma
        value.copy< std::map<std::string,SCAM::Variable*> > (that.value);
        break;

      case 3: // "identifier"
      case 96: // name_header
      case 97: // name_header_list
      case 98: // name_header_el
      case 99: // blocking_key
      case 100: // direction_key
        value.copy< std::string > (that.value);
        break;

      case 91: // opt_init
      case 121: // expr_list_comma
        value.copy< std::vector<SCAM::Expr*> > (that.value);
        break;

      case 102: // name_list_comma
        value.copy< std::vector<std::string> > (that.value);
        break;

      default:
        break;
    }

    location = that.location;
    return *this;
  }


  template <typename Base>
  inline
  void
  aml_parser::yy_destroy_ (const char* yymsg, basic_symbol<Base>& yysym) const
  {
    if (yymsg)
      YY_SYMBOL_PRINT (yymsg, yysym);
  }

#if YYDEBUG
  template <typename Base>
  void
  aml_parser::yy_print_ (std::ostream& yyo,
                                     const basic_symbol<Base>& yysym) const
  {
    std::ostream& yyoutput = yyo;
    YYUSE (yyoutput);
    symbol_number_type yytype = yysym.type_get ();
    // Avoid a (spurious) G++ 4.8 warning about "array subscript is
    // below array bounds".
    if (yysym.empty ())
      std::abort ();
    yyo << (yytype < yyntokens_ ? "token" : "nterm")
        << ' ' << yytname_[yytype] << " ("
        << yysym.location << ": ";
    YYUSE (yytype);
    yyo << ')';
  }
#endif

  inline
  void
  aml_parser::yypush_ (const char* m, state_type s, symbol_type& sym)
  {
    stack_symbol_type t (s, sym);
    yypush_ (m, t);
  }

  inline
  void
  aml_parser::yypush_ (const char* m, stack_symbol_type& s)
  {
    if (m)
      YY_SYMBOL_PRINT (m, s);
    yystack_.push (s);
  }

  inline
  void
  aml_parser::yypop_ (unsigned int n)
  {
    yystack_.pop (n);
  }

#if YYDEBUG
  std::ostream&
  aml_parser::debug_stream () const
  {
    return *yycdebug_;
  }

  void
  aml_parser::set_debug_stream (std::ostream& o)
  {
    yycdebug_ = &o;
  }


  aml_parser::debug_level_type
  aml_parser::debug_level () const
  {
    return yydebug_;
  }

  void
  aml_parser::set_debug_level (debug_level_type l)
  {
    yydebug_ = l;
  }
#endif // YYDEBUG

  inline aml_parser::state_type
  aml_parser::yy_lr_goto_state_ (state_type yystate, int yysym)
  {
    int yyr = yypgoto_[yysym - yyntokens_] + yystate;
    if (0 <= yyr && yyr <= yylast_ && yycheck_[yyr] == yystate)
      return yytable_[yyr];
    else
      return yydefgoto_[yysym - yyntokens_];
  }

  inline bool
  aml_parser::yy_pact_value_is_default_ (int yyvalue)
  {
    return yyvalue == yypact_ninf_;
  }

  inline bool
  aml_parser::yy_table_value_is_error_ (int yyvalue)
  {
    return yyvalue == yytable_ninf_;
  }

  int
  aml_parser::parse ()
  {
    // State.
    int yyn;
    /// Length of the RHS of the rule being reduced.
    int yylen = 0;

    // Error handling.
    int yynerrs_ = 0;
    int yyerrstatus_ = 0;

    /// The lookahead symbol.
    symbol_type yyla;

    /// The locations where the error started and ended.
    stack_symbol_type yyerror_range[3];

    /// The return value of parse ().
    int yyresult;

    // FIXME: This shoud be completely indented.  It is not yet to
    // avoid gratuitous conflicts when merging into the master branch.
    try
      {
    YYCDEBUG << "Starting parse" << std::endl;


    // User initialization code.
    #line 41 "aml_parser.ypp" // lalr1.cc:741
{
  // Initialize the initial location.
  yyla.location.begin.filename = &driver.filename;
  yyla.location.end.filename = &driver.filename;
}

#line 582 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:741

    /* Initialize the stack.  The initial state will be set in
       yynewstate, since the latter expects the semantical and the
       location values to have been already stored, initialize these
       stacks with a primary value.  */
    yystack_.clear ();
    yypush_ (YY_NULLPTR, 0, yyla);

    // A new symbol was pushed on the stack.
  yynewstate:
    YYCDEBUG << "Entering state " << yystack_[0].state << std::endl;

    // Accept?
    if (yystack_[0].state == yyfinal_)
      goto yyacceptlab;

    goto yybackup;

    // Backup.
  yybackup:

    // Try to take a decision without lookahead.
    yyn = yypact_[yystack_[0].state];
    if (yy_pact_value_is_default_ (yyn))
      goto yydefault;

    // Read a lookahead token.
    if (yyla.empty ())
      {
        YYCDEBUG << "Reading a token: ";
        try
          {
            symbol_type yylookahead (yylex (driver));
            yyla.move (yylookahead);
          }
        catch (const syntax_error& yyexc)
          {
            error (yyexc);
            goto yyerrlab1;
          }
      }
    YY_SYMBOL_PRINT ("Next token is", yyla);

    /* If the proper action on seeing token YYLA.TYPE is to reduce or
       to detect an error, take that action.  */
    yyn += yyla.type_get ();
    if (yyn < 0 || yylast_ < yyn || yycheck_[yyn] != yyla.type_get ())
      goto yydefault;

    // Reduce or error.
    yyn = yytable_[yyn];
    if (yyn <= 0)
      {
        if (yy_table_value_is_error_ (yyn))
          goto yyerrlab;
        yyn = -yyn;
        goto yyreduce;
      }

    // Count tokens shifted since error; after three, turn off error status.
    if (yyerrstatus_)
      --yyerrstatus_;

    // Shift the lookahead token.
    yypush_ ("Shifting", yyn, yyla);
    goto yynewstate;

  /*-----------------------------------------------------------.
  | yydefault -- do the default action for the current state.  |
  `-----------------------------------------------------------*/
  yydefault:
    yyn = yydefact_[yystack_[0].state];
    if (yyn == 0)
      goto yyerrlab;
    goto yyreduce;

  /*-----------------------------.
  | yyreduce -- Do a reduction.  |
  `-----------------------------*/
  yyreduce:
    yylen = yyr2_[yyn];
    {
      stack_symbol_type yylhs;
      yylhs.state = yy_lr_goto_state_(yystack_[yylen].state, yyr1_[yyn]);
      /* Variants are always initialized to an empty instance of the
         correct type. The default '$$ = $1' action is NOT applied
         when using variants.  */
        switch (yyr1_[yyn])
    {
      case 95: // sections
        yylhs.value.build<  std::map<std::string,std::vector<SCAM::Stmt*>>  > ();
        break;

      case 109: // statements
      case 110: // statement
      case 111: // assign_statement
      case 120: // opt_else
        yylhs.value.build<  std::vector<SCAM::Stmt*>  > ();
        break;

      case 104: // datatype
        yylhs.value.build< SCAM::DataType* > ();
        break;

      case 123: // expr
        yylhs.value.build< SCAM::Expr* > ();
        break;

      case 119: // if_statement
        yylhs.value.build< SCAM::ITE* > ();
        break;

      case 113: // nb_read_statement
      case 116: // get_statement
        yylhs.value.build< SCAM::NBRead* > ();
        break;

      case 115: // nb_write_statement
      case 117: // set_statement
        yylhs.value.build< SCAM::NBWrite* > ();
        break;

      case 101: // port_decl
        yylhs.value.build< SCAM::Port* > ();
        break;

      case 112: // read_statement
      case 118: // req_statement
        yylhs.value.build< SCAM::Read* > ();
        break;

      case 106: // var_ref
      case 107: // var_ref_parent
      case 108: // var_ref_child
        yylhs.value.build< SCAM::VariableOperand* > ();
        break;

      case 114: // write_statement
        yylhs.value.build< SCAM::Write* > ();
        break;

      case 5: // "boolean value"
        yylhs.value.build< bool > ();
        break;

      case 4: // "number"
        yylhs.value.build< int > ();
        break;

      case 103: // var_list_comma
        yylhs.value.build< std::map<std::string,SCAM::Variable*> > ();
        break;

      case 3: // "identifier"
      case 96: // name_header
      case 97: // name_header_list
      case 98: // name_header_el
      case 99: // blocking_key
      case 100: // direction_key
        yylhs.value.build< std::string > ();
        break;

      case 91: // opt_init
      case 121: // expr_list_comma
        yylhs.value.build< std::vector<SCAM::Expr*> > ();
        break;

      case 102: // name_list_comma
        yylhs.value.build< std::vector<std::string> > ();
        break;

      default:
        break;
    }


      // Compute the default @$.
      {
        slice<stack_symbol_type, stack_type> slice (yystack_, yylen);
        YYLLOC_DEFAULT (yylhs.location, slice, yylen);
      }

      // Perform the reduction.
      YY_REDUCE_PRINT (yyn);
      try
        {
          switch (yyn)
            {
  case 2:
#line 208 "aml_parser.ypp" // lalr1.cc:859
    {/*MODEL PARSED SUCCESSFULLY*/
}
#line 775 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 11:
#line 225 "aml_parser.ypp" // lalr1.cc:859
    {
  if ( SCAM::DataTypes::isDataType(yystack_[5].value.as< std::string > ()) ) {
    error(yystack_[5].location,"The identifier " + yystack_[5].value.as< std::string > () + " is already used and cannot be re-defined");
    YYERROR;
  }
  SCAM::DataType* dt = new SCAM::DataType(yystack_[5].value.as< std::string > ());
  //add symbolic values
  std::vector<std::string>::iterator itSymVal;
  for (itSymVal=yystack_[2].value.as< std::vector<std::string> > ().begin(); itSymVal!=yystack_[2].value.as< std::vector<std::string> > ().end(); ++itSymVal) {
    if (SCAM::DataTypes::isEnumValue(*itSymVal)) {
      error(yystack_[3].location,"The identifier " + *itSymVal + " is already used and cannot be re-defined");
      YYERROR;
    }
    dt->addEnumValue(*itSymVal);
  }
  SCAM::DataTypes::addDataType(dt);
}
#line 797 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 12:
#line 244 "aml_parser.ypp" // lalr1.cc:859
    {
  if (SCAM::DataTypes::isDataType(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"A data type " + yystack_[5].value.as< std::string > () + " was already defined");
    YYERROR;
  }
  //var_list_comma should not be empty
  if (yystack_[2].value.as< std::map<std::string,SCAM::Variable*> > ().empty()) {
    error(yystack_[2].location,"The identifier " + yystack_[5].value.as< std::string > () + " is already used and cannot be re-defined");
    YYERROR;
  }
  SCAM::DataType* dt = new SCAM::DataType(yystack_[5].value.as< std::string > ());
  //add subVars
  std::map<std::string,SCAM::Variable*>::iterator itSubVar;
  for (itSubVar=yystack_[2].value.as< std::map<std::string,SCAM::Variable*> > ().begin(); itSubVar!=yystack_[2].value.as< std::map<std::string,SCAM::Variable*> > ().end(); ++itSubVar) {
    dt->addSubVar(itSubVar->first, itSubVar->second->getDataType());
  }
  SCAM::DataTypes::addDataType(dt);

}
#line 821 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 13:
#line 265 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 827 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 14:
#line 266 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 833 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 15:
#line 267 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 839 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 19:
#line 275 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 845 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 24:
#line 283 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 851 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 27:
#line 289 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 857 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 28:
#line 291 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 863 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 29:
#line 293 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 869 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 30:
#line 295 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 875 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 32:
#line 306 "aml_parser.ypp" // lalr1.cc:859
    {
  bool ok;
  ok = driver.addModule( new SCAM::Module(yystack_[1].value.as< std::string > ()) );
  if (!ok) {
    error(yystack_[1].location,"A module named " + yystack_[1].value.as< std::string > () + " is already defined");
    YYERROR;
  }
}
#line 888 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 33:
#line 315 "aml_parser.ypp" // lalr1.cc:859
    {
  //module_ports, adds ports to currentModule in rule
  //section_var, adds sectionVariable (with new enum DataType) to currentModule in rule
  //module_vars, adds variables to currentModule in rule

  //sections, returns a sectionMap, added here to currentModule

  //SCAM::FSM* fsm = new SCAM::FSM;
   driver.module->getFSM()->setSectionMap(yystack_[3].value.as<  std::map<std::string,std::vector<SCAM::Stmt*>>  > ());
  //fsm->setSectionMap($6);
  //driver.module->setFSM(fsm);
}
#line 905 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 34:
#line 330 "aml_parser.ypp" // lalr1.cc:859
    {
  driver.module->addPort(yystack_[0].value.as< SCAM::Port* > ());
}
#line 913 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 35:
#line 334 "aml_parser.ypp" // lalr1.cc:859
    {
  //check name against the names of the already defined ones
  if (driver.module->isPort(yystack_[0].value.as< SCAM::Port* > ()->getName())) {
    error(yystack_[0].location,"A port named " + yystack_[0].value.as< SCAM::Port* > ()->getName() + " is already defined");
    YYERROR;
  }
  driver.module->addPort(yystack_[0].value.as< SCAM::Port* > ());
}
#line 926 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 36:
#line 344 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 932 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 37:
#line 345 "aml_parser.ypp" // lalr1.cc:859
    { yylhs.value.as< std::vector<SCAM::Expr*> > ().push_back(yystack_[0].value.as< SCAM::Expr* > ());}
#line 938 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 38:
#line 346 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as< std::vector<SCAM::Expr*> > (),yystack_[1].value.as< std::vector<SCAM::Expr*> > ());}
#line 944 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 39:
#line 352 "aml_parser.ypp" // lalr1.cc:859
    {
  if (yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size() == 1) {
    // must be a name from the sections list
    if (driver.module->getFSM()->getSectionVariable()->getDataType() != yystack_[1].value.as< std::vector<SCAM::Expr*> > ().at(0)->getDataType()) {
      error(yystack_[1].location, "expected a section name");
      YYERROR;
    } {
      SCAM::SectionValue* initval = new SCAM::SectionValue((dynamic_cast<SCAM::SectionValue*>(yystack_[1].value.as< std::vector<SCAM::Expr*> > ().at(0)))->getValue(), driver.module->getFSM()->getSectionVariable()->getDataType());
      driver.module->getFSM()->getSectionVariable()->setInitialValue(initval);
      driver.module->getFSM()->getNextSectionVariable()->setInitialValue(initval);
    }

  } else {
    if (yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size() > 1) {
      error(yystack_[1].location, "initialization of section must be a scalar type");
      YYERROR;
    }
  }
}
#line 968 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 40:
#line 373 "aml_parser.ypp" // lalr1.cc:859
    {

  SCAM::DataType* sectionDataType = new SCAM::DataType(driver.module->getName()+"_SECTIONS");
  //add symbolic values
  std::vector<std::string>::iterator itSymVal;
  for (itSymVal=yystack_[1].value.as< std::vector<std::string> > ().begin(); itSymVal!=yystack_[1].value.as< std::vector<std::string> > ().end(); ++itSymVal) {
    if (SCAM::DataTypes::isEnumValue(*itSymVal)) {
      error(yystack_[1].location, "identifier " + *itSymVal + " is already in use"); YYERROR;
    }
    sectionDataType->addEnumValue(*itSymVal);
  }

  driver.module->getFSM()->setSections(sectionDataType);
}
#line 987 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 42:
#line 392 "aml_parser.ypp" // lalr1.cc:859
    {
  //check name against the names of the already defined ones
  if (driver.module->isVariable(yystack_[2].value.as< std::string > ())) {
    error(yystack_[2].location,"A variable named " + yystack_[2].value.as< std::string > () + " is already defined");  YYERROR;
  }
  //check the name agains enum values
  if (SCAM::DataTypes::isEnumValue(yystack_[2].value.as< std::string > ())) {
    error(yystack_[2].location,"identifier " + yystack_[2].value.as< std::string > () + " is already used as enum value");  YYERROR;
  }
  //check against all section names
  if (driver.module->getFSM()->isSectionValue(yystack_[2].value.as< std::string > ()) ) {
    error(yystack_[2].location,"identifier " + yystack_[2].value.as< std::string > () + " is already used as section name");  YYERROR;
  }
  SCAM::Variable* variable = new SCAM::Variable(yystack_[2].value.as< std::string > (),yystack_[3].value.as< SCAM::DataType* > ());
  driver.module->addVariable( variable );


  // scalar type initialization
  if (yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size() == 1) {
    //datatype should be the same
    if (yystack_[1].value.as< std::vector<SCAM::Expr*> > ().at(0)->getDataType() != yystack_[3].value.as< SCAM::DataType* > ()) {
      error(yystack_[1].location, "datatype of initialization does not match the datatype of the variable");
      YYERROR;
    }
    //init must be (reducable to) a constant
    if (!driver.isConstExpr(yystack_[1].value.as< std::vector<SCAM::Expr*> > ().at(0))) { //should actually not be reachable since no variable are declared yet
      error(yystack_[1].location, "initialization value must be constant");  YYERROR;
    }
    variable->setInitialValue(driver.reduzeToConstValue(yystack_[1].value.as< std::vector<SCAM::Expr*> > ().at(0)));
  }

  // Compound type initialization
  if (yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size() > 1) {
    //variable must be a compound  and list size must match
    if (! yystack_[3].value.as< SCAM::DataType* > ()->isCompoundType() || yystack_[3].value.as< SCAM::DataType* > ()->getSubVarMap().size() != yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size()) {
      error(yystack_[1].location, "datatype of initialization does not match the datatype of the variable");  YYERROR;
    }

    std::vector<SCAM::Expr*>::const_iterator initexpr = yystack_[1].value.as< std::vector<SCAM::Expr*> > ().begin();
    for (auto &&subvar : variable->getSubVarList()) {

      //all datatypes must match
      if ( (*initexpr)->getDataType() != (*subvar).getDataType() ) {
        error(yystack_[1].location, "datatype of initialization does not match the datatype of the variable");  YYERROR;
      }

      //if enum (no need to reduce)
      if ((*initexpr)->getDataType()->isEnumType() ) {
        (*subvar).setInitialValue(dynamic_cast<SCAM::EnumValue*>(*initexpr));
      } else {
        //expression must (reduce to) be constant
        if (!driver.isConstExpr(*initexpr)) {
          error(yystack_[1].location, "initialization values must be constant");  YYERROR;
        }
        (*subvar).setInitialValue(driver.reduzeToConstValue(*initexpr));
      }
      ++initexpr;
    }

  }
}
#line 1053 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 43:
#line 456 "aml_parser.ypp" // lalr1.cc:859
    {                  yylhs.value.as<  std::map<std::string,std::vector<SCAM::Stmt*>>  > ()[yystack_[2].value.as< std::string > ()] = yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ();}
#line 1059 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 44:
#line 457 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as<  std::map<std::string,std::vector<SCAM::Stmt*>>  > (),yystack_[4].value.as<  std::map<std::string,std::vector<SCAM::Stmt*>>  > ()); yylhs.value.as<  std::map<std::string,std::vector<SCAM::Stmt*>>  > ()[yystack_[2].value.as< std::string > ()] = yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ();}
#line 1065 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 45:
#line 465 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > ()=yystack_[0].value.as< std::string > ();}
#line 1071 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 46:
#line 466 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > ()= yystack_[3].value.as< std::string > () + "<" + yystack_[1].value.as< std::string > () + ">";}
#line 1077 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 47:
#line 468 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = yystack_[0].value.as< std::string > (); }
#line 1083 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 48:
#line 469 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = yystack_[1].value.as< std::string > () + yystack_[0].value.as< std::string > ();}
#line 1089 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 49:
#line 471 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = yystack_[0].value.as< std::string > (); }
#line 1095 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 50:
#line 472 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "int"; }
#line 1101 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 51:
#line 473 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "bool"; }
#line 1107 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 52:
#line 474 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "["; }
#line 1113 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 53:
#line 475 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "]"; }
#line 1119 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 54:
#line 476 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = ","; }
#line 1125 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 55:
#line 482 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "blocking";}
#line 1131 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 56:
#line 483 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "blocking";}
#line 1137 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 57:
#line 484 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "shared";}
#line 1143 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 58:
#line 486 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "in";}
#line 1149 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 59:
#line 487 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::string > () = "out";}
#line 1155 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 60:
#line 491 "aml_parser.ypp" // lalr1.cc:859
    {
  yylhs.value.as< SCAM::Port* > () = new SCAM::Port(yystack_[1].value.as< std::string > (), new SCAM::Interface(yystack_[6].value.as< std::string > (), yystack_[5].value.as< std::string > ()), yystack_[3].value.as< SCAM::DataType* > ());
}
#line 1163 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 61:
#line 497 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1169 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 62:
#line 498 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::vector<std::string> > ().push_back(yystack_[0].value.as< std::string > ());}
#line 1175 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 63:
#line 500 "aml_parser.ypp" // lalr1.cc:859
    {
  std::swap(yylhs.value.as< std::vector<std::string> > (), yystack_[2].value.as< std::vector<std::string> > ());
  //check name against the names of the already defined ones
  if (std::find(yylhs.value.as< std::vector<std::string> > ().begin(), yylhs.value.as< std::vector<std::string> > ().end(), yystack_[0].value.as< std::string > ()) != yylhs.value.as< std::vector<std::string> > ().end()) {
    error(yystack_[0].location,"An identifier with name " + yystack_[0].value.as< std::string > () + " is already defined in this scope");
    YYERROR;
  }
  yylhs.value.as< std::vector<std::string> > ().push_back(yystack_[0].value.as< std::string > ());
}
#line 1189 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 64:
#line 510 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1195 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 65:
#line 511 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::map<std::string,SCAM::Variable*> > ()[yystack_[0].value.as< std::string > ()] = new SCAM::Variable(yystack_[0].value.as< std::string > (), yystack_[1].value.as< SCAM::DataType* > ());}
#line 1201 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 66:
#line 513 "aml_parser.ypp" // lalr1.cc:859
    {
  std::swap(yylhs.value.as< std::map<std::string,SCAM::Variable*> > (), yystack_[3].value.as< std::map<std::string,SCAM::Variable*> > ());
  //check name against the names of the already defined ones
  if (yylhs.value.as< std::map<std::string,SCAM::Variable*> > ().find(yystack_[0].value.as< std::string > ()) != yylhs.value.as< std::map<std::string,SCAM::Variable*> > ().end()) {
    error(yystack_[0].location,"An identifier with name " + yystack_[0].value.as< std::string > () + " is already defined in this scope");
    YYERROR;
  }
  yylhs.value.as< std::map<std::string,SCAM::Variable*> > ()[yystack_[0].value.as< std::string > ()] = new SCAM::Variable(yystack_[0].value.as< std::string > (), yystack_[1].value.as< SCAM::DataType* > ());
}
#line 1215 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 67:
#line 525 "aml_parser.ypp" // lalr1.cc:859
    { yylhs.value.as< SCAM::DataType* > () = SCAM::DataTypes::getDataType("int");  }
#line 1221 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 68:
#line 526 "aml_parser.ypp" // lalr1.cc:859
    { yylhs.value.as< SCAM::DataType* > () = SCAM::DataTypes::getDataType("bool"); }
#line 1227 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 69:
#line 528 "aml_parser.ypp" // lalr1.cc:859
    {
  //check that $1 is a valid datatype
  if (!SCAM::DataTypes::isDataType(yystack_[0].value.as< std::string > ())) {
    error(yystack_[0].location,"\"" + yystack_[0].value.as< std::string > () + "\" is not a valid datatype");
    YYERROR;
  }
  yylhs.value.as< SCAM::DataType* > () = SCAM::DataTypes::getDataType(yystack_[0].value.as< std::string > ());
}
#line 1240 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 70:
#line 537 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1246 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 71:
#line 538 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1252 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 72:
#line 542 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::VariableOperand* > ()=yystack_[0].value.as< SCAM::VariableOperand* > ();}
#line 1258 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 73:
#line 543 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::VariableOperand* > ()=yystack_[0].value.as< SCAM::VariableOperand* > ();}
#line 1264 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 74:
#line 548 "aml_parser.ypp" // lalr1.cc:859
    {
  //search for $1 in list of variables
  if (!driver.module->isVariable(yystack_[0].value.as< std::string > ())) {
    error(yystack_[0].location,"expected identifier for a variable, found \"" + yystack_[0].value.as< std::string > () + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::VariableOperand* > () = new SCAM::VariableOperand(driver.module->getVariable(yystack_[0].value.as< std::string > ()));
}
#line 1277 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 75:
#line 559 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!driver.module->isVariable(yystack_[2].value.as< std::string > ())) {
    error(yystack_[2].location,"expected an identifier for a variable, found \"" + yystack_[2].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Variable* parent = driver.module->getVariable(yystack_[2].value.as< std::string > ());
  if (!parent->isCompoundType() || !parent->hasSubVar(yystack_[0].value.as< std::string > ())) {
    error(yystack_[0].location, yystack_[2].value.as< std::string > () + "does not have a member named \"" + yystack_[0].value.as< std::string > () + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::VariableOperand* > () = new SCAM::VariableOperand(parent->getSubVar(yystack_[0].value.as< std::string > ()));
}
#line 1294 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 76:
#line 575 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as<  std::vector<SCAM::Stmt*>  > (),yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ());}
#line 1300 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 77:
#line 576 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as<  std::vector<SCAM::Stmt*>  > (),yystack_[1].value.as<  std::vector<SCAM::Stmt*>  > ());  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().insert(yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().end(), yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ().begin(), yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ().end());}
#line 1306 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 78:
#line 580 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as<  std::vector<SCAM::Stmt*>  > (),yystack_[1].value.as<  std::vector<SCAM::Stmt*>  > ());}
#line 1312 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 79:
#line 581 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[0].value.as< SCAM::ITE* > ());}
#line 1318 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 80:
#line 582 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::Write* > ());}
#line 1324 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 81:
#line 583 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::Read* > ());}
#line 1330 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 82:
#line 584 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::NBWrite* > ());}
#line 1336 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 83:
#line 585 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::NBRead* > ());}
#line 1342 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 84:
#line 586 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::NBRead* > ());}
#line 1348 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 85:
#line 587 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::NBWrite* > ());}
#line 1354 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 86:
#line 588 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[1].value.as< SCAM::Read* > ());}
#line 1360 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 87:
#line 593 "aml_parser.ypp" // lalr1.cc:859
    {
  if (yystack_[2].value.as< SCAM::VariableOperand* > ()->getDataType() != yystack_[0].value.as< SCAM::Expr* > ()->getDataType()) { error(yystack_[1].location, "data type missmatch in assignment"); YYERROR; }
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(yystack_[2].value.as< SCAM::VariableOperand* > (), yystack_[0].value.as< SCAM::Expr* > ()));
}
#line 1369 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 88:
#line 598 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[2].value.as< SCAM::VariableOperand* > ()->isDataType("bool")) { error(yystack_[1].location, "data type missmatch in assignment"); YYERROR; }
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(yystack_[2].value.as< SCAM::VariableOperand* > (), yystack_[0].value.as< SCAM::NBRead* > ()));
}
#line 1378 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 89:
#line 603 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[2].value.as< SCAM::VariableOperand* > ()->isDataType("bool")) { error(yystack_[2].location, "expected a boolean variable"); YYERROR; }
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(yystack_[2].value.as< SCAM::VariableOperand* > (), yystack_[0].value.as< SCAM::NBWrite* > ()));
}
#line 1387 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 90:
#line 608 "aml_parser.ypp" // lalr1.cc:859
    {
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(yystack_[0].value.as< SCAM::VariableOperand* > (), new SCAM::Arithmetic(yystack_[0].value.as< SCAM::VariableOperand* > (),"+",new SCAM::IntegerValue(1)) ));
}
#line 1395 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 91:
#line 612 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[0].value.as< SCAM::VariableOperand* > ()->isDataType("int") ) { error(yystack_[0].location, "expected an integer type operand"); YYERROR; }
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(yystack_[0].value.as< SCAM::VariableOperand* > (), new SCAM::Arithmetic(yystack_[0].value.as< SCAM::VariableOperand* > (),"-",new SCAM::IntegerValue(1)) ));
}
#line 1404 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 92:
#line 617 "aml_parser.ypp" // lalr1.cc:859
    {
  if (yystack_[0].value.as< SCAM::Expr* > ()->getDataType() != driver.module->getFSM()->getSectionVariable()->getDataType()) {
    error(yystack_[0].location, "expected a section name");
    YYERROR;
  }
  yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment( new SCAM::SectionOperand(driver.module->getFSM()->getSectionVariable()), yystack_[0].value.as< SCAM::Expr* > ()));
}
#line 1416 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 93:
#line 625 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[4].value.as< SCAM::VariableOperand* > ()->getDataType()->isCompoundType()) {
    error(yystack_[3].location, "cannot assign a compound expression to a non-compound variable");
    YYERROR;
  }
  //list size must be the same as number of sub-variables
  if (yystack_[4].value.as< SCAM::VariableOperand* > ()->getDataType()->getSubVarMap().size() != yystack_[1].value.as< std::vector<SCAM::Expr*> > ().size()) {
    error(yystack_[3].location, "compound expression type does not match compound variable type");
    YYERROR;
  }
  //the datatype of the expression list, must match the data type of the sub-var list
  std::vector<SCAM::Expr*>::const_iterator itExpr = yystack_[1].value.as< std::vector<SCAM::Expr*> > ().begin();
  std::map<std::string,SCAM::DataType*>::const_iterator itVar;
  for (itVar = yystack_[4].value.as< SCAM::VariableOperand* > ()->getDataType()->getSubVarMap().begin(); itVar != yystack_[4].value.as< SCAM::VariableOperand* > ()->getDataType()->getSubVarMap().end(); ++itVar) {
    if (itVar->second != (*itExpr)->getDataType()) {
      error(yystack_[3].location, "compound expression type does not match compound variable type");
      YYERROR;
    }

    SCAM::VariableOperand* subOperand = new SCAM::VariableOperand( driver.module->getVariable(yystack_[4].value.as< SCAM::VariableOperand* > ()->getOperandName() + "." + itVar->first ) );
    yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(new SCAM::Assignment(subOperand, *itExpr));

    ++itExpr;
  }
}
#line 1446 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 94:
#line 653 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "in"  || port->getInterface()->getInterface() != "blocking") {
    error(yystack_[5].location,"expected a blocking input port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::VariableOperand* > ()->getDataType()) {
      error(yystack_[1].location, "data type of variable \"" + yystack_[1].value.as< SCAM::VariableOperand* > ()->getOperandName() + "\" does not match data type of input port \"" + port->getName() + "\"");
      YYERROR;
  }
  yylhs.value.as< SCAM::Read* > () = new SCAM::Read(port, yystack_[1].value.as< SCAM::VariableOperand* > ());
}
#line 1468 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 95:
#line 673 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "in" || port->getInterface()->getInterface() != "blocking") {
    error(yystack_[5].location,"expected a blocking input port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::VariableOperand* > ()->getDataType()) {
    error(yystack_[1].location, "data type of variable \"" + yystack_[1].value.as< SCAM::VariableOperand* > ()->getOperandName() + "\" does not match data type of input port \"" + port->getName() + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::NBRead* > () = new SCAM::NBRead(port, yystack_[1].value.as< SCAM::VariableOperand* > ());
}
#line 1490 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 96:
#line 693 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "out"  || port->getInterface()->getInterface() != "blocking") {
    error(yystack_[5].location,"expected a blocking output port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::Expr* > ()->getDataType()) {
    error(yystack_[1].location, "data type of write argument does not match data type of output port \"" + port->getName() + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::Write* > () = new SCAM::Write(port, yystack_[1].value.as< SCAM::Expr* > ());
}
#line 1512 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 97:
#line 713 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "out" || port->getInterface()->getInterface() != "blocking") {
    error(yystack_[5].location,"expected a blocking output port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::Expr* > ()->getDataType()) {
    error(yystack_[1].location, "data type of nb_write argument does not match data type of output port \"" + port->getName() + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::NBWrite* > () = new SCAM::NBWrite(port, yystack_[1].value.as< SCAM::Expr* > ());
}
#line 1534 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 98:
#line 734 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "in" || port->getInterface()->getInterface() != "shared") {
    error(yystack_[5].location,"expected a shared input port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::VariableOperand* > ()->getDataType()) {
    error(yystack_[1].location, "data type of variable \"" + yystack_[1].value.as< SCAM::VariableOperand* > ()->getOperandName() + "\" does not match data type of input port \"" + port->getName() + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::NBRead* > () = new SCAM::NBRead(port, yystack_[1].value.as< SCAM::VariableOperand* > ());
}
#line 1556 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 99:
#line 755 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[5].value.as< std::string > ())) {
    error(yystack_[5].location,"expected identifier for a port, found \"" + yystack_[5].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[5].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "out" || port->getInterface()->getInterface() != "shared") {
    error(yystack_[5].location,"expected a blocking output port");
    YYERROR;
  }
  if (port->getDataType() != yystack_[1].value.as< SCAM::Expr* > ()->getDataType()) {
    error(yystack_[1].location, "data type of set argument does not match data type of output port \"" + port->getName() + "\"");
    YYERROR;
  }
  yylhs.value.as< SCAM::NBWrite* > () = new SCAM::NBWrite(port, yystack_[1].value.as< SCAM::Expr* > ());
}
#line 1578 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 100:
#line 777 "aml_parser.ypp" // lalr1.cc:859
    {
  //use name to find a PortOperand
  if (!driver.module->isPort(yystack_[2].value.as< std::string > ())) {
    error(yystack_[2].location,"expected identifier for a port, found \"" + yystack_[2].value.as< std::string > () + "\"");
    YYERROR;
  }
  SCAM::Port* port = driver.module->getPort(yystack_[2].value.as< std::string > ());
  if (port->getInterface()->getDirection() != "in" || port->getInterface()->getInterface() != "synch"  ) {
    error(yystack_[2].location,"expected a blocking input port");
    YYERROR;
  }
  yylhs.value.as< SCAM::Read* > () = new SCAM::Read(port,nullptr);
}
#line 1596 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 101:
#line 795 "aml_parser.ypp" // lalr1.cc:859
    {
  //check that $3 is a Boolean Expression
  if (! yystack_[5].value.as< SCAM::Expr* > ()->isDataType("bool")) {
    error(yystack_[5].location, "expected a Boolean logic expression as if condition");
    YYERROR;
  }
  yylhs.value.as< SCAM::ITE* > () = new SCAM::ITE(yystack_[5].value.as< SCAM::Expr* > ());
  yylhs.value.as< SCAM::ITE* > ()->setIfList(yystack_[2].value.as<  std::vector<SCAM::Stmt*>  > ());

  if (! yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ().empty() ) {
    yylhs.value.as< SCAM::ITE* > ()->setElseList(yystack_[0].value.as<  std::vector<SCAM::Stmt*>  > ());
  }
}
#line 1614 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 102:
#line 810 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1620 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 103:
#line 811 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as<  std::vector<SCAM::Stmt*>  > (),yystack_[1].value.as<  std::vector<SCAM::Stmt*>  > ());}
#line 1626 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 104:
#line 812 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as<  std::vector<SCAM::Stmt*>  > ().push_back(yystack_[0].value.as< SCAM::ITE* > ());}
#line 1632 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 105:
#line 817 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1638 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 106:
#line 818 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< std::vector<SCAM::Expr*> > ().push_back(yystack_[0].value.as< SCAM::Expr* > ());}
#line 1644 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 107:
#line 819 "aml_parser.ypp" // lalr1.cc:859
    {std::swap(yylhs.value.as< std::vector<SCAM::Expr*> > (),yystack_[2].value.as< std::vector<SCAM::Expr*> > ()); yylhs.value.as< std::vector<SCAM::Expr*> > ().push_back(yystack_[0].value.as< SCAM::Expr* > ());}
#line 1650 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 108:
#line 821 "aml_parser.ypp" // lalr1.cc:859
    {}
#line 1656 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 109:
#line 826 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::Expr* > () = new SCAM::BoolValue(yystack_[0].value.as< bool > ());}
#line 1662 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 110:
#line 827 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::Expr* > () = new SCAM::IntegerValue(yystack_[0].value.as< int > ());}
#line 1668 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 111:
#line 829 "aml_parser.ypp" // lalr1.cc:859
    {
  //should be an identifier for a variable (return VariableOperand*)
  //or for an EnumValue (return EnumValue*)
  //or for a section name

  if (driver.module->isVariable(yystack_[0].value.as< std::string > ())) {
    yylhs.value.as< SCAM::Expr* > () = new SCAM::VariableOperand(driver.module->getVariable(yystack_[0].value.as< std::string > ()));
  } else if (SCAM::DataTypes::isEnumValue(yystack_[0].value.as< std::string > ())) {
    yylhs.value.as< SCAM::Expr* > () = new SCAM::EnumValue(yystack_[0].value.as< std::string > (), SCAM::DataTypes::getEnumValueType(yystack_[0].value.as< std::string > ()));
  } else if (driver.module->getFSM()->isSectionValue(yystack_[0].value.as< std::string > ())) {
      yylhs.value.as< SCAM::Expr* > () = new SCAM::SectionValue(yystack_[0].value.as< std::string > (), driver.module->getFSM()->getSectionVariable()->getDataType() );
  } else {
    error(yystack_[0].location, "expected an identifier found, \"" + yystack_[0].value.as< std::string > () + "\"");
    YYERROR;
  }

}
#line 1690 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 112:
#line 846 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::Expr* > () = yystack_[1].value.as< SCAM::Expr* > ();}
#line 1696 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 113:
#line 847 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[0].location,"functions are not yet supported"); YYERROR; }
#line 1702 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 114:
#line 848 "aml_parser.ypp" // lalr1.cc:859
    {yylhs.value.as< SCAM::Expr* > () = yystack_[0].value.as< SCAM::VariableOperand* > ();}
#line 1708 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 115:
#line 854 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression");  YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Arithmetic(yystack_[2].value.as< SCAM::Expr* > (), "+", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1718 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 116:
#line 860 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression");  YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Arithmetic(yystack_[2].value.as< SCAM::Expr* > (), "-", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1728 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 117:
#line 866 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression");  YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Arithmetic(yystack_[2].value.as< SCAM::Expr* > (), "*", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1738 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 118:
#line 872 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression");  YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Arithmetic(yystack_[2].value.as< SCAM::Expr* > (), "/", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1748 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 119:
#line 878 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression");  YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Arithmetic(yystack_[2].value.as< SCAM::Expr* > (), "%", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1758 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 120:
#line 884 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression");  YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::UnaryExpr("-", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1767 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 121:
#line 889 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[2].location,"functions are not yet supported"); YYERROR;}
#line 1773 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 122:
#line 890 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[2].location,"functions are not yet supported"); YYERROR;}
#line 1779 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 123:
#line 891 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[2].location,"functions are not yet supported"); YYERROR;}
#line 1785 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 124:
#line 892 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[2].location,"functions are not yet supported"); YYERROR;}
#line 1791 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 125:
#line 893 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[2].location,"functions are not yet supported"); YYERROR;}
#line 1797 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 126:
#line 894 "aml_parser.ypp" // lalr1.cc:859
    {error(yystack_[1].location,"functions are not yet supported"); YYERROR;}
#line 1803 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 127:
#line 897 "aml_parser.ypp" // lalr1.cc:859
    {
  //not same data type
  if (yystack_[2].value.as< SCAM::Expr* > ()->getDataType() !=  yystack_[0].value.as< SCAM::Expr* > ()->getDataType()) { error(yystack_[1].location, "data type missmatch in expression"); YYERROR; }
  //not compound
  if ( yystack_[2].value.as< SCAM::Expr* > ()->getDataType()->isCompoundType() ) { error(yystack_[1].location, "operator \"==\" not supported for compound types "); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), "==", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1815 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 128:
#line 905 "aml_parser.ypp" // lalr1.cc:859
    {
  //not same data type
  if (yystack_[2].value.as< SCAM::Expr* > ()->getDataType() !=  yystack_[0].value.as< SCAM::Expr* > ()->getDataType()) { error(yystack_[1].location, "data type missmatch in expression"); YYERROR; }
  //not compound
  if ( yystack_[2].value.as< SCAM::Expr* > ()->getDataType()->isCompoundType() ) { error(yystack_[1].location, "operator \"!=\" not supported for compound types "); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), "!=", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1827 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 129:
#line 914 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), ">", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1837 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 130:
#line 920 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), ">=", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1847 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 131:
#line 926 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), "<", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1857 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 132:
#line 932 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("int")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Relational(yystack_[2].value.as< SCAM::Expr* > (), "<=", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1867 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 133:
#line 940 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "and", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1877 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 134:
#line 946 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "or", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1887 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 135:
#line 952 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "nor", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1897 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 136:
#line 958 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "nand", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1907 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 137:
#line 964 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "xor", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1917 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 138:
#line 970 "aml_parser.ypp" // lalr1.cc:859
    {
  if (!yystack_[2].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[2].location, "expected an integer type expression"); YYERROR; }
  if (!yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) { error(yystack_[0].location, "expected an integer type expression"); YYERROR; }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::Logical(yystack_[2].value.as< SCAM::Expr* > (), "xnor", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1927 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;

  case 139:
#line 976 "aml_parser.ypp" // lalr1.cc:859
    {
  if (! yystack_[0].value.as< SCAM::Expr* > ()->isDataType("bool")) {
    error(yystack_[0].location, "expected a bool type expression");
    YYERROR;
  }
  yylhs.value.as< SCAM::Expr* > () = new SCAM::UnaryExpr("not", yystack_[0].value.as< SCAM::Expr* > ());
}
#line 1939 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
    break;


#line 1943 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:859
            default:
              break;
            }
        }
      catch (const syntax_error& yyexc)
        {
          error (yyexc);
          YYERROR;
        }
      YY_SYMBOL_PRINT ("-> $$ =", yylhs);
      yypop_ (yylen);
      yylen = 0;
      YY_STACK_PRINT ();

      // Shift the result of the reduction.
      yypush_ (YY_NULLPTR, yylhs);
    }
    goto yynewstate;

  /*--------------------------------------.
  | yyerrlab -- here on detecting error.  |
  `--------------------------------------*/
  yyerrlab:
    // If not already recovering from an error, report this error.
    if (!yyerrstatus_)
      {
        ++yynerrs_;
        error (yyla.location, yysyntax_error_ (yystack_[0].state, yyla));
      }


    yyerror_range[1].location = yyla.location;
    if (yyerrstatus_ == 3)
      {
        /* If just tried and failed to reuse lookahead token after an
           error, discard it.  */

        // Return failure if at end of input.
        if (yyla.type_get () == yyeof_)
          YYABORT;
        else if (!yyla.empty ())
          {
            yy_destroy_ ("Error: discarding", yyla);
            yyla.clear ();
          }
      }

    // Else will try to reuse lookahead token after shifting the error token.
    goto yyerrlab1;


  /*---------------------------------------------------.
  | yyerrorlab -- error raised explicitly by YYERROR.  |
  `---------------------------------------------------*/
  yyerrorlab:

    /* Pacify compilers like GCC when the user code never invokes
       YYERROR and the label yyerrorlab therefore never appears in user
       code.  */
    if (false)
      goto yyerrorlab;
    yyerror_range[1].location = yystack_[yylen - 1].location;
    /* Do not reclaim the symbols of the rule whose action triggered
       this YYERROR.  */
    yypop_ (yylen);
    yylen = 0;
    goto yyerrlab1;

  /*-------------------------------------------------------------.
  | yyerrlab1 -- common code for both syntax error and YYERROR.  |
  `-------------------------------------------------------------*/
  yyerrlab1:
    yyerrstatus_ = 3;   // Each real token shifted decrements this.
    {
      stack_symbol_type error_token;
      for (;;)
        {
          yyn = yypact_[yystack_[0].state];
          if (!yy_pact_value_is_default_ (yyn))
            {
              yyn += yyterror_;
              if (0 <= yyn && yyn <= yylast_ && yycheck_[yyn] == yyterror_)
                {
                  yyn = yytable_[yyn];
                  if (0 < yyn)
                    break;
                }
            }

          // Pop the current state because it cannot handle the error token.
          if (yystack_.size () == 1)
            YYABORT;

          yyerror_range[1].location = yystack_[0].location;
          yy_destroy_ ("Error: popping", yystack_[0]);
          yypop_ ();
          YY_STACK_PRINT ();
        }

      yyerror_range[2].location = yyla.location;
      YYLLOC_DEFAULT (error_token.location, yyerror_range, 2);

      // Shift the error token.
      error_token.state = yyn;
      yypush_ ("Shifting", error_token);
    }
    goto yynewstate;

    // Accept.
  yyacceptlab:
    yyresult = 0;
    goto yyreturn;

    // Abort.
  yyabortlab:
    yyresult = 1;
    goto yyreturn;

  yyreturn:
    if (!yyla.empty ())
      yy_destroy_ ("Cleanup: discarding lookahead", yyla);

    /* Do not reclaim the symbols of the rule whose action triggered
       this YYABORT or YYACCEPT.  */
    yypop_ (yylen);
    while (1 < yystack_.size ())
      {
        yy_destroy_ ("Cleanup: popping", yystack_[0]);
        yypop_ ();
      }

    return yyresult;
  }
    catch (...)
      {
        YYCDEBUG << "Exception caught: cleaning lookahead and stack"
                 << std::endl;
        // Do not try to display the values of the reclaimed symbols,
        // as their printer might throw an exception.
        if (!yyla.empty ())
          yy_destroy_ (YY_NULLPTR, yyla);

        while (1 < yystack_.size ())
          {
            yy_destroy_ (YY_NULLPTR, yystack_[0]);
            yypop_ ();
          }
        throw;
      }
  }

  void
  aml_parser::error (const syntax_error& yyexc)
  {
    error (yyexc.location, yyexc.what());
  }

  // Generate an error message.
  std::string
  aml_parser::yysyntax_error_ (state_type yystate, const symbol_type& yyla) const
  {
    // Number of reported tokens (one for the "unexpected", one per
    // "expected").
    size_t yycount = 0;
    // Its maximum.
    enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
    // Arguments of yyformat.
    char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];

    /* There are many possibilities here to consider:
       - If this state is a consistent state with a default action, then
         the only way this function was invoked is if the default action
         is an error action.  In that case, don't check for expected
         tokens because there are none.
       - The only way there can be no lookahead present (in yyla) is
         if this state is a consistent state with a default action.
         Thus, detecting the absence of a lookahead is sufficient to
         determine that there is no unexpected or expected token to
         report.  In that case, just report a simple "syntax error".
       - Don't assume there isn't a lookahead just because this state is
         a consistent state with a default action.  There might have
         been a previous inconsistent state, consistent state with a
         non-default action, or user semantic action that manipulated
         yyla.  (However, yyla is currently not documented for users.)
       - Of course, the expected token list depends on states to have
         correct lookahead information, and it depends on the parser not
         to perform extra reductions after fetching a lookahead from the
         scanner and before detecting a syntax error.  Thus, state
         merging (from LALR or IELR) and default reductions corrupt the
         expected token list.  However, the list is correct for
         canonical LR with one exception: it will still contain any
         token that will not be accepted due to an error action in a
         later state.
    */
    if (!yyla.empty ())
      {
        int yytoken = yyla.type_get ();
        yyarg[yycount++] = yytname_[yytoken];
        int yyn = yypact_[yystate];
        if (!yy_pact_value_is_default_ (yyn))
          {
            /* Start YYX at -YYN if negative to avoid negative indexes in
               YYCHECK.  In other words, skip the first -YYN actions for
               this state because they are default actions.  */
            int yyxbegin = yyn < 0 ? -yyn : 0;
            // Stay within bounds of both yycheck and yytname.
            int yychecklim = yylast_ - yyn + 1;
            int yyxend = yychecklim < yyntokens_ ? yychecklim : yyntokens_;
            for (int yyx = yyxbegin; yyx < yyxend; ++yyx)
              if (yycheck_[yyx + yyn] == yyx && yyx != yyterror_
                  && !yy_table_value_is_error_ (yytable_[yyx + yyn]))
                {
                  if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                    {
                      yycount = 1;
                      break;
                    }
                  else
                    yyarg[yycount++] = yytname_[yyx];
                }
          }
      }

    char const* yyformat = YY_NULLPTR;
    switch (yycount)
      {
#define YYCASE_(N, S)                         \
        case N:                               \
          yyformat = S;                       \
        break
        YYCASE_(0, YY_("syntax error"));
        YYCASE_(1, YY_("syntax error, unexpected %s"));
        YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
        YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
        YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
        YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
      }

    std::string yyres;
    // Argument number.
    size_t yyi = 0;
    for (char const* yyp = yyformat; *yyp; ++yyp)
      if (yyp[0] == '%' && yyp[1] == 's' && yyi < yycount)
        {
          yyres += yytnamerr_ (yyarg[yyi++]);
          ++yyp;
        }
      else
        yyres += *yyp;
    return yyres;
  }


  const short int aml_parser::yypact_ninf_ = -223;

  const signed char aml_parser::yytable_ninf_ = -75;

  const short int
  aml_parser::yypact_[] =
  {
     495,     4,     4,    14,    26,   -12,   107,    31,   495,  -223,
    -223,  -223,  -223,  -223,  -223,  -223,   141,    60,    82,    94,
      97,  -223,  -223,  -223,   157,    26,   108,  -223,  -223,  -223,
    -223,  -223,   156,   137,  -223,    92,   581,  -223,   126,   145,
     128,   144,   149,  -223,  -223,  -223,   132,  -223,  -223,  -223,
    -223,  -223,  -223,    88,  -223,   136,   150,   497,  -223,  -223,
    -223,   191,   133,   193,    26,   184,    26,  -223,  -223,     4,
       4,   179,  -223,   180,  -223,   -29,   182,   183,   186,   199,
     -24,   226,   195,  -223,   204,   209,   210,   211,   265,   228,
     229,   268,  -223,  -223,  -223,    26,   284,    26,  -223,   191,
       6,   111,   285,   324,   325,   326,    45,     1,  -223,  -223,
    -223,  -223,   -25,  -223,   327,    51,   328,    68,   352,    69,
    -223,  -223,   147,   147,   147,   147,   147,  -223,  -223,   339,
    -223,   315,   316,   318,   355,   357,  -223,  -223,   323,  -223,
    -223,   465,   503,   468,   204,   147,   508,   197,    79,   339,
    -223,  -223,  -223,   147,   147,   147,   147,   147,   147,   147,
     147,   147,   147,   147,   147,   147,   147,   147,   147,   147,
     147,   147,   147,   147,   147,  -223,  -223,  -223,   471,   139,
    -223,   207,   476,   548,   549,     5,  -223,  -223,  -223,   147,
     360,   380,   399,   417,   434,   467,   482,   496,   509,   520,
     520,   235,   235,   235,   235,    -5,    -5,   106,   106,  -223,
    -223,  -223,   588,  -223,   589,   205,   553,   564,   561,   595,
     595,   567,  -223,  -223,   207,  -223,   559,   560,   562,   563,
     565,   566,   568,   569,  -223,   207,  -223,  -223,  -223,   339,
     161,   570,   -26,   599,    10,    25,   147,   147,   571,  -223,
    -223,   138,  -223,  -223,  -223,  -223,  -223,  -223,  -223,  -223,
    -223,   207,  -223,   602,  -223,   573,   574,   572,   576,   580,
     582,   583,   584,  -223,   339,   227,    85,   147,  -223,  -223,
     339,   585,  -223,  -223,   595,   147,   595,   147,   595,   147,
     579,    98,    91,  -223,   586,   257,   587,   287,   590,   317,
     207,  -223,  -223,  -223,  -223,  -223,  -223,  -223,   152,   597,
     -18,  -223,   207,  -223,   198,  -223
  };

  const unsigned char
  aml_parser::yydefact_[] =
  {
       0,     0,     0,     0,     0,     0,     0,     0,     2,     3,
       5,     6,     7,     8,     9,    10,    55,    45,     0,     0,
       0,    69,    68,    67,     0,     0,     0,     1,     4,    56,
      57,    31,    55,     0,    34,     0,    55,    32,     0,     0,
       0,     0,     0,    35,    58,    59,     0,    49,    51,    50,
      54,    52,    53,     0,    47,     0,     0,    55,    20,    22,
      23,    61,     0,     0,    64,     0,     0,    46,    48,     0,
       0,     0,    21,     0,    62,     0,     0,     0,     0,     0,
       0,     0,     0,    41,    36,     0,     0,     0,     0,     0,
       0,     0,    15,    13,    14,    64,     0,     0,    65,    61,
       0,     0,     0,     0,     0,     0,     0,     0,    25,    19,
      11,    63,     0,    12,     0,     0,     0,     0,     0,   111,
     110,   109,     0,   105,     0,     0,     0,   114,   113,    37,
      39,     0,     0,     0,     0,     0,    24,    26,     0,    66,
      40,     0,     0,     0,    36,   105,     0,     0,     0,   106,
     120,   139,   126,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    60,    71,    70,     0,     0,
      17,     0,     0,     0,     0,     0,    75,   112,    38,     0,
     138,   137,   135,   136,   134,   133,   122,   123,   121,   127,
     128,   129,   131,   130,   132,   124,   125,   116,   115,   117,
     118,   119,     0,    28,     0,     0,    74,     0,     0,     0,
       0,     0,    72,    73,    43,    76,     0,     0,     0,     0,
       0,     0,     0,     0,    79,     0,    33,    42,   108,   107,
       0,     0,    69,     0,     0,     0,     0,     0,    74,    90,
      91,     0,    77,    78,    81,    83,    80,    82,    84,    85,
      86,    44,    29,     0,    30,     0,     0,     0,     0,     0,
       0,     0,     0,   100,    92,     0,   111,   105,    88,    89,
      87,     0,    18,    16,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    27,     0,     0,     0,     0,     0,     0,
       0,    93,    94,    96,    95,    97,    98,    99,     0,   102,
       0,   101,     0,   104,     0,   103
  };

  const short int
  aml_parser::yypgoto_[] =
  {
    -223,  -223,  -223,   614,  -223,  -223,  -223,  -223,  -223,  -223,
    -223,   575,  -223,  -223,   518,  -223,  -223,  -223,  -223,   484,
    -223,  -223,  -223,  -223,    28,  -223,   577,  -223,  -223,    -8,
     530,   536,    -4,  -223,  -182,  -223,   -96,  -212,  -222,  -223,
    -223,   382,  -223,   383,  -223,  -223,  -223,   329,  -223,  -144,
    -223,   -90
  };

  const short int
  aml_parser::yydefgoto_[] =
  {
      -1,     7,     8,     9,    10,    11,    12,    13,   215,    14,
      57,    58,    73,   107,   108,    15,    16,    31,    32,   102,
      83,    84,   100,   117,    18,    53,    54,    33,    46,    59,
      75,    80,    81,    60,   221,   222,   127,   224,   225,   226,
     227,   228,   229,   230,   231,   232,   233,   234,   311,   148,
     128,   149
  };

  const short int
  aml_parser::yytable_[] =
  {
      24,   185,   252,   244,   106,   218,   -74,    17,    34,    21,
      90,   129,   138,   216,    91,    96,   245,    20,    97,    97,
     312,    40,   252,   261,    43,   217,    22,    23,   186,    21,
      19,    27,   147,   218,   150,   151,   152,   249,   250,   252,
     136,   116,   238,   219,   220,    25,    22,    23,   189,   266,
     267,   268,   269,   270,   271,   272,   273,   170,   171,   172,
     173,   174,    85,   190,   191,   192,   193,   194,   195,   196,
     197,   198,   199,   200,   201,   202,   203,   204,   205,   206,
     207,   208,   209,   210,   211,   223,   252,   134,   308,   135,
     140,    47,   252,   114,    91,    47,   118,    86,    87,   239,
     314,   186,   294,   142,   296,   145,   298,   143,    48,    49,
      26,   146,    48,    49,   119,   120,   121,    35,   188,   223,
      36,   145,   189,   223,   223,   269,   270,   291,   223,    38,
     301,    50,    37,   292,   189,    50,    76,    77,    78,   223,
      41,   276,   120,   121,    67,    44,    45,   122,   223,   123,
     119,   120,   121,    29,    30,   216,   274,   275,    51,    52,
      39,   280,    51,    52,    61,   223,    42,   217,    29,    30,
     172,   173,   174,   124,   122,   218,   277,    62,   125,   126,
     213,   214,    64,   122,    63,   219,   220,    65,   223,    66,
     223,   309,   223,    69,    74,   295,    79,   297,    82,   299,
     124,   216,   262,   263,   223,   125,   126,    70,   242,   124,
     216,   243,   223,   217,   125,   126,   223,    88,   223,    89,
     217,   218,   217,    92,    93,    22,    23,    94,   218,    98,
     218,   219,   220,    99,   187,    95,   101,   315,   219,   220,
     219,   220,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   290,   103,   104,   105,   106,   109,
     110,   111,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   303,   168,   169,   170,   171,   172,
     173,   174,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   305,   113,   130,   131,   132,   133,
     139,   141,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   307,   144,   175,   176,   178,   177,
     179,   180,   153,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   153,   154,   155,   156,   157,   158,
     159,   160,   161,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   154,   155,   156,   157,
     158,   159,   160,   161,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,   155,   156,   157,
     158,   159,   160,   161,   162,   163,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,   156,   157,   158,
     159,   160,   161,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   157,   158,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   158,   159,   160,   161,   162,   163,
     164,   165,   166,   167,   168,   169,   170,   171,   172,   173,
     174,     1,     2,    55,    56,   181,   182,   183,    71,    29,
      30,   186,     3,     4,     5,   212,   235,     6,   159,   160,
     161,   162,   163,   164,   165,   166,   167,   168,   169,   170,
     171,   172,   173,   174,   160,   161,   162,   163,   164,   165,
     166,   167,   168,   169,   170,   171,   172,   173,   174,   161,
     162,   163,   164,   165,   166,   167,   168,   169,   170,   171,
     172,   173,   174,   162,   163,   164,   165,   166,   167,   168,
     169,   170,   171,   172,   173,   174,   164,   165,   166,   167,
     168,   169,   170,   171,   172,   173,   174,    55,    56,   236,
     237,   240,   241,    29,    30,   245,   246,   247,   248,   251,
     253,   254,   265,   255,   256,   281,   257,   258,   284,   259,
     260,   264,   285,   146,   282,   283,   286,   300,   287,   288,
     289,   310,    28,   302,   304,   137,   293,   306,   184,   115,
      68,   112,    72,   278,   279,     0,     0,     0,     0,   313
  };

  const short int
  aml_parser::yycheck_[] =
  {
       4,   145,   224,   215,     3,    23,    32,     3,    16,     3,
      39,   101,    37,     3,    43,    39,    42,     3,    43,    43,
      38,    25,   244,   235,    32,    15,    20,    21,     3,     3,
       2,     0,   122,    23,   124,   125,   126,   219,   220,   261,
      39,    35,    37,    33,    34,    57,    20,    21,    43,    39,
      25,    26,    27,    28,    29,    30,    31,    62,    63,    64,
      65,    66,    66,   153,   154,   155,   156,   157,   158,   159,
     160,   161,   162,   163,   164,   165,   166,   167,   168,   169,
     170,   171,   172,   173,   174,   181,   308,    42,   300,    44,
      39,     3,   314,    97,    43,     3,   100,    69,    70,   189,
     312,     3,   284,    35,   286,    36,   288,    39,    20,    21,
       3,    42,    20,    21,     3,     4,     5,    57,    39,   215,
      38,    36,    43,   219,   220,    27,    28,    42,   224,    32,
      39,    43,    38,   277,    43,    43,     3,     4,     5,   235,
      32,     3,     4,     5,    56,     8,     9,    36,   244,    38,
       3,     4,     5,    12,    13,     3,   246,   247,    70,    71,
       3,   251,    70,    71,    38,   261,    10,    15,    12,    13,
      64,    65,    66,    62,    36,    23,    38,    32,    67,    68,
      41,    42,    38,    36,    56,    33,    34,    38,   284,    57,
     286,    39,   288,    57,     3,   285,     3,   287,    14,   289,
      62,     3,    41,    42,   300,    67,    68,    57,     3,    62,
       3,   215,   308,    15,    67,    68,   312,    38,   314,    39,
      15,    23,    15,    41,    41,    20,    21,    41,    23,     3,
      23,    33,    34,    38,    37,    36,    32,    39,    33,    34,
      33,    34,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    37,    56,    56,    56,     3,    41,
      41,     3,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    37,    60,    61,    62,    63,    64,
      65,    66,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    37,    41,    41,     3,     3,     3,
       3,     3,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    37,     3,    41,    41,     3,    41,
       3,    38,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,    61,    62,    63,    64,    65,
      66,     6,     7,     6,     7,    40,     3,    39,    11,    12,
      13,     3,    17,    18,    19,    44,    40,    22,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    65,    66,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    54,    55,    56,    57,    58,    59,    60,
      61,    62,    63,    64,    65,    66,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    66,     6,     7,    41,
      41,     3,     3,    12,    13,    42,    32,    36,     3,    32,
      41,    41,     3,    41,    41,     3,    41,    41,    36,    41,
      41,    41,    36,    42,    41,    41,    36,    38,    36,    36,
      36,    24,     8,    37,    37,   107,    41,    37,   144,    99,
      53,    95,    57,   251,   251,    -1,    -1,    -1,    -1,   310
  };

  const unsigned char
  aml_parser::yystos_[] =
  {
       0,     6,     7,    17,    18,    19,    22,    73,    74,    75,
      76,    77,    78,    79,    81,    87,    88,     3,    96,    96,
       3,     3,    20,    21,   104,    57,     3,     0,    75,    12,
      13,    89,    90,    99,   101,    57,    38,    38,    32,     3,
     104,    32,    10,   101,     8,     9,   100,     3,    20,    21,
      43,    70,    71,    97,    98,     6,     7,    82,    83,   101,
     105,    38,    32,    56,    38,    38,    57,    56,    98,    57,
      57,    11,    83,    84,     3,   102,     3,     4,     5,     3,
     103,   104,    14,    92,    93,   104,    96,    96,    38,    39,
      39,    43,    41,    41,    41,    36,    39,    43,     3,    38,
      94,    32,    91,    56,    56,    56,     3,    85,    86,    41,
      41,     3,   103,    41,   104,   102,    35,    95,   104,     3,
       4,     5,    36,    38,    62,    67,    68,   108,   122,   123,
      41,     3,     3,     3,    42,    44,    39,    86,    37,     3,
      39,     3,    35,    39,     3,    36,    42,   123,   121,   123,
     123,   123,   123,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    61,
      62,    63,    64,    65,    66,    41,    41,    41,     3,     3,
      38,    40,     3,    39,    91,   121,     3,    37,    39,    43,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123,
     123,   123,    44,    41,    42,    80,     3,    15,    23,    33,
      34,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,    40,    41,    41,    37,   123,
       3,     3,     3,   104,   109,    42,    32,    36,     3,   106,
     106,    32,   110,    41,    41,    41,    41,    41,    41,    41,
      41,   109,    41,    42,    41,     3,    39,    25,    26,    27,
      28,    29,    30,    31,   123,   123,     3,    38,   113,   115,
     123,     3,    41,    41,    36,    36,    36,    36,    36,    36,
      37,    42,   121,    41,   106,   123,   106,   123,   106,   123,
      38,    39,    37,    37,    37,    37,    37,    37,   109,    39,
      24,   120,    38,   119,   109,    39
  };

  const unsigned char
  aml_parser::yyr1_[] =
  {
       0,    72,    73,    74,    74,    75,    75,    75,    75,    75,
      75,    76,    77,    78,    78,    78,    79,    80,    80,    81,
      82,    82,    83,    83,    84,    85,    85,    86,    86,    86,
      86,    87,    88,    89,    90,    90,    91,    91,    91,    92,
      93,    94,    94,    95,    95,    96,    96,    97,    97,    98,
      98,    98,    98,    98,    98,    99,    99,    99,   100,   100,
     101,   102,   102,   102,   103,   103,   103,   104,   104,   104,
     105,   105,   106,   106,   107,   108,   109,   109,   110,   110,
     110,   110,   110,   110,   110,   110,   110,   111,   111,   111,
     111,   111,   111,   111,   112,   113,   114,   115,   116,   117,
     118,   119,   120,   120,   120,   121,   121,   121,   122,   123,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123
  };

  const unsigned char
  aml_parser::yyr2_[] =
  {
       0,     2,     1,     1,     2,     1,     1,     1,     1,     1,
       1,     7,     7,     6,     6,     6,    13,     0,     4,     7,
       1,     2,     1,     1,     4,     1,     2,     8,     4,     6,
       6,     2,     3,     9,     1,     2,     0,     2,     4,     3,
       4,     0,     5,     4,     5,     1,     4,     1,     2,     1,
       1,     1,     1,     1,     1,     0,     1,     1,     1,     1,
       7,     0,     1,     3,     0,     2,     4,     1,     1,     1,
       6,     6,     1,     1,     1,     3,     1,     2,     2,     1,
       2,     2,     2,     2,     2,     2,     2,     3,     3,     3,
       2,     2,     3,     5,     6,     6,     6,     6,     6,     6,
       3,     8,     0,     4,     2,     0,     1,     3,     4,     1,
       1,     1,     3,     1,     1,     3,     3,     3,     3,     3,
       2,     3,     3,     3,     3,     3,     2,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     2
  };



  // YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
  // First, the terminals, then, starting at \a yyntokens_, nonterminals.
  const char*
  const aml_parser::yytname_[] =
  {
  "\"end of file\"", "error", "$undefined", "\"identifier\"",
  "\"number\"", "\"boolean value\"", "\"system\"", "\"module\"", "\"in\"",
  "\"out\"", "\"fsm\"", "\"connect\"", "\"blocking\"", "\"shared\"",
  "\"sections\"", "\"nextsection\"", "\"init\"", "\"enum\"", "\"const\"",
  "\"func\"", "\"bool\"", "\"int\"", "\"compound\"", "\"if\"", "\"else\"",
  "\"read\"", "\"write\"", "\"nb_read\"", "\"nb_write\"", "\"get\"",
  "\"set\"", "\"req\"", "\"=\"", "\"++\"", "\"--\"", "\"@\"", "\"(\"",
  "\")\"", "\"{\"", "\"}\"", "\":\"", "\";\"", "\".\"", "\",\"", "\"->\"",
  "\"xnor\"", "\"xor\"", "\"nor\"", "\"nand\"", "\"or\"", "\"and\"",
  "\"bitor\"", "\"bitxor\"", "\"bitand\"", "\"==\"", "\"!=\"", "\">\"",
  "\"<\"", "\">=\"", "\"<=\"", "\"<<\"", "\">>\"", "\"-\"", "\"+\"",
  "\"*\"", "\"/\"", "\"%\"", "\"not\"", "\"bitnot\"", "UMIN", "\"[\"",
  "\"]\"", "$accept", "themodel", "all_elements", "top_element",
  "enum_def", "compound_def", "const_def", "func_def", "func_vars",
  "system_def", "system_ports", "system_port", "connect_decl",
  "connections", "connection", "module_def", "module_header",
  "module_body", "module_ports", "opt_init", "section_var",
  "section_var_decl", "module_vars", "sections", "name_header",
  "name_header_list", "name_header_el", "blocking_key", "direction_key",
  "port_decl", "name_list_comma", "var_list_comma", "datatype",
  "submod_decl", "var_ref", "var_ref_parent", "var_ref_child",
  "statements", "statement", "assign_statement", "read_statement",
  "nb_read_statement", "write_statement", "nb_write_statement",
  "get_statement", "set_statement", "req_statement", "if_statement",
  "opt_else", "expr_list_comma", "func_ref", "expr", YY_NULLPTR
  };

#if YYDEBUG
  const unsigned short int
  aml_parser::yyrline_[] =
  {
       0,   207,   207,   211,   212,   215,   216,   217,   218,   219,
     220,   224,   243,   265,   266,   267,   269,   271,   272,   275,
     277,   278,   280,   281,   283,   285,   286,   288,   290,   292,
     294,   302,   305,   314,   329,   333,   344,   345,   346,   351,
     372,   390,   391,   456,   457,   465,   466,   468,   469,   471,
     472,   473,   474,   475,   476,   482,   483,   484,   486,   487,
     490,   497,   498,   499,   510,   511,   512,   525,   526,   527,
     537,   538,   542,   543,   547,   558,   575,   576,   580,   581,
     582,   583,   584,   585,   586,   587,   588,   592,   597,   602,
     607,   611,   616,   624,   652,   672,   692,   712,   733,   754,
     776,   794,   810,   811,   812,   817,   818,   819,   821,   826,
     827,   828,   846,   847,   848,   853,   859,   865,   871,   877,
     883,   889,   890,   891,   892,   893,   894,   896,   904,   913,
     919,   925,   931,   939,   945,   951,   957,   963,   969,   975
  };

  // Print the state stack on the debug stream.
  void
  aml_parser::yystack_print_ ()
  {
    *yycdebug_ << "Stack now";
    for (stack_type::const_iterator
           i = yystack_.begin (),
           i_end = yystack_.end ();
         i != i_end; ++i)
      *yycdebug_ << ' ' << i->state;
    *yycdebug_ << std::endl;
  }

  // Report on the debug stream that the rule \a yyrule is going to be reduced.
  void
  aml_parser::yy_reduce_print_ (int yyrule)
  {
    unsigned int yylno = yyrline_[yyrule];
    int yynrhs = yyr2_[yyrule];
    // Print the symbols being reduced, and their result.
    *yycdebug_ << "Reducing stack by rule " << yyrule - 1
               << " (line " << yylno << "):" << std::endl;
    // The symbols being reduced.
    for (int yyi = 0; yyi < yynrhs; yyi++)
      YY_SYMBOL_PRINT ("   $" << yyi + 1 << " =",
                       yystack_[(yynrhs) - (yyi + 1)]);
  }
#endif // YYDEBUG



} // yy
#line 2597 "/home/nawras/SCAM/src/parserAML/aml_parser.cpp" // lalr1.cc:1167
#line 984 "aml_parser.ypp" // lalr1.cc:1168





void yy::aml_parser::error(const yy::aml_parser::location_type& l, const std::string& m)
{
  driver.error(l, m);
}

