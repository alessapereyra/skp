<%@ Page CodeBehind="detalle_catalogo.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="WebSkyKids.detalle_catalogo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
	<HEAD>
		<title>Detalle Catálogo</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<style type="text/css"> <!-- body { background-image: url(); margin-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; background-repeat: repeat; }
	.Estilo12 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #0033CC; font-weight: bold; }
	.Estilo13 { font-size: 10px; font-weight: bold; font-family: Verdana, Arial, Helvetica, sans-serif; color: #FF9900; }
	.Estilo16 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; }
	.Estilo22 { font-size: 12px; color: #FF0000; }
	.Estilo23 { font-size: 10px; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; }
	.Estilo25 {font-size: 10px; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-weight: bold; }
	.Estilo9 { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; color: #FF0000; font-weight: bold; }
	.Estilo26 { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: normal; }
	.Estilo27 {color: #FF0000}
	--></style>
		<script language="JavaScript">
		
function openwin(URL) 
{
	window.open(URL,"Detalles","height=550,width=750,status=0,menubar=0,scrollbars=1"); 
}

function opendlgwin(URL)
{
	win = window.open(URL,"Articulo","height=550,width=740,status=0,menubar=0,scrollbars=1"); 
	win.focus();
}

function openmodalwin(URL)
{	
	window.showModalDialog(URL,"","dialogHeight: 550px; dialogWidth: 740px; dialogTop: 0; dialogLeft: 0; edge: Raised; center: Yes; help: Yes; resizable: Yes; status: No;");
}

function showInfo(id)
{
    opendlgwin('detalle_articulo.aspx?id=' + id);
}

function mouseOver(SENDER)
{
	SENDER.style.cursor='hand';
	SENDER.border = 1;
}
function mouseOut(SENDER)
{
	SENDER.border = 0;
}
		</script>
	</HEAD>
	<body>
		<table width="600" height="423" border="0" bgcolor="#ffffff">
			<!--DWLayoutTable-->
			<tr>
				<th colspan="2" bgcolor="#ffffff">
					<table width="300" border="0" cellspacing="1">
						<tr>
							<td>&nbsp;</td>
							<td align="center" valign="middle" class="Estilo26">
								<%getIndices();%>
							</td>
							<td ></td>
						</tr>
						<tr>
							<td align="left" valign="middle" class="Estilo26">
								pag.&nbsp;<b><%getNumPag();%></b>&nbsp;de&nbsp;<%getCantPag();%>
							</td>
							<td colspan=2 align="right" valign="middle" class="Estilo26">
								Total Encontrados:&nbsp;<%getCantArticulos();%>
							</td>
						</tr>
					</table>
				</TD>
			</tr>
			<tr>
				<%for (int i=IdIni(); i!=IdFin(); i++)
			  { setArticulo(i);%>
				<td height="172" width="300">
					<table cellSpacing="1" width="310" border="0">
						<!--DWLayoutTable-->
						<tr>
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><span class="Estilo12">Nombre:</span></td>
							<td width="13" bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
							<td vAlign="top" align="left" width="153" bgColor="#cdcdcd" rowSpan="7"><%getImagen();%></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><label><span class="Estilo23"><%getNombre();%></span>
								</label></td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><label><span class="Estilo25"><%getMarca();%></span>
								</label>&nbsp;</td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><span class="Estilo9">Precio:</span></td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" width="20" bgColor="#ffffff"><span class="Estilo9">S/.</span></td>
							<td vAlign="middle" align="left" width="4" bgColor="#ffffff">&nbsp;</td>
							<td class="Estilo16" vAlign="middle" align="left" width="104" bgColor="#ffffff"><label><span class="Estilo22"><%getPrecio();%></span>
								</label></td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><span class="Estilo13">Cod:</span></td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr bgColor="#6699ff">
							<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><label><span class="Estilo23"><%getCodigo();%></span>
								</label>&nbsp;</td>
							<td bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
						</tr>
						<tr>
							<td bgColor="#ffffff" colSpan="4" height="23">
								<div align="right"><IMG height="21" src="gif/boton_cotizar_02.gif" width="148"></div>
							</td>
							<td bgColor="#ffffff">
								<div align="left">
									<%getInfo();%>
									<IMG id="IMG1" src="gif\boton_masinfo_01.gif"></A>
								</div>
							</td>
						</tr>
					</table>
				</td>
				<%} getFinTabla();%>
			</tr>
			<tr>
				<th colspan="2" bgcolor="#ffffff">
					<table width="300" border="0" cellspacing="1">
						<tr>
							<td width="96">&nbsp;</td>
							<td width="96" align="center" valign="middle" class="Estilo26">
								<%getIndices();%>
							</td>
							<td width="98">&nbsp;</td>
						</tr>
					</table>
				</TD>
			</tr>
		</table>
	</body>
</HTML>
