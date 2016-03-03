import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column
%debug

%eofval{
	return symbol(sym.EOF);
%eofval}

%{
	StringBuffer string = new StringBuffer();
	private Symbol symbol(int type) {
		return new Symbol(type, yyline, yycolumn);
	}
	private Symbol symbol(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

LineEnd = \r|\n|\r\n
Inputs = [^\r\n]
Delimiter = {LineEnd} | [ \t\f]

Comment = {SingleLineComment} | {MultipleLineComment} 

SingleLineComment = "#" {Inputs}* {LineEnd}?
MultipleLineComment = "/#" [^#]~ "#/" | "/#" "#"+ "/"

Letter  = [a-zA-Z]
Digit = [0-9]


ID_Character = {Letter} | {Digit} | "_"

Identifier  = {Letter}{ID_Character}* 

Integer = 0 | [1-9]{Digit}*

StringChar  = [^\n\r\"\\]
CharChar = [^\n\r\'\\]

%state STRING, CHARLITERAL

%%
<YYINITIAL> {

//	State Change

	\"					{string.setLength(0); yybegin(STRING);}
	\'					{yybegin(CHARLITERAL);}

//	Predefined Function Names

	"main"				{return symbol(sym.MAIN);}
	"dict"				{return symbol(sym.DICT);}
	"seq"				{return symbol(sym.SEQ);}
	"char"				{return symbol(sym.CHAR);}
	"bool"				{return symbol(sym.BOOL);}	
	"int"				{return symbol(sym.INT);}
	"rat"				{return symbol(sym.RAT);}
	"float"				{return symbol(sym.FLOAT);}
	"top"				{return symbol(sym.TOP);}
	"in"				{return symbol(sym.IN);}
	"len"				{return symbol(sym.LEN);}
	"tdef"				{return symbol(sym.TDEF);}
	"fdef"				{return symbol(sym.FDEF);}
	"alias"				{return symbol(sym.ALIAS);}
	"void"				{return symbol(sym.VOID);}
	"if"				{return symbol(sym.IFEL);}
	"else"				{return symbol(sym.ELSE);}
	"elif"				{return symbol(sym.ELIF);}
	"while"				{return symbol(sym.WHILE);}
	"forall"			{return symbol(sym.FORALL);}
	"read"				{return symbol(sym.READ);}
	"print"				{return symbol(sym.PRINT);}
	"then"				{return symbol(sym.THEN);}
	"fi"				{return symbol(sym.FI);}
	"do"				{return symbol(sym.DO);}
	"od"				{return symbol(sym.OD);}
	"return"			{return symbol(sym.RETURN);}
	"let"			{return symbol(sym.LET);}


//	Mathematical Operators

	"+"					{return symbol(sym.SYM_PLUS);}
	"-"					{return symbol(sym.SYM_MINUS);}
	"*"					{return symbol(sym.SYM_STAR);}
	"<"					{return symbol(sym.SYM_LARROW);}
	"="					{return symbol(sym.SYM_EQUAL);}
	">"					{return symbol(sym.SYM_RARROW);}
	"^"					{return symbol(sym.SYM_CARET);}
	"%"					{return symbol(sym.SYM_PRCNT);}
	"<="				{return symbol(sym.LEQ);}
	"=>"				{return symbol(sym.GEQ);}

// 	Logical Operators

	"||"				{return symbol(sym.SYM_OR);}
	"&&"				{return symbol(sym.SYM_AND);}
	"=="				{return symbol(sym.EQEQ);}
	"!="				{return symbol(sym.NOTEQ);}
	"::"				{return symbol(sym.CONCAT);}

//	Punctuation

	"!"					{return symbol(sym.SYM_EXCLPNT);}
	"#"					{return symbol(sym.SYM_HASH);}
	"$"					{return symbol(sym.SYM_DOLLAR);}
	"&"					{return symbol(sym.SYM_AMP);}
	"("					{return symbol(sym.SYM_LPAREN);}
	")"					{return symbol(sym.SYM_RPAREN);}
	","					{return symbol(sym.SYM_COMMA);}
	"."					{return symbol(sym.SYM_PERIOD);}
	"/"					{return symbol(sym.SYM_FSLASH);}
	":"					{return symbol(sym.SYM_COLON);}
	";"					{return symbol(sym.SYM_SEMI);}
	"?"					{return symbol(sym.SYM_QSTN);}
	"@"					{return symbol(sym.SYM_AT);}
	"["					{return symbol(sym.SYM_LSQR);}
	"]"					{return symbol(sym.SYM_RSQR);}
	"{"					{return symbol(sym.SYM_LCRL);}
	"}"					{return symbol(sym.SYM_RCRL);}
	\\					{return symbol(sym.SYM_BSLASH);}
	"_"					{return symbol(sym.SYM_USCORE);}
	"`"					{return symbol(sym.SYM_GRAVE);}
	"~"					{return symbol(sym.SYM_TILDE);}
	"|"					{return symbol(sym.SYM_PIPE);}

//	Boolean Values
	
//	"T"					{return symbol(sym.BOOL_LITERAL,true);}
//	"F"					{return symbol(sym.BOOL_LITERAL,false);}x

// Macros
	
	{Identifier}		{return symbol(sym.IDENT,yytext());}
	{Integer}			{return symbol(sym.INT_LITERAL,new Integer(yytext()));}
	{Delimiter}			{/*	Don't do anything */}
	{Comment}			{/* Don't do anything */}
}

<STRING> {

	\"					{yybegin(YYINITIAL);
							return symbol(sym.STRING_LITERAL,
							string.toString()); }
	{StringChar}+		{string.append(yytext());}
	"\\b" 				{string.append('\b');}
	"\\f" 				{string.append('\f');}
	"\\t" 				{string.append('\t');}
	"\\n" 				{string.append('\n');}
	"\\r"				{string.append('\r');}
	"\\\""				{string.append('\"');}
	"\\'"				{string.append('\'');}
	"\\\\"				{string.append('\\');}

//	Error Checking
	\\.					{throw new Error("Illegal Termination of String <" + yytext() + ">");}
	{LineEnd}			{throw new Error("Illegal Termination of String <" + yytext() + ">");}
	
}

<CHARLITERAL> {

	{CharChar}\'		{yybegin(YYINITIAL);return symbol(sym.CHAR_LITERAL,yytext().charAt(0));}
	"\\b"\' 			{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\b');}
	"\\f"\' 			{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\f');}
	"\\t"\' 			{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\t');}
	"\\n"\'				{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\n');}
	"\\r"\'				{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\r');}
	"\\\""\'			{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\"');}
	"\\'"\'				{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\'');}
	"\\\\"\'			{yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, '\\');}

//	Error Checking
	\\.					{throw new Error("Illegal Termination of Character <" + yytext() + ">");}
	{LineEnd}			{throw new Error("Illegal Termination of Character <" + yytext() + ">");}


}
//	Error Checking
[^]						{throw new Error("Illegal Character <" + yytext() + ">");}

