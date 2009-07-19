$(document).ready(function(){


	$("#header h1 a, #header h2, li#catalogo a, li#conocenos a, li#servicios a, li#contactanos a, em#help, div#inside_content h1#catalogo, div.separator, div#help_tip, td.bl, td.br, td.tl, td.tr, img.close_image, div.store, div.map a img").pngfix();



	$(function () {
	  $('#accordion').accordion({

			header: ".ui-accordion-header",
			clearStyle: true,
			autoheight: true,
		    fillSpace: false,
			navigation:true	    
	  });
	});

	$('#stores').flash(
	      { src: '../images/web/tiendas.swf',
	        width: 400,
	        height: 200 }
	  );

	$('#importacion').flash(
	      { src: '../images/web/importacion.swf',
	        width: 400,
	        height: 200 }
	  );
	
	$('#promocion_justimeano').flash(
	      { src: '../images/web/ad.swf',
	        width: 500,
	        height: 70 }
	  );

	$('#campana_escolar').flash(
	      { src: '../images/web/campana_escolar.swf',
	        width: 500,
	        height: 70 }
	  );
	
	$.facebox.settings.opacity = 0.7 
	$.facebox.settings.overlay = true

	$('a[rel*=facebox]').facebox({





	}); 

$(document).bind('reveal.facebox', function() { 
	
	setupZoom(); 
	
	$("#header h1 a, #header h2, li#catalogo a, li#conocenos a, li#servicios a, li#contactanos a, em#help, div#inside_content h1#catalogo, div.separator, div#help_tip, td.bl, td.br, td.tl, td.tr, img.close_image").pngfix();

	
	});

$("#help").mopTip({'w':160, 'h':290, 'style':"overOut", 'get':"#help_tip"});


$(".product").hover(function(){
	
	$(this).css("background-color","#f9f88e");	
},function(){
	
	$(this).css("background-color","#ffffff");
	
});

});


function rebind_facebox(){
$.facebox.settings.opacity = 0.7 
$.facebox.settings.overlay = true

$('a[rel*=facebox]').facebox({

	
});
}

$(document).bind('reveal.facebox', function() { 
	
	setupZoom(); 
		$("#header h1 a, #header h2, li#catalogo a, li#conocenos a, li#servicios a, li#contactanos a, em#help, div#inside_content h1#catalogo, div.separator, div#help_tip, td.bl, td.br, td.tl, td.tr, img.close_image").pngfix();
	
	});

 



