<%@ Page CodeBehind="detalle_articulo.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="WebSkyKids.detalle_articulo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
	<HEAD>
		<title><%getNombre();%></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<style type="text/css"> <!-- body { margin-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; }
	.Estilo16 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; }
	.Estilo30 { font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; font-size: 14px; color: #003399; }
	.Estilo31 {font-size: 10px; color: #0033CC; font-family: Verdana, Arial, Helvetica, sans-serif;}
	.Estilo33 {font-size: 10px; color: #333333; font-family: Verdana, Arial, Helvetica, sans-serif; }
	.Estilo34 {color: #333333}
	--></style>
	</HEAD>
	<body>
		<table width="113" border="0" cellpadding="0" cellspacing="0">
			<!--DWLayoutTable-->
			<tr>
				<td width="113" height="39" align="left" valign="top" bgcolor="#006699"><table width="719" height="491" border="0" cellspacing="1">
						<tr>
							<td width="98" height="28" background="gif/fondo_window_detalle.gif" bgcolor="#ffcc00"><table width="98" border="0" cellspacing="1">
									<tr>
										<td width="79" align="center" class="Estilo16">Producto</td>
										<td width="12"><img src="gif/row_space.gif" width="14" height="21"></td>
									</tr>
								</table>
							</td>
							<td width="98" background="gif/fondo_window_detalle.gif" bgcolor="#ffcc00"><table width="98" border="0" cellspacing="1">
									<tr>
										<td width="79" align="center" class="Estilo16"><%getCategoria();%></td>
										<td width="12"><img src="gif/row_space.gif" width="14" height="21"></td>
									</tr>
								</table>
							</td>
							<td width="98" background="gif/fondo_window_detalle.gif" bgcolor="#ffcc00"><table width="98" border="0" cellspacing="1">
									<tr>
										<td width="79" align="center" class="Estilo16"><%getCodigo();%></td>
										<td width="12"><img src="gif/row_space.gif" width="14" height="21"></td>
									</tr>
								</table>
							</td>
							<td width="120" background="gif/fondo_window_detalle.gif" bgcolor="#ffcc00"><table width="98" border="0" cellspacing="1">
									<tr>
										<td width="79" align="center" class="Estilo16">Info</td>
										<td width="12"><img src="gif/row_space.gif" width="14" height="21"></td>
									</tr>
								</table>
							</td>
							<td colspan="3" background="gif/fondo_window_detalle.gif" bgcolor="#ffcc00">&nbsp;</td>
						</tr>
						<tr>
							<td height="440" colspan="4" align="center" valign="middle" bgcolor="#ffffff"><img width="398" height="415" id="IMG1" runat="server"></td>
							<td width="289" colspan="3" bgcolor="#ffffff"><table width="287" border="0" align="center" cellspacing="1">
									<tr>
										<td width="13" align="center" valign="middle"><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td colspan="3" align="center" valign="middle" background="gif/fondo_window_detalle.gif"><span class="Estilo30">DETALLE</span></td>
										<td width="15" align="center" valign="middle"><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td colspan="3">&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td width="15"><img src="gif/row_space.gif" width="14" height="21"></td>
										<td width="69" align="right" valign="middle" class="Estilo31">Codigo:</td>
										<td width="159" align="left" valign="middle"><label class="Estilo33"><%getCodigo();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle"><span class="Estilo34"></span></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td><img src="gif/row_space.gif" width="14" height="21"></td>
										<td align="right" valign="middle"><span class="Estilo31">Nombre:</span></td>
										<td align="left" valign="middle"><label class="Estilo33"><%getNombre();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle">&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td><img src="gif/row_space.gif" width="14" height="21"></td>
										<td align="right" valign="middle"><span class="Estilo31">Precio:</span></td>
										<td align="left" valign="middle"><label class="Estilo33"><%getPrecio();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle"><span class="Estilo34"></span></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td><img src="gif/row_space.gif" width="14" height="21"></td>
										<td align="right" valign="middle"><span class="Estilo31">Edad:</span></td>
										<td align="left" valign="middle"><label class="Estilo33"><%getSubCategoria();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle"><span class="Estilo34"></span></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td><img src="gif/row_space.gif" width="14" height="21"></td>
										<td align="right" valign="middle"><span class="Estilo31">Dimension:</span></td>
										<td align="left" valign="middle"><label class="Estilo33"><%getDimensiones();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle"><span class="Estilo34"></span></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td><img src="gif/row_space.gif" width="14" height="21"></td>
										<td align="right" valign="middle"><span class="Estilo31">Mas Info:</span></td>
										<td align="left" valign="middle"><label class="Estilo33"><%getInformacion();%></label>
											&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td>&nbsp;</td>
										<td align="right" valign="middle">&nbsp;</td>
										<td align="left" valign="middle"><span class="Estilo34"></span></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td height="23"><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td colspan="3"><img src="gif/space_tabla_img_cat.gif" width="248" height="21"></td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
									<tr>
										<td height="23"><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
										<td colspan="3" background="gif/fondo_window_detalle.gif">&nbsp;</td>
										<td><img src="gif/space_tabla_img_cat.gif" width="13" height="21"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td height="22" colspan="4" background="gif/fondo_window_detalle_green.gif">&nbsp;</td>
							<td background="gif/fondo_window_detalle_green.gif">&nbsp;</td>
							<td align="center" background="gif/fondo_window_detalle_green.gif"><table width="74" height="23" border="0" cellspacing="1">
									<tr>
										<td width="48" height="22"><a href="javascript:close()"><img src="gif/bot_cerrar.gif" width="70" height="21" border="0"></a></td>
									</tr>
								</table>
							</td>
							<td background="gif/fondo_window_detalle_green.gif">&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
</HTML>
