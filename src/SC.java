import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;

import java_cup.runtime.*;

class SC {
    public static void main(String[] args) {
    	
    	boolean showLexing=false;
    	boolean showParsing=false; 
    	String inputFile = null;
    	
    	Lexer lexer;
       	
    	if (args.length < 1 || args.length>2)
    	{
    		System.err.printf("Wrong input");
    		System.exit(1);
    	}
    	
    	for(String arg : args){
    	      if     (arg.equals("show-lexing"))  showLexing = true;
    	      else if(arg.equals("show-parsing")) showParsing = true;
    	      else                                inputFile = arg;
    	    }
    	
    	 if(showLexing && showParsing){
    	      System.err.println(
    	        "Specify at most one of show-lexing or show-parsing");
    	      System.exit(1);
    	    }

    	    if(inputFile == null){
    	      System.err.println("Specify input file as the last argument");
    	      System.exit(1);
    	    }
    	
		try {
			lexer = new Lexer(new FileReader(inputFile));
		    Parser parser = new Parser(lexer);

		    if(showLexing){
		        lexer.debug(true);
		      }

		      java_cup.runtime.Symbol symbol = null;

		      if(showParsing){
		        parser.debug(true);
		        System.out.println("digraph G {");
		        Symbol result = parser.parse();
		        System.out.println("}");
		      } else {
		        Symbol result = parser.parse();
		      }
				
				
		      //System.out.println();
	    } catch (FileNotFoundException e) {
	      System.err.printf("Could not find file <%s>\n", args[0]);
	      System.exit(1);

	    } catch (/* Yuk, but CUP gives us no choice */ Exception e) {
	      e.printStackTrace();
	    }
    }
}