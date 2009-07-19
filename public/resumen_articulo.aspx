<%@ Page language="c#" Codebehind="resumen_articulo.aspx.cs" AutoEventWireup="false" Inherits="WebSkyKids.resumen_articulo" %>
<td height="172" width="300">
	<table cellSpacing="1" width="310" border="0">
		<!--DWLayoutTable-->
		<tr>
			<td vAlign="middle" align="left" bgColor="#ffffff" colSpan="3"><span class="Estilo12">Nombre:</span></td>
			<td width="13" bgColor="#ffffff"><IMG height="21" src="gif/space_tabla_img_cat.gif" width="13"></td>
			<td vAlign="top" align="left" width="153" bgColor="#cdcdcd" rowSpan="7"><IMG height="166" src="gif/img_cat_chico.gif" width="159"></td>
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
				<div align="left"><IMG id="IMG1" height="21" src="gif/boton_masinfo_02.gif" width="159" runat="server"></div>
			</td>
		</tr>
	</table>
</td>
