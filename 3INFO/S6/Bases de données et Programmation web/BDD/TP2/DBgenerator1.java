
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import java.util.Random;
import java.util.UUID;

public class DBgenerator1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("DBgenerator1");
		
		try {
			//String filename = args[0];
			int size = 6000000;
			try {
		        size = Integer.parseInt(args[0]);
		    } catch (NumberFormatException e) {
		        System.err.println("Argument" + " must be an integer");
		        System.exit(1);
		    }
			
			
			String content; 
			Random randomGenerator = new Random();
			File file = new File("database1.sql");
			//File file = new File(filename);
			
			// if file doesnt exists, then create it
			if (!file.exists()) {
				file.createNewFile();
			}
 
			FileWriter fw = new FileWriter(file.getAbsoluteFile());
			BufferedWriter bw = new BufferedWriter(fw);
			//Integer max = 100000000;
			String rand;			
			String uuid;  
			String amt ;
			// System.out.println("uuid = " + uuid);

			content = "PRAGMA auto_index = 0;\n";
			bw.write(content);
			content = "BEGIN TRANSACTION;\n";
			bw.write(content);
		    content = "CREATE TABLE facture (factureId INTEGER, customerId TEXT, amount REAL);\n";
			bw.write(content);
			content = "CREATE TABLE customer (customerId TEXT, name TEXT);\n";
			bw.write(content);
			for(int i=0;i<size;i++){
				//rand = Integer.toString(randomGenerator.nextInt(max));
				rand = UUID.randomUUID().toString();
				uuid= UUID.randomUUID().toString();
				amt = Double.toString(Math.round(randomGenerator.nextDouble()*1000.01*100.0)/100.0);
				bw.write("INSERT INTO facture (customerId,amount) VALUES(" + 
						"'" + rand + "'" + ", " + amt
						+");"
						+ "\n");
				bw.write("INSERT INTO customer (customerId,name) VALUES(" + 
						"'" + rand + "'" + ", " +"'" +uuid + "'"
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
