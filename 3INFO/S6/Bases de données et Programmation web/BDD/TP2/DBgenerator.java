import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import java.util.Random;


public class DBgenerator {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("DBgenerator");
		
		try {
			//String filename = args[0];
			int size = 100000;
			try {
		        size = Integer.parseInt(args[0]);
		    } catch (NumberFormatException e) {
		        System.err.println("Argument" + " must be an integer");
		        System.exit(1);
		    }
			
			
			String content = "CREATE TABLE demo(id INTEGER PRIMARY KEY, code INTEGER);\n";
			Random randomGenerator = new Random();
			File file = new File("database.sql");
			//File file = new File(filename);
			
					
			
			// if file doesnt exists, then create it
			if (!file.exists()) {
				file.createNewFile();
			}
 
			//String dirPath = file.getParentFile().getAbsolutePath();
			//System.out.println("PATH: " + dirPath);
			
			
			FileWriter fw = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
			Integer max = 100000000;
			
			bw.write(content);
			content = "BEGIN TRANSACTION;\n";
			bw.write(content);
			//content = "PRAGMA journal_mode = OFF;\n";
			//bw.write(content);
			//content = "PRAGMA synchronous = OFF;\n";
			//bw.write(content);
			for(int i=0;i<size;i++){
				bw.write("INSERT INTO demo(code) VALUES(" + 
						Integer.toString(randomGenerator.nextInt(max)) 
						+");"
						+ "\n");
			}
			content = "COMMIT;\n";
			bw.write(content);
			bw.close();
 
			System.out.println("Done");
 
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		
		
	}

}
