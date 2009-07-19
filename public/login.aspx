<%@ Page CodeBehind="login.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="WebSkyKids.login" %>
<HTML>
	<HEAD>
		<title>.:: SkyKids Peru Toys & More ::. - Login</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script language="JavaScript">
		
function validar()	
{
    if (trim(document.all['name'].value).length == 0) {
        alert('Ingrese usuario') ;
        f.name.focus() ;
        return false ;
    }

    if (trim(document.form1.pword.value).length == 0) {
        alert('Ingrese Contaseña') ;
        f.pword.focus() ;
        return false ;
    }
    return true;
}
		
function openwin(URL) 
{
	window.open(URL,"Detalles","height=550,width=750,status=0,menubar=0,scrollbars=1"); 
}

function opendlgwin(URL)
{
	window.open(URL,"Configuración","height=300,width=250,status=0,menubar=0,scrollbars=0"); 
}

function openmodalwin(URL)
{	
	window.showModalDialog(URL,"","dialogHeight: 540px; dialogWidth: 730px; dialogTop: 0; dialogLeft: 0; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");
}

function mouseOver(SENDER)
{
	SENDER.style.cursor='hand';
	<!--SENDER.border = 1;-->
}
function mouseOut(SENDER)
{
	SENDER.border = 0;
}
		</script>
	</HEAD>
	<body onload="Form1.name.focus();" bgColor="#cde295" leftMargin="0" background="jpg/fondo.jpg"
		topMargin="0" scroll="no" marginheight="0" marginwidth="0">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" border="0">
				<!--DWLayoutTable-->
				<tr>
					<td vAlign="middle" align="center">
						<table cellSpacing="0" cellPadding="0" width="780" align="center" border="0">
							<!--DWLayoutTable-->
							<tr>
								<td vAlign="top" align="center" width="179" rowSpan="4"><!--DWLayoutEmptyCell-->
									&nbsp;</td>
								<td vAlign="top" width="96" height="104"><!--DWLayoutEmptyCell--> &nbsp;</td>
								<td vAlign="top" width="228">
									<!-- Objeto -->
								</td>
								<td vAlign="top" width="176"><!--DWLayoutEmptyCell--> &nbsp;</td>
								<td vAlign="top" align="center" width="101" rowSpan="4"><!--DWLayoutEmptyCell-->
									&nbsp;</td>
							</tr>
							<tr>
								<td vAlign="top" colSpan="3" height="21"><!--DWLayoutEmptyCell--> &nbsp;</td>
							</tr>
							<tr>
								<td vAlign="top" align="center" colSpan="3" height="150"><table height="128" cellSpacing="5" cellPadding="0" width="500" border="0">
										<tr>
											<td vAlign="middle" align="right" width="141"><strong><font face="Verdana, Arial, Helvetica, sans-serif" color="#003366" size="-1">Usuario:</font></strong></td>
											<td vAlign="bottom" colSpan="3"><input id="name" size="29" name="name" runat="server">
											</td>
										</tr>
										<tr>
											<td vAlign="top"></td>
											<td vAlign="top" colSpan="3">&nbsp;</td>
										</tr>
										<tr>
											<td vAlign="middle" align="right"><font face="Arial, Helvetica,sans-serif" color="#003366" size="-1"><b><font face="Verdana, Arial, Helvetica, sans-serif">Password</font>:</b>
												</font>
											</td>
											<td vAlign="bottom" colSpan="3"><input id="pword" type="password" size="29" name="pword"
													runat="server">
											</td>
										</tr>
										<tr>
											<td vAlign="top"></td>
											<td vAlign="top" width="48">&nbsp;</td>
											<td vAlign="top" width="91">&nbsp;</td>
											<td vAlign="top" width="195">&nbsp;</td>
										</tr>
										<tr>
											<td vAlign="top"></td>
											<td vAlign="top">&nbsp;</td>
											<td vAlign="top">
												<asp:ImageButton id="ImageButton1" runat="server" ImageUrl="gif\boton_ingresar.gif"></asp:ImageButton></td>
											<td vAlign="top">&nbsp;</td>
										</tr>
									</table>
									<asp:Label id="Label1" runat="server" ForeColor="Red"></asp:Label></td>
							</tr>
							<tr>
								<td vAlign="top" colSpan="3" height="126"><!--DWLayoutEmptyCell--> &nbsp;</td>
							</tr>
						</table>
						<p>&nbsp;</p>
						<p>&nbsp;</p>
					</td>
				</tr>
			</table>
		</form>
	</body>
</HTML>
