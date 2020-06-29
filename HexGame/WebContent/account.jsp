<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Account</title>
<link rel="stylesheet" href="css/account.css">
<link rel="icon" href="./images/icone.ico" />
</head>
<body>
<h1>YOUR ACCOUNT</h1>
<h2>Change your password</h2>
<h3>${echecMessage}</h3>
<h3>${successMessage}</h3>
<form action="ChangeMDP" method="post">
<input type="text" name="username" placeholder="Username">
<input type="password" name="Expasswd" placeholder="EX Password">
<input type="password" name="Newpasswd" placeholder="New Password">
<input type="password" name="Confirmpasswd" placeholder="confirm Password">
<input type="submit" class="confirm" name="submit" value="Confirm">
<input type="submit" class="return" name="submit" value="Back to menu">
</form>
</body>
</html>