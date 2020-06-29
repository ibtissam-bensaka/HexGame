<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
<link rel="stylesheet" href="css/logReg.css">
<link rel="icon" href="./images/icone.ico" />
</head>
<body>
<form class="box" action="Login" method="post">
  <h1>Login</h1>
   <h3>${echecMessage}</h3>
   <h3>${successMessage}</h3>
  <input type="text" name="username" placeholder="Username">
  <input type="password" name="passwd" placeholder="Password">
  <input type="submit" name="login" value="Login">
</form>

</body>
</html>