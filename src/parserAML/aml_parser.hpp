// A Bison parser, made by GNU Bison 3.0.4.

// Skeleton interface for Bison LALR(1) parsers in C++

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

/**
 ** \file /home/nawras/SCAM/src/ParseAML/aml_parser.hpp
 ** Define the yy::parser class.
 */

// C++ LALR(1) parser skeleton written by Akim Demaille.

#ifndef YY_YY_HOME_NAWRAS_SCAM_SRC_PARSEAML_AML_PARSER_HPP_INCLUDED
# define YY_YY_HOME_NAWRAS_SCAM_SRC_PARSEAML_AML_PARSER_HPP_INCLUDED
// //                    "%code requires" blocks.
#line 10 "aml_parser.ypp" // lalr1.cc:377

#include <string>
#include <map>
#include <vector>

class aml_driver;

#include "Model.h"
#include "IntegerValue.h"
#include "VariableOperand.h"
#include "Assignment.h"
#include "UnaryExpr.h"
#include "Relational.h"
#include "Logical.h"
#include "If.h"
#include "SectionOperand.h"
#include "BoolValue.h"
#include "SectionValue.h"
#include "ITE.h"
#include "Branch.h"
#include "Arithmetic.h"
#include "EnumValue.h"
#include "Read.h"
#include "Write.h"
#include "NBRead.h"
#include "NBWrite.h"

#line 70 "/home/nawras/SCAM/src/parserAML/aml_parser.hpp" // lalr1.cc:377

# include <cassert>
# include <cstdlib> // std::abort
# include <iostream>
# include <stdexcept>
# include <string>
# include <vector>
# include "stack.hh"
# include "location.hh"
#include <typeinfo>

#ifndef YYASSERT

# include <cassert>

# define YYASSERT assert
#endif


#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
 || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if !defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
                                                                                                                        # define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif


namespace yy {
#line 147 "/home/nawras/SCAM/src/parserAML/aml_parser.hpp" // lalr1.cc:377


    /// A char[S] buffer to store and retrieve objects.
    ///
    /// Sort of a variant, but does not keep track of the nature
    /// of the stored data, since that knowledge is available
    /// via the current state.
    template<size_t S>
    struct variant {
        /// Type of *this.
        typedef variant<S> self_type;

        /// Empty construction.
        variant()
                : yytypeid_(YY_NULLPTR) {}

        /// Construct and fill.
        template<typename T>
        variant(const T &t)
                : yytypeid_(&typeid(T)) {
                    YYASSERT (sizeof(T) <= S);
            new(yyas_<T>()) T(t);
        }

        /// Destruction, allowed only if empty.
        ~variant() {
                    YYASSERT (!yytypeid_);
        }

        /// Instantiate an empty \a T in here.
        template<typename T>
        T &
        build() {
                    YYASSERT (!yytypeid_);
                    YYASSERT (sizeof(T) <= S);
            yytypeid_ = &typeid(T);
            return *new(yyas_<T>()) T;
        }

        /// Instantiate a \a T in here from \a t.
        template<typename T>
        T &
        build(const T &t) {
                    YYASSERT (!yytypeid_);
                    YYASSERT (sizeof(T) <= S);
            yytypeid_ = &typeid(T);
            return *new(yyas_<T>()) T(t);
        }

        /// Accessor to a built \a T.
        template<typename T>
        T &
        as() {
                    YYASSERT (*yytypeid_ == typeid(T));
                    YYASSERT (sizeof(T) <= S);
            return *yyas_<T>();
        }

        /// Const accessor to a built \a T (for %printer).
        template<typename T>
        const T &
        as() const {
                    YYASSERT (*yytypeid_ == typeid(T));
                    YYASSERT (sizeof(T) <= S);
            return *yyas_<T>();
        }

        /// Swap the content with \a other, of same type.
        ///
        /// Both variants must be built beforehand, because swapping the actual
        /// data requires reading it (with as()), and this is not possible on
        /// unconstructed variants: it would require some dynamic testing, which
        /// should not be the variant's responsability.
        /// Swapping between built and (possibly) non-built is done with
        /// variant::move ().
        template<typename T>
        void
        swap(self_type &other) {
                    YYASSERT (yytypeid_);
                    YYASSERT (*yytypeid_ == *other.yytypeid_);
            std::swap(as<T>(), other.as<T>());
        }

        /// Move the content of \a other to this.
        ///
        /// Destroys \a other.
        template<typename T>
        void
        move(self_type &other) {
            build<T>();
            swap<T>(other);
            other.destroy<T>();
        }

        /// Copy the content of \a other to this.
        template<typename T>
        void
        copy(const self_type &other) {
            build<T>(other.as<T>());
        }

        /// Destroy the stored \a T.
        template<typename T>
        void
        destroy() {
            as<T>().~T();
            yytypeid_ = YY_NULLPTR;
        }

    private:
        /// Prohibit blind copies.
        self_type &operator=(const self_type &);

        variant(const self_type &);

        /// Accessor to raw memory as \a T.
        template<typename T>
        T *
        yyas_() {
            void *yyp = yybuffer_.yyraw;
            return static_cast<T *> (yyp);
        }

        /// Const accessor to raw memory as \a T.
        template<typename T>
        const T *
        yyas_() const {
            const void *yyp = yybuffer_.yyraw;
            return static_cast<const T *> (yyp);
        }

        union {
            /// Strongest alignment constraints.
            long double yyalign_me;
            /// A buffer large enough to store any of the semantic values.
            char yyraw[S];
        } yybuffer_;

        /// Whether the content is built: if defined, the name of the stored type.
        const std::type_info *yytypeid_;
    };


    /// A Bison parser.
    class aml_parser {
    public:
#ifndef YYSTYPE
        /// An auxiliary type to compute the largest semantic type.
        union union_type {
            // sections
            char dummy1[sizeof(std::map<std::string, std::vector<DESCAM::Stmt *>>)];

            // statements
            // statement
            // assign_statement
            // opt_else
            char dummy2[sizeof(std::vector<DESCAM::Stmt *>)];

            // datatype
            char dummy3[sizeof(DESCAM::DataType *)];

            // expr
            char dummy4[sizeof(DESCAM::Expr *)];

            // if_statement
            char dummy5[sizeof(DESCAM::ITE *)];

            // nb_read_statement
            // get_statement
            char dummy6[sizeof(DESCAM::NBRead *)];

            // nb_write_statement
            // set_statement
            char dummy7[sizeof(DESCAM::NBWrite *)];

            // port_decl
            char dummy8[sizeof(DESCAM::Port *)];

            // read_statement
            // req_statement
            char dummy9[sizeof(DESCAM::Read *)];

            // var_ref
            // var_ref_parent
            // var_ref_child
            char dummy10[sizeof(DESCAM::VariableOperand *)];

            // write_statement
            char dummy11[sizeof(DESCAM::Write *)];

            // "boolean value"
            char dummy12[sizeof(bool)];

            // "number"
            char dummy13[sizeof(int)];

            // var_list_comma
            char dummy14[sizeof(std::map<std::string, DESCAM::Variable *>)];

            // "identifier"
            // name_header
            // name_header_list
            // name_header_el
            // blocking_key
            // direction_key
            char dummy15[sizeof(std::string)];

            // opt_init
            // expr_list_comma
            char dummy16[sizeof(std::vector<DESCAM::Expr *>)];

            // name_list_comma
            char dummy17[sizeof(std::vector<std::string>)];
        };

        /// Symbol semantic values.
        typedef variant<sizeof(union_type)> semantic_type;
#else
        typedef YYSTYPE semantic_type;
#endif
        /// Symbol locations.
        typedef location location_type;

        /// Syntax errors thrown from user actions.
        struct syntax_error : std::runtime_error {
            syntax_error(const location_type &l, const std::string &m);

            location_type location;
        };

        /// Tokens.
        struct token {
            enum yytokentype {
                TOK_END = 0,
                TOK_NAME = 258,
                TOK_NUM = 259,
                TOK_BOOLVAL = 260,
                TOK_SYSTEM = 261,
                TOK_MODULE = 262,
                TOK_IN = 263,
                TOK_OUT = 264,
                TOK_FSM = 265,
                TOK_CONNECT = 266,
                TOK_BLOCKING = 267,
                TOK_SHARED = 268,
                TOK_SECTIONS = 269,
                TOK_NEXTSECTION = 270,
                TOK_INIT = 271,
                TOK_ENUM = 272,
                TOK_CONST = 273,
                TOK_FUNC = 274,
                TOK_BOOL = 275,
                TOK_INT = 276,
                TOK_COMPOUND = 277,
                TOK_IF = 278,
                TOK_ELSE = 279,
                TOK_READ = 280,
                TOK_WRITE = 281,
                TOK_NBREAD = 282,
                TOK_NBWRITE = 283,
                TOK_GET = 284,
                TOK_SET = 285,
                TOK_REQ = 286,
                TOK_ASSIGNMENT = 287,
                TOK_INCREMENT = 288,
                TOK_DECREMENT = 289,
                TOK_AT = 290,
                TOK_LPAREN = 291,
                TOK_RPAREN = 292,
                TOK_LCURLY = 293,
                TOK_RCURLY = 294,
                TOK_COLON = 295,
                TOK_SEMICOLON = 296,
                TOK_PUNKT = 297,
                TOK_COMMA = 298,
                TOK_ARROW = 299,
                TOK_XNOR = 300,
                TOK_XOR = 301,
                TOK_NOR = 302,
                TOK_NAND = 303,
                TOK_OR = 304,
                TOK_AND = 305,
                TOK_BITOR = 306,
                TOK_BITXOR = 307,
                TOK_BITAND = 308,
                TOK_EQ = 309,
                TOK_NEQ = 310,
                TOK_MORE = 311,
                TOK_LESS = 312,
                TOK_MOREEQ = 313,
                TOK_LESSEQ = 314,
                TOK_SHIFTL = 315,
                TOK_SHIFTR = 316,
                TOK_MINUS = 317,
                TOK_PLUS = 318,
                TOK_MULTIPLY = 319,
                TOK_DIVIDE = 320,
                TOK_REMAINDER = 321,
                TOK_NOT = 322,
                TOK_BITNOT = 323,
                TOK_UMIN = 324
            };
        };

        /// (External) token type, as returned by yylex.
        typedef token::yytokentype token_type;

        /// Symbol type: an internal symbol number.
        typedef int symbol_number_type;

        /// The symbol type number to denote an empty symbol.
        enum {
            empty_symbol = -2
        };

        /// Internal symbol number for tokens (subsumed by symbol_number_type).
        typedef unsigned char token_number_type;

        /// A complete symbol.
        ///
        /// Expects its Base type to provide access to the symbol type
        /// via type_get().
        ///
        /// Provide access to semantic value and location.
        template<typename Base>
        struct basic_symbol : Base {
            /// Alias to Base.
            typedef Base super_type;

            /// Default constructor.
            basic_symbol();

            /// Copy constructor.
            basic_symbol(const basic_symbol &other);

            /// Constructor for valueless symbols, and symbols from each type.

            basic_symbol(typename Base::kind_type t, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::map<std::string, std::vector<DESCAM::Stmt *>> v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::vector<DESCAM::Stmt *> v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::DataType *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::Expr *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::ITE *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::NBRead *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::NBWrite *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::Port *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::Read *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::VariableOperand *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const DESCAM::Write *v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const bool v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const int v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::map<std::string, DESCAM::Variable *> v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::string v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::vector<DESCAM::Expr *> v, const location_type &l);

            basic_symbol(typename Base::kind_type t, const std::vector<std::string> v, const location_type &l);


            /// Constructor for symbols with semantic value.
            basic_symbol(typename Base::kind_type t,
                         const semantic_type &v,
                         const location_type &l);

            /// Destroy the symbol.
            ~basic_symbol();

            /// Destroy contents, and record that is empty.
            void clear();

            /// Whether empty.
            bool empty() const;

            /// Destructive move, \a s is emptied into this.
            void move(basic_symbol &s);

            /// The semantic value.
            semantic_type value;

            /// The location.
            location_type location;

        private:
            /// Assignment operator.
            basic_symbol &operator=(const basic_symbol &other);
        };

        /// Type access provider for token (enum) based symbols.
        struct by_type {
            /// Default constructor.
            by_type();

            /// Copy constructor.
            by_type(const by_type &other);

            /// The symbol type as needed by the constructor.
            typedef token_type kind_type;

            /// Constructor from (external) token numbers.
            by_type(kind_type t);

            /// Record that this symbol is empty.
            void clear();

            /// Steal the symbol type from \a that.
            void move(by_type &that);

            /// The (internal) type number (corresponding to \a type).
            /// \a empty when empty.
            symbol_number_type type_get() const;

            /// The token.
            token_type token() const;

            /// The symbol type.
            /// \a empty_symbol when empty.
            /// An int, not token_number_type, to be able to store empty_symbol.
            int type;
        };

        /// "External" symbols: returned by the scanner.
        typedef basic_symbol<by_type> symbol_type;

        // Symbol constructors declarations.
        static inline
        symbol_type
        make_END(const location_type &l);

        static inline
        symbol_type
        make_NAME(const std::string &v, const location_type &l);

        static inline
        symbol_type
        make_NUM(const int &v, const location_type &l);

        static inline
        symbol_type
        make_BOOLVAL(const bool &v, const location_type &l);

        static inline
        symbol_type
        make_SYSTEM(const location_type &l);

        static inline
        symbol_type
        make_MODULE(const location_type &l);

        static inline
        symbol_type
        make_IN(const location_type &l);

        static inline
        symbol_type
        make_OUT(const location_type &l);

        static inline
        symbol_type
        make_FSM(const location_type &l);

        static inline
        symbol_type
        make_CONNECT(const location_type &l);

        static inline
        symbol_type
        make_BLOCKING(const location_type &l);

        static inline
        symbol_type
        make_SHARED(const location_type &l);

        static inline
        symbol_type
        make_SECTIONS(const location_type &l);

        static inline
        symbol_type
        make_NEXTSECTION(const location_type &l);

        static inline
        symbol_type
        make_INIT(const location_type &l);

        static inline
        symbol_type
        make_ENUM(const location_type &l);

        static inline
        symbol_type
        make_CONST(const location_type &l);

        static inline
        symbol_type
        make_FUNC(const location_type &l);

        static inline
        symbol_type
        make_BOOL(const location_type &l);

        static inline
        symbol_type
        make_INT(const location_type &l);

        static inline
        symbol_type
        make_COMPOUND(const location_type &l);

        static inline
        symbol_type
        make_IF(const location_type &l);

        static inline
        symbol_type
        make_ELSE(const location_type &l);

        static inline
        symbol_type
        make_READ(const location_type &l);

        static inline
        symbol_type
        make_WRITE(const location_type &l);

        static inline
        symbol_type
        make_NBREAD(const location_type &l);

        static inline
        symbol_type
        make_NBWRITE(const location_type &l);

        static inline
        symbol_type
        make_GET(const location_type &l);

        static inline
        symbol_type
        make_SET(const location_type &l);

        static inline
        symbol_type
        make_REQ(const location_type &l);

        static inline
        symbol_type
        make_ASSIGNMENT(const location_type &l);

        static inline
        symbol_type
        make_INCREMENT(const location_type &l);

        static inline
        symbol_type
        make_DECREMENT(const location_type &l);

        static inline
        symbol_type
        make_AT(const location_type &l);

        static inline
        symbol_type
        make_LPAREN(const location_type &l);

        static inline
        symbol_type
        make_RPAREN(const location_type &l);

        static inline
        symbol_type
        make_LCURLY(const location_type &l);

        static inline
        symbol_type
        make_RCURLY(const location_type &l);

        static inline
        symbol_type
        make_COLON(const location_type &l);

        static inline
        symbol_type
        make_SEMICOLON(const location_type &l);

        static inline
        symbol_type
        make_PUNKT(const location_type &l);

        static inline
        symbol_type
        make_COMMA(const location_type &l);

        static inline
        symbol_type
        make_ARROW(const location_type &l);

        static inline
        symbol_type
        make_XNOR(const location_type &l);

        static inline
        symbol_type
        make_XOR(const location_type &l);

        static inline
        symbol_type
        make_NOR(const location_type &l);

        static inline
        symbol_type
        make_NAND(const location_type &l);

        static inline
        symbol_type
        make_OR(const location_type &l);

        static inline
        symbol_type
        make_AND(const location_type &l);

        static inline
        symbol_type
        make_BITOR(const location_type &l);

        static inline
        symbol_type
        make_BITXOR(const location_type &l);

        static inline
        symbol_type
        make_BITAND(const location_type &l);

        static inline
        symbol_type
        make_EQ(const location_type &l);

        static inline
        symbol_type
        make_NEQ(const location_type &l);

        static inline
        symbol_type
        make_MORE(const location_type &l);

        static inline
        symbol_type
        make_LESS(const location_type &l);

        static inline
        symbol_type
        make_MOREEQ(const location_type &l);

        static inline
        symbol_type
        make_LESSEQ(const location_type &l);

        static inline
        symbol_type
        make_SHIFTL(const location_type &l);

        static inline
        symbol_type
        make_SHIFTR(const location_type &l);

        static inline
        symbol_type
        make_MINUS(const location_type &l);

        static inline
        symbol_type
        make_PLUS(const location_type &l);

        static inline
        symbol_type
        make_MULTIPLY(const location_type &l);

        static inline
        symbol_type
        make_DIVIDE(const location_type &l);

        static inline
        symbol_type
        make_REMAINDER(const location_type &l);

        static inline
        symbol_type
        make_NOT(const location_type &l);

        static inline
        symbol_type
        make_BITNOT(const location_type &l);

        static inline
        symbol_type
        make_UMIN(const location_type &l);


        /// Build a parser object.
        aml_parser(aml_driver &driver_yyarg);

        virtual ~aml_parser();

        /// Parse.
        /// \returns  0 iff parsing succeeded.
        virtual int parse();

#if YYDEBUG

        /// The current debugging stream.
        std::ostream &debug_stream() const YY_ATTRIBUTE_PURE;

        /// Set the current debugging stream.
        void set_debug_stream(std::ostream &);

        /// Type for debugging levels.
        typedef int debug_level_type;

        /// The current debugging level.
        debug_level_type debug_level() const YY_ATTRIBUTE_PURE;

        /// Set the current debugging level.
        void set_debug_level(debug_level_type l);

#endif

        /// Report a syntax error.
        /// \param loc    where the syntax error is found.
        /// \param msg    a description of the syntax error.
        virtual void error(const location_type &loc, const std::string &msg);

        /// Report a syntax error.
        void error(const syntax_error &err);

    private:
        /// This class is not copyable.
        aml_parser(const aml_parser &);

        aml_parser &operator=(const aml_parser &);

        /// State numbers.
        typedef int state_type;

        /// Generate an error message.
        /// \param yystate   the state where the error occurred.
        /// \param yyla      the lookahead token.
        virtual std::string yysyntax_error_(state_type yystate,
                                            const symbol_type &yyla) const;

        /// Compute post-reduction state.
        /// \param yystate   the current state
        /// \param yysym     the nonterminal to push on the stack
        state_type yy_lr_goto_state_(state_type yystate, int yysym);

        /// Whether the given \c yypact_ value indicates a defaulted state.
        /// \param yyvalue   the value to check
        static bool yy_pact_value_is_default_(int yyvalue);

        /// Whether the given \c yytable_ value indicates a syntax error.
        /// \param yyvalue   the value to check
        static bool yy_table_value_is_error_(int yyvalue);

        static const short int yypact_ninf_;
        static const signed char yytable_ninf_;

        /// Convert a scanner token number \a t to a symbol number.
        static token_number_type yytranslate_(token_type t);

        // Tables.
        // YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
        // STATE-NUM.
        static const short int yypact_[];

        // YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
        // Performed when YYTABLE does not specify something else to do.  Zero
        // means the default is an error.
        static const unsigned char yydefact_[];

        // YYPGOTO[NTERM-NUM].
        static const short int yypgoto_[];

        // YYDEFGOTO[NTERM-NUM].
        static const short int yydefgoto_[];

        // YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
        // positive, shift that token.  If negative, reduce the rule whose
        // number is the opposite.  If YYTABLE_NINF, syntax error.
        static const short int yytable_[];

        static const short int yycheck_[];

        // YYSTOS[STATE-NUM] -- The (internal number of the) accessing
        // symbol of state STATE-NUM.
        static const unsigned char yystos_[];

        // YYR1[YYN] -- Symbol number of symbol that rule YYN derives.
        static const unsigned char yyr1_[];

        // YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.
        static const unsigned char yyr2_[];


        /// Convert the symbol name \a n to a form suitable for a diagnostic.
        static std::string yytnamerr_(const char *n);


        /// For a symbol, its name in clear.
        static const char *const yytname_[];
#if YYDEBUG
        // YYRLINE[YYN] -- Source line where rule number YYN was defined.
        static const unsigned short int yyrline_[];

        /// Report on the debug stream that the rule \a r is going to be reduced.
        virtual void yy_reduce_print_(int r);

        /// Print the state stack on the debug stream.
        virtual void yystack_print_();

        // Debugging.
        int yydebug_;
        std::ostream *yycdebug_;

        /// \brief Display a symbol type, value and location.
        /// \param yyo    The output stream.
        /// \param yysym  The symbol.
        template<typename Base>
        void yy_print_(std::ostream &yyo, const basic_symbol<Base> &yysym) const;

#endif

        /// \brief Reclaim the memory associated to a symbol.
        /// \param yymsg     Why this token is reclaimed.
        ///                  If null, print nothing.
        /// \param yysym     The symbol.
        template<typename Base>
        void yy_destroy_(const char *yymsg, basic_symbol<Base> &yysym) const;

    private:
        /// Type access provider for state based symbols.
        struct by_state {
            /// Default constructor.
            by_state();

            /// The symbol type as needed by the constructor.
            typedef state_type kind_type;

            /// Constructor.
            by_state(kind_type s);

            /// Copy constructor.
            by_state(const by_state &other);

            /// Record that this symbol is empty.
            void clear();

            /// Steal the symbol type from \a that.
            void move(by_state &that);

            /// The (internal) type number (corresponding to \a state).
            /// \a empty_symbol when empty.
            symbol_number_type type_get() const;

            /// The state number used to denote an empty symbol.
            enum {
                empty_state = -1
            };

            /// The state.
            /// \a empty when empty.
            state_type state;
        };

        /// "Internal" symbol: element of the stack.
        struct stack_symbol_type : basic_symbol<by_state> {
            /// Superclass.
            typedef basic_symbol<by_state> super_type;

            /// Construct an empty symbol.
            stack_symbol_type();

            /// Steal the contents from \a sym to build this.
            stack_symbol_type(state_type s, symbol_type &sym);

            /// Assignment, needed by push_back.
            stack_symbol_type &operator=(const stack_symbol_type &that);
        };

        /// Stack type.
        typedef stack<stack_symbol_type> stack_type;

        /// The stack.
        stack_type yystack_;

        /// Push a new state on the stack.
        /// \param m    a debug message to display
        ///             if null, no trace is output.
        /// \param s    the symbol
        /// \warning the contents of \a s.value is stolen.
        void yypush_(const char *m, stack_symbol_type &s);

        /// Push a new look ahead token on the state on the stack.
        /// \param m    a debug message to display
        ///             if null, no trace is output.
        /// \param s    the state
        /// \param sym  the symbol (for its value and location).
        /// \warning the contents of \a s.value is stolen.
        void yypush_(const char *m, state_type s, symbol_type &sym);

        /// Pop \a n symbols the three stacks.
        void yypop_(unsigned int n = 1);

        /// Constants.
        enum {
            yyeof_ = 0,
            yylast_ = 639,     ///< Last index in yytable_.
            yynnts_ = 52,  ///< Number of nonterminal symbols.
            yyfinal_ = 27, ///< Termination state number.
            yyterror_ = 1,
            yyerrcode_ = 256,
            yyntokens_ = 72  ///< Number of tokens.
        };


        // User arguments.
        aml_driver &driver;
    };

    // Symbol number corresponding to token number t.
    inline
    aml_parser::token_number_type
    aml_parser::yytranslate_(token_type t) {
        static
        const token_number_type
                translate_table[] =
                {
                        0, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
                        2, 2, 2, 2, 2, 2, 1, 2, 3, 4,
                        5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
                        15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                        25, 26, 27, 28, 29, 30, 31, 32, 33, 34,
                        35, 36, 37, 38, 39, 40, 41, 42, 43, 44,
                        45, 46, 47, 48, 49, 50, 51, 52, 53, 54,
                        55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
                        65, 66, 67, 68, 69, 70, 71
                };
        const unsigned int user_token_number_max_ = 326;
        const token_number_type undef_token_ = 2;

        if (static_cast<int>(t) <= yyeof_)
            return yyeof_;
        else if (static_cast<unsigned int> (t) <= user_token_number_max_)
            return translate_table[t];
        else
            return undef_token_;
    }

    inline
    aml_parser::syntax_error::syntax_error(const location_type &l, const std::string &m)
            : std::runtime_error(m), location(l) {}

    // basic_symbol.
    template<typename Base>
    inline
    aml_parser::basic_symbol<Base>::basic_symbol()
            : value() {}

    template<typename Base>
    inline
    aml_parser::basic_symbol<Base>::basic_symbol(const basic_symbol &other)
            : Base(other), value(), location(other.location) {
        switch (other.type_get()) {
            case 95: // sections
                value.copy<std::map<std::string, std::vector<DESCAM::Stmt *>>>(other.value);
                break;

            case 109: // statements
            case 110: // statement
            case 111: // assign_statement
            case 120: // opt_else
                value.copy<std::vector<DESCAM::Stmt *> >(other.value);
                break;

            case 104: // datatype
                value.copy<DESCAM::DataType *>(other.value);
                break;

            case 123: // expr
                value.copy<DESCAM::Expr *>(other.value);
                break;

            case 119: // if_statement
                value.copy<DESCAM::ITE *>(other.value);
                break;

            case 113: // nb_read_statement
            case 116: // get_statement
                value.copy<DESCAM::NBRead *>(other.value);
                break;

            case 115: // nb_write_statement
            case 117: // set_statement
                value.copy<DESCAM::NBWrite *>(other.value);
                break;

            case 101: // port_decl
                value.copy<DESCAM::Port *>(other.value);
                break;

            case 112: // read_statement
            case 118: // req_statement
                value.copy<DESCAM::Read *>(other.value);
                break;

            case 106: // var_ref
            case 107: // var_ref_parent
            case 108: // var_ref_child
                value.copy<DESCAM::VariableOperand *>(other.value);
                break;

            case 114: // write_statement
                value.copy<DESCAM::Write *>(other.value);
                break;

            case 5: // "boolean value"
                value.copy<bool>(other.value);
                break;

            case 4: // "number"
                value.copy<int>(other.value);
                break;

            case 103: // var_list_comma
                value.copy<std::map<std::string, DESCAM::Variable *> >(other.value);
                break;

            case 3: // "identifier"
            case 96: // name_header
            case 97: // name_header_list
            case 98: // name_header_el
            case 99: // blocking_key
            case 100: // direction_key
                value.copy<std::string>(other.value);
                break;

            case 91: // opt_init
            case 121: // expr_list_comma
                value.copy<std::vector<DESCAM::Expr *> >(other.value);
                break;

            case 102: // name_list_comma
                value.copy<std::vector<std::string> >(other.value);
                break;

            default:
                break;
        }

    }


    template<typename Base>
    inline
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const semantic_type &v, const location_type &l)
            : Base(t), value(), location(l) {
        (void) v;
        switch (this->type_get()) {
            case 95: // sections
                value.copy<std::map<std::string, std::vector<DESCAM::Stmt *>>>(v);
                break;

            case 109: // statements
            case 110: // statement
            case 111: // assign_statement
            case 120: // opt_else
                value.copy<std::vector<DESCAM::Stmt *> >(v);
                break;

            case 104: // datatype
                value.copy<DESCAM::DataType *>(v);
                break;

            case 123: // expr
                value.copy<DESCAM::Expr *>(v);
                break;

            case 119: // if_statement
                value.copy<DESCAM::ITE *>(v);
                break;

            case 113: // nb_read_statement
            case 116: // get_statement
                value.copy<DESCAM::NBRead *>(v);
                break;

            case 115: // nb_write_statement
            case 117: // set_statement
                value.copy<DESCAM::NBWrite *>(v);
                break;

            case 101: // port_decl
                value.copy<DESCAM::Port *>(v);
                break;

            case 112: // read_statement
            case 118: // req_statement
                value.copy<DESCAM::Read *>(v);
                break;

            case 106: // var_ref
            case 107: // var_ref_parent
            case 108: // var_ref_child
                value.copy<DESCAM::VariableOperand *>(v);
                break;

            case 114: // write_statement
                value.copy<DESCAM::Write *>(v);
                break;

            case 5: // "boolean value"
                value.copy<bool>(v);
                break;

            case 4: // "number"
                value.copy<int>(v);
                break;

            case 103: // var_list_comma
                value.copy<std::map<std::string, DESCAM::Variable *> >(v);
                break;

            case 3: // "identifier"
            case 96: // name_header
            case 97: // name_header_list
            case 98: // name_header_el
            case 99: // blocking_key
            case 100: // direction_key
                value.copy<std::string>(v);
                break;

            case 91: // opt_init
            case 121: // expr_list_comma
                value.copy<std::vector<DESCAM::Expr *> >(v);
                break;

            case 102: // name_list_comma
                value.copy<std::vector<std::string> >(v);
                break;

            default:
                break;
        }
    }


    // Implementation of basic_symbol constructor for each type.

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const location_type &l)
            : Base(t), value(), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::map<std::string, std::vector<DESCAM::Stmt *>> v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::vector<DESCAM::Stmt *> v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::DataType *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::Expr *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::ITE *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::NBRead *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::NBWrite *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::Port *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::Read *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::VariableOperand *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const DESCAM::Write *v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const bool v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const int v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::map<std::string, DESCAM::Variable *> v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::string v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::vector<DESCAM::Expr *> v, const location_type &l)
            : Base(t), value(v), location(l) {}

    template<typename Base>
    aml_parser::basic_symbol<Base>::basic_symbol(typename Base::kind_type t, const std::vector<std::string> v, const location_type &l)
            : Base(t), value(v), location(l) {}


    template<typename Base>
    inline
    aml_parser::basic_symbol<Base>::~basic_symbol() {
        clear();
    }

    template<typename Base>
    inline
    void
    aml_parser::basic_symbol<Base>::clear() {
        // User destructor.
        symbol_number_type yytype = this->type_get();
        basic_symbol<Base> &yysym = *this;
        (void) yysym;
        switch (yytype) {
            default:
                break;
        }

        // Type destructor.
        switch (yytype) {
            case 95: // sections
                value.template destroy<std::map<std::string, std::vector<DESCAM::Stmt *>>>();
                break;

            case 109: // statements
            case 110: // statement
            case 111: // assign_statement
            case 120: // opt_else
                value.template destroy<std::vector<DESCAM::Stmt *> >();
                break;

            case 104: // datatype
                value.template destroy<DESCAM::DataType *>();
                break;

            case 123: // expr
                value.template destroy<DESCAM::Expr *>();
                break;

            case 119: // if_statement
                value.template destroy<DESCAM::ITE *>();
                break;

            case 113: // nb_read_statement
            case 116: // get_statement
                value.template destroy<DESCAM::NBRead *>();
                break;

            case 115: // nb_write_statement
            case 117: // set_statement
                value.template destroy<DESCAM::NBWrite *>();
                break;

            case 101: // port_decl
                value.template destroy<DESCAM::Port *>();
                break;

            case 112: // read_statement
            case 118: // req_statement
                value.template destroy<DESCAM::Read *>();
                break;

            case 106: // var_ref
            case 107: // var_ref_parent
            case 108: // var_ref_child
                value.template destroy<DESCAM::VariableOperand *>();
                break;

            case 114: // write_statement
                value.template destroy<DESCAM::Write *>();
                break;

            case 5: // "boolean value"
                value.template destroy<bool>();
                break;

            case 4: // "number"
                value.template destroy<int>();
                break;

            case 103: // var_list_comma
                value.template destroy<std::map<std::string, DESCAM::Variable *> >();
                break;

            case 3: // "identifier"
            case 96: // name_header
            case 97: // name_header_list
            case 98: // name_header_el
            case 99: // blocking_key
            case 100: // direction_key
                value.template destroy<std::string>();
                break;

            case 91: // opt_init
            case 121: // expr_list_comma
                value.template destroy<std::vector<DESCAM::Expr *> >();
                break;

            case 102: // name_list_comma
                value.template destroy<std::vector<std::string> >();
                break;

            default:
                break;
        }

        Base::clear();
    }

    template<typename Base>
    inline
    bool
    aml_parser::basic_symbol<Base>::empty() const {
        return Base::type_get() == empty_symbol;
    }

    template<typename Base>
    inline
    void
    aml_parser::basic_symbol<Base>::move(basic_symbol &s) {
        super_type::move(s);
        switch (this->type_get()) {
            case 95: // sections
                value.move<std::map<std::string, std::vector<DESCAM::Stmt *>>>(s.value);
                break;

            case 109: // statements
            case 110: // statement
            case 111: // assign_statement
            case 120: // opt_else
                value.move<std::vector<DESCAM::Stmt *> >(s.value);
                break;

            case 104: // datatype
                value.move<DESCAM::DataType *>(s.value);
                break;

            case 123: // expr
                value.move<DESCAM::Expr *>(s.value);
                break;

            case 119: // if_statement
                value.move<DESCAM::ITE *>(s.value);
                break;

            case 113: // nb_read_statement
            case 116: // get_statement
                value.move<DESCAM::NBRead *>(s.value);
                break;

            case 115: // nb_write_statement
            case 117: // set_statement
                value.move<DESCAM::NBWrite *>(s.value);
                break;

            case 101: // port_decl
                value.move<DESCAM::Port *>(s.value);
                break;

            case 112: // read_statement
            case 118: // req_statement
                value.move<DESCAM::Read *>(s.value);
                break;

            case 106: // var_ref
            case 107: // var_ref_parent
            case 108: // var_ref_child
                value.move<DESCAM::VariableOperand *>(s.value);
                break;

            case 114: // write_statement
                value.move<DESCAM::Write *>(s.value);
                break;

            case 5: // "boolean value"
                value.move<bool>(s.value);
                break;

            case 4: // "number"
                value.move<int>(s.value);
                break;

            case 103: // var_list_comma
                value.move<std::map<std::string, DESCAM::Variable *> >(s.value);
                break;

            case 3: // "identifier"
            case 96: // name_header
            case 97: // name_header_list
            case 98: // name_header_el
            case 99: // blocking_key
            case 100: // direction_key
                value.move<std::string>(s.value);
                break;

            case 91: // opt_init
            case 121: // expr_list_comma
                value.move<std::vector<DESCAM::Expr *> >(s.value);
                break;

            case 102: // name_list_comma
                value.move<std::vector<std::string> >(s.value);
                break;

            default:
                break;
        }

        location = s.location;
    }

    // by_type.
    inline
    aml_parser::by_type::by_type()
            : type(empty_symbol) {}

    inline
    aml_parser::by_type::by_type(const by_type &other)
            : type(other.type) {}

    inline
    aml_parser::by_type::by_type(token_type t)
            : type(yytranslate_(t)) {}

    inline
    void
    aml_parser::by_type::clear() {
        type = empty_symbol;
    }

    inline
    void
    aml_parser::by_type::move(by_type &that) {
        type = that.type;
        that.clear();
    }

    inline
    int
    aml_parser::by_type::type_get() const {
        return type;
    }

    inline
    aml_parser::token_type
    aml_parser::by_type::token() const {
        // YYTOKNUM[NUM] -- (External) token number corresponding to the
        // (internal) symbol number NUM (which must be that of a token).  */
        static
        const unsigned short int
                yytoken_number_[] =
                {
                        0, 256, 257, 258, 259, 260, 261, 262, 263, 264,
                        265, 266, 267, 268, 269, 270, 271, 272, 273, 274,
                        275, 276, 277, 278, 279, 280, 281, 282, 283, 284,
                        285, 286, 287, 288, 289, 290, 291, 292, 293, 294,
                        295, 296, 297, 298, 299, 300, 301, 302, 303, 304,
                        305, 306, 307, 308, 309, 310, 311, 312, 313, 314,
                        315, 316, 317, 318, 319, 320, 321, 322, 323, 324,
                        325, 326
                };
        return static_cast<token_type> (yytoken_number_[type]);
    }

    // Implementation of make_symbol for each symbol type.
    aml_parser::symbol_type
    aml_parser::make_END(const location_type &l) {
        return symbol_type(token::TOK_END, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NAME(const std::string &v, const location_type &l) {
        return symbol_type(token::TOK_NAME, v, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NUM(const int &v, const location_type &l) {
        return symbol_type(token::TOK_NUM, v, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BOOLVAL(const bool &v, const location_type &l) {
        return symbol_type(token::TOK_BOOLVAL, v, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SYSTEM(const location_type &l) {
        return symbol_type(token::TOK_SYSTEM, l);
    }

    aml_parser::symbol_type
    aml_parser::make_MODULE(const location_type &l) {
        return symbol_type(token::TOK_MODULE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_IN(const location_type &l) {
        return symbol_type(token::TOK_IN, l);
    }

    aml_parser::symbol_type
    aml_parser::make_OUT(const location_type &l) {
        return symbol_type(token::TOK_OUT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_FSM(const location_type &l) {
        return symbol_type(token::TOK_FSM, l);
    }

    aml_parser::symbol_type
    aml_parser::make_CONNECT(const location_type &l) {
        return symbol_type(token::TOK_CONNECT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BLOCKING(const location_type &l) {
        return symbol_type(token::TOK_BLOCKING, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SHARED(const location_type &l) {
        return symbol_type(token::TOK_SHARED, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SECTIONS(const location_type &l) {
        return symbol_type(token::TOK_SECTIONS, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NEXTSECTION(const location_type &l) {
        return symbol_type(token::TOK_NEXTSECTION, l);
    }

    aml_parser::symbol_type
    aml_parser::make_INIT(const location_type &l) {
        return symbol_type(token::TOK_INIT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_ENUM(const location_type &l) {
        return symbol_type(token::TOK_ENUM, l);
    }

    aml_parser::symbol_type
    aml_parser::make_CONST(const location_type &l) {
        return symbol_type(token::TOK_CONST, l);
    }

    aml_parser::symbol_type
    aml_parser::make_FUNC(const location_type &l) {
        return symbol_type(token::TOK_FUNC, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BOOL(const location_type &l) {
        return symbol_type(token::TOK_BOOL, l);
    }

    aml_parser::symbol_type
    aml_parser::make_INT(const location_type &l) {
        return symbol_type(token::TOK_INT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_COMPOUND(const location_type &l) {
        return symbol_type(token::TOK_COMPOUND, l);
    }

    aml_parser::symbol_type
    aml_parser::make_IF(const location_type &l) {
        return symbol_type(token::TOK_IF, l);
    }

    aml_parser::symbol_type
    aml_parser::make_ELSE(const location_type &l) {
        return symbol_type(token::TOK_ELSE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_READ(const location_type &l) {
        return symbol_type(token::TOK_READ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_WRITE(const location_type &l) {
        return symbol_type(token::TOK_WRITE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NBREAD(const location_type &l) {
        return symbol_type(token::TOK_NBREAD, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NBWRITE(const location_type &l) {
        return symbol_type(token::TOK_NBWRITE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_GET(const location_type &l) {
        return symbol_type(token::TOK_GET, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SET(const location_type &l) {
        return symbol_type(token::TOK_SET, l);
    }

    aml_parser::symbol_type
    aml_parser::make_REQ(const location_type &l) {
        return symbol_type(token::TOK_REQ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_ASSIGNMENT(const location_type &l) {
        return symbol_type(token::TOK_ASSIGNMENT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_INCREMENT(const location_type &l) {
        return symbol_type(token::TOK_INCREMENT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_DECREMENT(const location_type &l) {
        return symbol_type(token::TOK_DECREMENT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_AT(const location_type &l) {
        return symbol_type(token::TOK_AT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_LPAREN(const location_type &l) {
        return symbol_type(token::TOK_LPAREN, l);
    }

    aml_parser::symbol_type
    aml_parser::make_RPAREN(const location_type &l) {
        return symbol_type(token::TOK_RPAREN, l);
    }

    aml_parser::symbol_type
    aml_parser::make_LCURLY(const location_type &l) {
        return symbol_type(token::TOK_LCURLY, l);
    }

    aml_parser::symbol_type
    aml_parser::make_RCURLY(const location_type &l) {
        return symbol_type(token::TOK_RCURLY, l);
    }

    aml_parser::symbol_type
    aml_parser::make_COLON(const location_type &l) {
        return symbol_type(token::TOK_COLON, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SEMICOLON(const location_type &l) {
        return symbol_type(token::TOK_SEMICOLON, l);
    }

    aml_parser::symbol_type
    aml_parser::make_PUNKT(const location_type &l) {
        return symbol_type(token::TOK_PUNKT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_COMMA(const location_type &l) {
        return symbol_type(token::TOK_COMMA, l);
    }

    aml_parser::symbol_type
    aml_parser::make_ARROW(const location_type &l) {
        return symbol_type(token::TOK_ARROW, l);
    }

    aml_parser::symbol_type
    aml_parser::make_XNOR(const location_type &l) {
        return symbol_type(token::TOK_XNOR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_XOR(const location_type &l) {
        return symbol_type(token::TOK_XOR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NOR(const location_type &l) {
        return symbol_type(token::TOK_NOR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NAND(const location_type &l) {
        return symbol_type(token::TOK_NAND, l);
    }

    aml_parser::symbol_type
    aml_parser::make_OR(const location_type &l) {
        return symbol_type(token::TOK_OR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_AND(const location_type &l) {
        return symbol_type(token::TOK_AND, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BITOR(const location_type &l) {
        return symbol_type(token::TOK_BITOR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BITXOR(const location_type &l) {
        return symbol_type(token::TOK_BITXOR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BITAND(const location_type &l) {
        return symbol_type(token::TOK_BITAND, l);
    }

    aml_parser::symbol_type
    aml_parser::make_EQ(const location_type &l) {
        return symbol_type(token::TOK_EQ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NEQ(const location_type &l) {
        return symbol_type(token::TOK_NEQ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_MORE(const location_type &l) {
        return symbol_type(token::TOK_MORE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_LESS(const location_type &l) {
        return symbol_type(token::TOK_LESS, l);
    }

    aml_parser::symbol_type
    aml_parser::make_MOREEQ(const location_type &l) {
        return symbol_type(token::TOK_MOREEQ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_LESSEQ(const location_type &l) {
        return symbol_type(token::TOK_LESSEQ, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SHIFTL(const location_type &l) {
        return symbol_type(token::TOK_SHIFTL, l);
    }

    aml_parser::symbol_type
    aml_parser::make_SHIFTR(const location_type &l) {
        return symbol_type(token::TOK_SHIFTR, l);
    }

    aml_parser::symbol_type
    aml_parser::make_MINUS(const location_type &l) {
        return symbol_type(token::TOK_MINUS, l);
    }

    aml_parser::symbol_type
    aml_parser::make_PLUS(const location_type &l) {
        return symbol_type(token::TOK_PLUS, l);
    }

    aml_parser::symbol_type
    aml_parser::make_MULTIPLY(const location_type &l) {
        return symbol_type(token::TOK_MULTIPLY, l);
    }

    aml_parser::symbol_type
    aml_parser::make_DIVIDE(const location_type &l) {
        return symbol_type(token::TOK_DIVIDE, l);
    }

    aml_parser::symbol_type
    aml_parser::make_REMAINDER(const location_type &l) {
        return symbol_type(token::TOK_REMAINDER, l);
    }

    aml_parser::symbol_type
    aml_parser::make_NOT(const location_type &l) {
        return symbol_type(token::TOK_NOT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_BITNOT(const location_type &l) {
        return symbol_type(token::TOK_BITNOT, l);
    }

    aml_parser::symbol_type
    aml_parser::make_UMIN(const location_type &l) {
        return symbol_type(token::TOK_UMIN, l);
    }


} // yy
#line 2178 "/home/nawras/SCAM/src/parserAML/aml_parser.hpp" // lalr1.cc:377


#endif // !YY_YY_HOME_NAWRAS_SCAM_SRC_PARSEAML_AML_PARSER_HPP_INCLUDED
