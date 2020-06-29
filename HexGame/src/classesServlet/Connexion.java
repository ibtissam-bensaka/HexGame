package classesServlet;

import java.sql.Connection;
import java.sql.DriverManager;

public class Connexion {
		static Connection con=null;
		static String url = "jdbc:mysql://localhost:3306/hex?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
		static String user = "root";
		static String password = "08041998";
    public Connexion(){
 	   
    }
    public static Connection getCon() {
    	try {
    		/* Chargement du driver JDBC pour MySQL */
    		Class.forName("com.mysql.cj.jdbc.Driver");
    		/* Connexion à la base de données */
    		con=DriverManager.getConnection(url,user,password);
    		}catch(Exception e) {
    			System.out.println(e);
    		}
    		return con;
    }
}
