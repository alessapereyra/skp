
$(document).ready(function(){


$(function () {
  $('#accordion').accordion({

		header: ".ui-accordion-header",
		clearStyle: false,
		autoheight: false,
	    fillSpace: true,
		navigation:false	    

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

--> //Acordeón


//$("#help_tip").css("opacity",0);

/*

$("#help").hover(function(){
	
	$("#help_tip").fadeTo("slow",0.9);
	$("#help_tip").css("left",$(this).left + 30);	
	
},function(){
	
	$("#help_tip").fadeTo("slow",0.0);
	$("#help_tip").css("left",$(this).left + 30);	
	
});


¿*/

$.facebox.settings.opacity = 0.7 
$.facebox.settings.overlay = true

$('a[rel*=facebox]').facebox({

	
}); 

$(document).bind('reveal.facebox', function() { setupZoom(); });

$("#help").mopTip({'w':160, 'h':290, 'style':"overOut", 'get':"#help_tip"});

$(".product").hover(function(){
	
	$(this).stop().animate({ "background-color": "#f9f88e" }, "slow");

	
},function(){
	
	$(this).stop().animate({ "background-color": "#FFF" }, "slow");
	
});


});

function statuspopup(product_id) {
  window.newwindow = window.open('/web/catalogo/'+product_id,'status',
                                 'height=400,width=200,status=no');
  return false;
}

function rebind_facebox(){
$.facebox.settings.opacity = 0.7 
$.facebox.settings.overlay = true

$('a[rel*=facebox]').facebox({

	
});
} 

$(document).bind('reveal.facebox', function() { setupZoom(); });
