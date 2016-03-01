import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
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

Integer = 
Number = {Integer} | {Rational} | {Float}

