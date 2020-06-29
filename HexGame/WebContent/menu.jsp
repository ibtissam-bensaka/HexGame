<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Menu</title>
<link rel="stylesheet" href="css/menu.css">
<link rel="icon" href="./images/icone.ico" /> 
</head>
<body>
<div id="allthethings">
  <div id="left"></div>
	<div id="play" onclick="window.location.href='level.jsp';"><p>PLAY</p></div>
  <div id="account" onclick="window.location.href='account.jsp';" ><p>ACCOUNT</p></div>
  <div id="bestscore" onclick="window.location.href='bestScore.jsp';"><p>BEST PLAYERS</p></div>
  <div id="help" onclick="window.location.href='help.jsp';"><p>HELP</p></div>
  <div id="right"></div>
  
  <div id="exit" onclick="window.location.href='welcome.jsp';"></div>
  <div id="circle"></div>
</div>
</body>
</html>