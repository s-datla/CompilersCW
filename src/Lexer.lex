import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
	private 
	StringBuffer input = new StringBuffer();
	private Token token(int type) {
		return new Token(type, line, col);
	}
	private Token token(int type, Object val) {
		return new Token(type, line, col, val);
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

Punctuation  = " " | "!" | """ | "#" | "$" | "%" | "&" | "'" | "(" | ")" | "*" | "+" | "," | "-" | "." | "/" | ":" | ";" | "<" | "=" | ">" | "?" | "@" | "[" | "]" | "{" | "}" | "\" | "^" | "_" | "`" | "~" | "|"

ID_Character = {Letter} | {Digit} | "_"

Identifier  = {Letter}{ID_Character}* 

Integer = 0 | [1-9]{Digit}*
Float = {Digit}+ "." {Digit}* | "."{Digit}+


StringChar  = [^\n\r\"\\]
CharChar = [^\n\r\'\\]

%state STRING, CHARLITERAL

%%
<YYINTIAL> {

//	State Change

	\"					{string.setLength(0); yybegin(STRING);}
	\'					{yybegin(CHARLITERAL)}

//	Predefined Function Names

	"main"				{return token(tok.MAIN)}
	"dict"				{return token(tok.DICT)}
	"seq"				{return token(tok.SEQ)}
	"char"				{return token(tok.CHAR)}
	"bool"				{return token(tok.BOOL)}	
	"int"				{return token(tok.INT)}
	"rat"				{return token(tok.RAT)}
	"float"				{return token(tok.FLOAT)}
	"top"				{return token(tok.TOP)}
	"in"				{return token(tok.IN)}
	"len"				{return token(tok.LEN)}
	"tdef"				{return token(tok.TDEF)}
	"fdef"				{return token(tok.FDEF)}
	"alias"				{return token(tok.ALIAS)}
	"void"				{return token(tok.VOID)}
	"if"				{return token(tok.IFEL)}
	"else"				{return token(tok.ELSE)}
	"elif"				{return token(tok.ELIF)}
	"while"				{return token(tok.WHILE)}
	"forall"			{return token(tok.FORALL)}
	"read"				{return token(tok.READ)}
	"print"				{return token(tok.PRINT)}
	"then"				{return token(tok.THEN)}
	"fi"				{return token(tok.FI)}
	"do"				{return token(tok.DO)}
	"od"				{return token(tok.OD)}
	"return"			{return token(tok.RETURN)}

//	Mathematical Operators

	"*"					{return token(tok.SYM_STAR)}
	"+"					{return token(tok.SYM_PLUS)}
	"<"					{return token(tok.SYM_LARROW)}
	"="					{return token(tok.SYM_EQUAL)}
	">"					{return token(tok.SYM_RARROW)}
	"^"					{return token(tok.SYM_CARET)}
	"%"					{return token(tok.SYM_PRCNT)}
	"<="				{return token(tok.LEQ)}
	"=>"				{return token(tok.GEQ)}	
	"+="				{return token(tok.PLUSEQ)}
	"-="				{return token(tok.MINEQ)}

// 	Logical Operators

	"||"				{return token(tok.SYM_OR)}
	"&&"				{return token(tok.SYM_AND)}
	"=="				{return token(tok.EQEQ)}
	"!="				{return token(tok.NOTEQ)}

//	Punctuation

	"!"					{return token(tok.SYM_EXCLPNT)}
	"#"					{return token(tok.SYM_HASH)}
	"$"					{return token(tok.SYM_DOLLAR)}
	"&"					{return token(tok.SYM_AMP)}
	"("					{return token(tok.SYM_LPAREN)}
	")"					{return token(tok.SYM_RPAREN)}
	","					{return token(tok.SYM_COMMA)}
	"-"					{return token(tok.SYM_MINUS)}
	"."					{return token(tok.SYM_PERIOD)}
	"/"					{return token(tok.SYM_FSLASH)}
	":"					{return token(tok.SYM_COLON)}
	";"					{return token(tok.SYM_SEMI)}
	"?"					{return token(tok.SYM_QSTN)}
	"@"					{return token(tok.SYM_AT)}
	"["					{return token(tok.SYM_LSQR)}
	"]"					{return token(tok.SYM_RSQR)}
	"{"					{return token(tok.SYM_LCRL)}
	"}"					{return token(tok.SYM_RCRL)}
	"\"					{return token(tok.SYM_BSLASH)}
	"_"					{return token(tok.SYM_USCORE)}
	"`"					{return token(tok.SYM_GRAVE)}
	"~"					{return token(tok.SYM_TILDE)}
	"|"					{return token(tok.SYM_PIPE)}

// Macros
	

}

<STRING> {

	\"					{yybegin(YYINTIIAL);
							return token(tok.STRING_LITERAL,
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
	\\.					{throw new RunTimeException("Illegal Escape Character \" + yytext() + "\"");}
	
}

<CHARLITERAL> {

	{CharChar}+\'		
	\\t 				{string.append('\t');}
	\\n 				{string.append('\n');}
	\\r 				{string.append('\r');}
	\\\"				{string.append('\"');}
	\\					{string.append('\\');}

}
//	Error Checking
[^]						{throw new Error("Illegal Character <" + yytext() + ">");}

