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

Punctuation  = " " | "!" | """ | """ | "#" | "$" | "%" | "&" | "'" | "(" | ")" | "*" | "+" | "," | "-" | "." | "/" | ":" | ";" | "<" | "=" | ">" | "?" | "@" | "[" | "]" | "{" | "}" | "\" | "^" | "_" | "`" | "~" | "|"

ID_Character = {Letter} | {Digit} | "_"

Identifier  = {Letter}{ID_Character}* 
Character =  "'"({Letter} | {Digit} | {Punctuation} ) "'" 
Boolean = "T" | "F"

Integer = -? {Digit}+ | -? [1-9] {Digit}+
Fraction = {Digit}+ "/" {Digit}+
Float = {Integer} "." {Digit}+
Rational = {Fraction} | {Integer} "_" {Fraction}

%%
<YYINTIAL> {	
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
	
}



