<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Best players</title>
<link rel="stylesheet" href="css/score.css">
<link rel="icon" href="./images/icone.ico" />
</head>
<body>
<h1>BEST PLAYERS</h1>

<table class="nat">
<% 
java.sql.PreparedStatement ps;
java.sql.Connection con=classesServlet.Connexion.getCon();
java.sql.ResultSet rs;
int i=0;
String tab[]=new String[4];
try {
	ps=con.prepareStatement("select username from hex.joueur order by score");
    rs=ps.executeQuery();    
	while(rs.next() && i<4) {
		tab[i]=rs.getString("username");
		i++;
		}
	con.close();
}catch(Exception e) {
System.out.println(e);
}
%>
<tr>
<th>Rating</th>
<th>Player</th>
</tr>
<tr><td>1</td><td><%=tab[0]%></td></tr>
<tr><td>2</td><td><%=tab[1]%></td></tr>
<tr><td>3</td><td><%=tab[2]%></td></tr>
<tr><td>4</td><td><%=tab[3]%></td></tr>
</table>
<input  type="submit" name="" onclick="window.location.href='menu.jsp';" value="Back to menu">
</body>
</html>