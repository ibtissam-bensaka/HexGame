package classesServlet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class Joueur {
	private String username;
	private String name;
	private String password;
	public Joueur() {}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void ajouterJoueur(String username,String name,String password) {
		System.out.println("avt conn");
		Connection con=Connexion.getCon();
		int status=0;
		try {
			/* Exécution d'une requête d'écriture */
			PreparedStatement ps=con.prepareStatement("insert into hex.joueur (username,name,passwd,score) values(?,?,?,?);");
			ps.setString(1,username);
			ps.setString(2,name);
			ps.setString(3,password);
			ps.setInt(4,0);
			status=ps.executeUpdate();
			con.close();
			System.out.println("ajouterJoueur_statut="+status);
		}catch(Exception e) {
			System.out.println(e);
		}
		
	}
	public int rechercherJoueur(String userName) {
		int status=0;
		PreparedStatement ps;
	    Connection con=Connexion.getCon();
	    try {
	    	ps=con.prepareStatement("select username from hex.joueur where username=?");
	    	ps.setString(1,userName);
	    	ResultSet rs=ps.executeQuery();    
	    	while(rs.next()) {
	    		String c=rs.getString("username");
	    		if(userName.equals(c)) {
	    			status=1;
	    	}
	    		}
    		con.close();
	}catch(Exception e) {
		System.out.println(e);
	}
    	return status;
	}
	public int rechercherJoueur(String userName,String password) {
		int status=0;
		PreparedStatement ps;
	    Connection con=Connexion.getCon();
	    try {
	    	ps=con.prepareStatement("select username,passwd from hex.joueur where username=? and passwd=?");
	    	ps.setString(1,userName);
	    	ps.setString(2,password);
	    	ResultSet rs=ps.executeQuery();    
	    	while(rs.next()) {
	    		String c=rs.getString("username");
	    		String pwd=rs.getString("passwd");
	    		if(userName.equals(c) && password.equals(pwd)) {
	    			status=1;
	    	}
	    		}
	    	con.close();
	}catch(Exception e) {
		System.out.println(e);
	}
    	return status;
	}
	public int modifierMDP(String userName,String password) {
		int status=0;
		PreparedStatement ps;
	    Connection con=Connexion.getCon();
	    try {
	    	ps=con.prepareStatement("update hex.joueur set passwd=? where username=?");
	    	ps.setString(1,password);
	    	ps.setString(2,userName);
	    	status=ps.executeUpdate();   
	    	con.close();
	}catch(Exception e) {
		System.out.println(e);
	}
    	return status;
	}
}
