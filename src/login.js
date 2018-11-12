function ValidateLoginCredentials()
{
   var	uname = document.getElementById("username").value;
	 var password = document.getElementById("password").value;
	 if(match(uname,password))
	      window.location.pathname = "timeline.html";
		else
		{
		alert("You have entered an invalid credentials!");
		return false;
		}
}
function match(uname, password)
{
 return 1;
}
