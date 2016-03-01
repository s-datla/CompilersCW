//reference: http://jflex.de/manual.html#ExampleUserCode
//Diala aldahabi

import java_cup.runtime.Symbol;


%%
%class Lexer
%column
%line
%char
%unicode
%cup
%public
%debug


%eofval{
  return new Symbol(symbol.EOF);
%eofval}

%{
StringBuffer string = new StringBuffer();

    private Symbol symbol (int type) {
		return new Symbol(type, yyline, yycolumn);
	}	


	private Symbol symbol (int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}
}%

EOL=\r|\n|\r\n
NOT_EOL=[^\r\n]

%%



single-line-comment = "#"EOL
Multi-line-comment = "/#" "#/"  
id_dec  = {['A'..'Z'] | ['a'..'z']}({['0'..'9']}|{['A'..'Z'] | ['a'..'z']}|"_")*
char_dec = "'"({['A'..'Z'] | ['a'..'z']}|{['0'..'9']}|{[$(),!#-;:~^%*@'+=?><&._]})"'"
bool_dec = ("T"|"F")
int_dec = ['0'..'9']|-['0'..'9']
rational_dec = ({['0'..'9']/['0'..'9']}|['0'..'9']"_"/['0'..'9']
float_dec = ['0'..'9'].['0'..'9']
<YYINITIAL> {
 {id_dec}   { return symbol(symbol.id_dec); }
 {char_dec} { return symbol(symbol.char_dec); }
 {bool_dec} {return symbol(symbol.bool_dec);}
 {int_dec} {return symbol(symbol.int_dec);}
 {rational_dec} {return symbol(symbol.rational_dec);}
 {float_dec} {return symbol(symbol.float_dec);}
 "string" {return symbol(symbol.STRING);}
 "rat"       { return symbol(symbol.RATIONAL); }
 "tdef"      { return symbol(symbol.TDEF); }
 "char"      { return symbol(symbol.CHAR); }
  "top"       { return symbol(symbol.TOP); }
  "!"         { return symbol(symbol.NOT); }
"&&"        { return symbol(symbol.AND); }
"/"         { return symbol(symbol.DIVISION); }
"^"         { return symbol(symbol.POWER); }
 "bool"      { return symbol(symbol.BOOL); }
 "<"         { return symbol(symbol.LESSTHAN); }
 "="         { return symbol(symbol.EQUAL); }
"!="        { return symbol(symbol.NOTEQUAL); }
 "fdef"      { return symbol(symbol.FDEF); }
  "float"     { return symbol(symbol.FLOAT); }
  "od"        { return symbol(symbol.ENDDO); }
 "int"       { return symbol(symbol.INT); }
 "main"      { return symbol(symbol.MAIN); }
 "-"         { return symbol(symbol.MINUS); }
"*"         { return symbol(symbol.TIMES); }
 "read"      { return symbol(symbol.READ); }
 "print"     { return symbol(symbol.PRINT); }
 "alias"     { return symbol(symbol.ALIAS); }
 "<="        { return symbol(symbol.LESSTHANEQUAL); }
 "||"        { return symnol(symbol.OR); }
 "dict"      { return symbol(symbol.DICT); }
"seq"       { return symbol(symbol.SEQ); }
"in"        { return symbol(symbol.IN); }
"fi"        { return symbol(symbol.ENDIF); }
"=>"        { return symbol(symbol.IMPLIES); }
"len"       { return symbol(symbol.LEN); }
"::"        { return symbol(symbol.CONCAT); }
"while"     { return symbol(symbol.WHILE); }
"do"        { return symbol(symbol.DO); }
"forall"    { return symbol(symbol.FORALL); }
"return"    { return symbol(symbol.RETURN); }
"elif"      { return symbol(symbol.ELSEIF);}
"if"        { return symbol(symbol.IF); }
"then"      { return symbol(symbol.THEN); }
"else"      { return symbol(symbol.ELSE); }
")"         { return symbol(symbol.RPAREN); }
"("         { return symbol(symbol.LPAREN); }
"{"         { return symbol(symbol.LBRACE); }
"}"         { return symbol(symbol.RBRACE); }
";"         { return symbol(symbol.SEMICOLON); }
","         { return symbol(symbol.COMMA); }
}

[^]      { throw new Error(“Syntax error at line”+yyline()+1 + “, column “yycolumn(); }
 
 


