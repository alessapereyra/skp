
$(document).ready(function(){

	$save = 1;


     $(':input',"form.quote_form").bind("change", function() { setConfirmUnload(true); }); // Prevent accidental navigation away


	$(".recover_results").slideUp();
	
	$("#down").click(function(){
		
		$(".recover_results").slideToggle();
		
	});

	$("div.subtotal.factura").css("visible","none");
	
	$("#options_current_store").change(function(){
		
		$(this).parents("form").submit();
		
	})
	
	$(".print").click(function(){
		
		window.print();
		return false;
		
	});
	
	$first = null;
	

	$.fn.clearForm = function() {
		return this.each(function() {
			var type = this.type, tag = this.tagName.toLowerCase();
			if (tag == 'form')
			return $(':input',this).clearForm();
			if (tag == 'fieldset'){
				return $(':input',this).clearForm();
			}
			if (type == 'text' || type == 'password' || tag == 'textarea')
			{
				if ($first == null) {$first = this; this.focus(); }
				this.value = '';
			}
			else if (type == 'checkbox' || type == 'radio')
			this.checked = false;
			
			if (tag == 'select')
			 {
				this.options.length = 0;
			}
			
			
		});
	};


	function formatItem(row) {
		return "<strong>"+row[1] + "</strong> - <strong class='em_code'>"+row[4] + "</strong> - <em class='em_code'>"+row[3]+"</em> - <em class='em_code'>"+row[2]+"</em> - Stock: "+ row[5];
	}

	function updatePrices(v){
	/*	$.ajax({data:'input_order_detail[product_id]='+v, success:function(request){$('#prices_list').html(request);}, url:'/buying_orders/last_input_orders'});*/d

	}
	

	function updatePriceList(v){
		
	/*	$.ajax({data:'order_detail[product_id]='+v, success:function(request){
			
			      var options = '';
			      for (var i = 0; i < request.length; i++) {
			        options += '<option value="' + request[i].amount + '">' + request[i].description + ':' + request[i].amount + '</option>';}
			
				$("#order_detail_price").html(options);
			
			
			}, url:'/sales/product_prices'});
*/

	$.getJSON("/sales/product_prices", {product_id:v}, function(request){
		
		 	var options = '';
	      	for (var i = 0; i < request.length; i++) {
	    //  	options += '<option value="' + request[i].amount + '">' + request[i]["description"] + ': S/.' +  request[i].amount + '</option>';}
//	   	options += '<option value="' + request[i].amount + '">' + 'S/.' +  request[i].amount + '</option>';}  //server
	 options += '<option value="' + request[i].price.amount + '">' + 'S/.' +  request[i].price.amount + '</option>';}
	
			$("#order_detail_price").html(options);		
			$("#exit_order_detail_price").html(options);		

				
		
	})

		
	}
	
	function getClientData(v){
		
		$("#quote_contact_name").val("");
		$("#quote_sending_details").val("");
		
		$.getJSON("/clientes/"+v, {id:v}, function(request){			
			$("#quote_contact_name").val(request.client.contact_person);
			$("#quote_sending_details").val(request.client.contact_email);
		})
		
		
	}
	

	
	
	function getProductData(v){
		
		$("input#input_order_detail_additional_code").val("");
		$("#buying_price").val(0);
		$("#base_price").val(0);
		$(".input_order_boxed_price").val(0);
		$(".input_order_wholesale_price").val(0);
		$(".input_order_final_price").val(0);									
		$(".input_order_final_price_polo").val(0);												
		$("#buying_price_bk").html(0);
		$("#base_price_bk").html(0);
		$("#boxed_price_bk").html(0);
		$("#wholesale_price_bk").html(0);
		$("#final_price_bk").html(0);									
		$("#final_price_polo_bk").html(0);												



		$.getJSON("/productos/"+v, {id:v}, function(request){
			
			$("input#input_order_detail_additional_code").val(request.additional_code);

			
		})


		$.getJSON("/productos/"+v+"/precios/", {product_id:v}, function(request){


			$("#buying_price").val(request[0]);
			$("#buying_price_bk").html(request[0]);

			$("#base_price").val(request[1][0].price.amount);
			$("#base_price_bk").html(request[1][0].price.amount);

			$(".input_order_boxed_price").val(request[1][1].price.amount);
			$("#boxed_price_bk").html(request[1][1].price.amount);

			$(".input_order_wholesale_price").val(request[1][2].price.amount);
			$("#wholesale_price_bk").html(request[1][2].price.amount);

			$(".input_order_final_price").val(request[1][3].price.amount);									
			$("#final_price_bk").html(request[1][3].price.amount);									

			$(".input_order_final_price_polo").val(request[1][4].price.amount);												
			$("#final_price_polo_bk").html(request[1][4].price.amount);												





		})
		
		$("input#input_order_detail_quantity").focus();
		
		
		
	}
	
	
	//Animaciòn Formulario
	$("#input_order_detail_product_id").focus(function(){ 
			
			documento = $("#input_order_document").attr("value");
			provider = $("#input_order_provider_id").attr("value");
			year = $("#input_order_order_date_1i").attr("value");
			month = $("#input_order_order_date_2i").attr("value");
			day = $("#input_order_order_date_3i").attr("value");
			store = $("#input_order_store_id").attr("value");
			owner = $("#input_order_owner_id").attr("value");

			$.ajax({data:'order[document]='+documento+'&'+
						'order[provider]='+provider+'&'+
						'order[order_date][year]='+year+'&'+
						'order[order_date][month]='+month+'&'+
						'order[order_date][day]='+day+'&'+
						'order[store_id]='+store+'&'+
						'order[owner_id]='+owner+'&'
						, url:'/buying_orders/update_order'});
	
	
		
		});
		
		
		//Animaciòn Formulario
		$("#exit_order_detail_product_id").focus(function(){ 

				documento = $("#exit_order_document").attr("value");
				year = $("#exit_order_sending_date_1i").attr("value");
				month = $("#exit_order_sending_date_2i").attr("value");
				day = $("#exit_order_sending_date_3i").attr("value");
				client_id = $(".exit_order_hidden_client_id").attr("value");
				driver_name = $("#exit_order_driver_name").attr("value");
				driver_dni = $("#exit_order_driver_dni").attr("value");				
				extra_data = $("#exit_order_extra_data").attr("value");				

				$.ajax({data:'exit_order[document]='+documento+'&'+
							'exit_order[sending_date][year]='+year+'&'+
							'exit_order[sending_date][month]='+month+'&'+
							'exit_order[sending_date][day]='+day+'&'+
							'exit_order[client_id]='+client_id+'&'+
							'exit_order[driver_name]='+driver_name+'&'+
							'exit_order[driver_dni]='+driver_dni+'&'+
							'exit_order[extra_data]='+extra_data
							, url:'/exit_orders/update_exit_order'});



			});
			
			
		
		$("a.sublink").click(function(){
			
			documento = $("#input_order_document").attr("value");
			input_type = $("#input_order_input_type").attr("value");
			provider = $("#input_order_provider_id").attr("value");
			year = $("#input_order_order_date_1i").attr("value");
			month = $("#input_order_order_date_2i").attr("value");
			day = $("#input_order_order_date_3i").attr("value");
			store = $("#input_order_store_id").attr("value");
			owner = $("#input_order_owner_id").attr("value");

			$.ajax({data:'order[document]='+documento+'&'+
						'order[provider]='+provider+'&'+
						'order[order_date][year]='+year+'&'+
						'order[order_date][month]='+month+'&'+
						'order[order_date][day]='+day+'&'+
						'order[order_date][day]='+day+'&'+						
						'order[store_id]='+store+'&'+
						'order[owner_id]='+owner+'&'
						, url:'/buying_orders/update_order',
						success: function(msg){

							window.location = "/inventory"
							return false;

						   }
						
						});
						
			return false;
			
		});
		
		
		
		
		//Animaciòn Formulario
		$("#quote_detail_product_id").focus(function(){ 

				documento = $("#quote_document").attr("value");
				client = $(".quote_hidden_client_id").attr("value");
				year = $("#quote_quote_date_1i").attr("value");
				month = $("#quote_quote_date_2i").attr("value");
				day = $("#quote_quote_date_3i").attr("value");
				price_type = $("#quote_price_type").attr("value");
				store = $("#quote_store_id").attr("value");
				duration = $("#quote_duration").attr("value");
				sending_details = $("#quote_sending_details").attr("value");
				contact_name = $("#quote_contact_name").attr("value");				
				quote_comments = $("#quote_quote_comments").attr("value");

				$.ajax({data:'quote[document]='+documento+'&'+
							'quote[client_id]='+client+'&'+
							'quote[quote_date][year]='+year+'&'+
							'quote[quote_date][month]='+month+'&'+
							'quote[quote_date][day]='+day+'&'+
							'quote[store_id]='+store+'&'+
							'quote[duration]='+duration+'&'+
							'quote[contact_name]='+contact_name+'&'+
							'quote[sending_details]='+sending_details+'&'+
							'quote[quote_comments]='+quote_comments+'&'+
							'quote[price_type]='+price_type
							, url:'/quotes/update_quote'});	

			});
		
		
		//Animaciòn Formulario
		$("#send_order_detail_product_id").focus(function(){ 

				documento = $("#send_order_document").attr("value");
				year = $("#send_order_send_date_1i").attr("value");
				month = $("#send_order_send_date_2i").attr("value");
				day = $("#send_order_send_date_3i").attr("value");
				store = $("#send_order_store_id").attr("value");
				owner = $("#send_order_owner_id").attr("value");

				$.ajax({data:'send_order[document]='+documento+'&'+
							'send_order[send_date][year]='+year+'&'+
							'send_order[send_date][month]='+month+'&'+
							'send_order[send_date][day]='+day+'&'+
							'send_order[store_id]='+store+'&'+
							'send_order[owner_id]='+owner+'&'
							, url:'/sending/update_send_order'});



			});
		
		
	

	function updateProductPrice(){
		
		$.ajax({data:'order_detail[product_id]='+v, success:function(request){$('#prices_list').html(request);}, url:'/sales/product_price'});

		
	}
	
	function getProductPricesForQuote(v){
		
		$.getJSON("/productos/"+v+"/precios/", {product_id:v}, function(request){


///*

			//$("#buying_price").val(request[0]);
			$("#base_price").html(request[1][0].price.amount);
			$("#boxed_price").html(request[1][1].price.amount);
			$("#wholesale_price").html(request[1][2].price.amount);
			$("#final_price").html(request[1][3].price.amount);									
			$("#final_price_polo").html(request[1][4].price.amount);												
//*/ //SE
/*
			//$("#buying_price").val(request[0]);
			$("#base_price").html(request[1][0].amount);
			$("#boxed_price").html(request[1][1].amount);
			$("#wholesale_price").html(request[1][2].amount);
			$("#final_price").html(request[1][3].amount);									
			$("#final_price_polo").html(request[1][4].amount);												
// SERVER
*/

		})
		
		$("input#quote_detail_quantity").focus();
	}

//Autosuggest
	$("input#input_order_detail_product_id").autocomplete("buying_orders/auto_complete_for_input_order", {  formatItem:formatItem, callbackFunction:getProductData, hidden_input:".input_order_detail_hidden_product_id" });	
	
	$("input#send_order_detail_product_id").autocomplete("buying_orders/auto_complete_for_input_order", {  
		formatItem:formatItem, hidden_input:".send_order_detail_hidden_product_id"}
	);	

	$("input#sending_guide_detail_product_id").autocomplete("buying_orders/auto_complete_for_input_order", {  
		formatItem:formatItem, hidden_input:".sending_guide_detail_hidden_product_id"}
	);	

//	$("input#exit_order_detail_product_id").autocomplete("/buying_orders/auto_complete_for_input_order", {  
//		formatItem:formatItem, callbackFunction:updatePriceList,hidden_input:".exit_order_detail_hidden_product_id"}
//	);	

	
//	$("input#order_detail_product_id").autocomplete("sales/auto_complete_for_input_order", {  
//		formatItem:formatItem, callbackFunction:updatePriceList, hidden_input: ".order_detail_hidden_product_id"
//		});	


$("input#exit_order_detail_product_id").keypress(function(event){
	
	
		$save = 0;		
		
	    if (event.which == 13) {

				$(".product_name").html("Buscando...");
				$(".product_stock").html("Buscando...");


				$.ajax({data:'order_detail[product_code]='+this.value, success:function(request){
					
					
					
				 	//$('#prices_list').html(request);
						result = request.split(",");
						updatePriceList(result[0]);			
						$(".exit_order_detail_hidden_product_id").val(result[0]);
						$(".product_name").html(result[1]);
						$(".product_stock").html(result[2]);
						$save = 1;
					}, error:function(request){
						
						$(".product_name").html("No se halló ningún producto");
						$(".product_stock").html("--");
						
						
					}, url:'/sales/auto_complete_for_input_order'}
					
					
					);



	    }
	
	
});


	$("input#order_detail_product_id").keypress(function(event){
		
		$save = 0;		
		
	    if (event.which == 13) {

				$(".product_name").html("Buscando...");
				$(".product_stock").html("Buscando...");


				$.ajax({data:'order_detail[product_code]='+this.value, success:function(request){
					
					
					
				 	//$('#prices_list').html(request);
						result = request.split(",");
						updatePriceList(result[0]);			
						$(".order_detail_hidden_product_id").val(result[0]);
						$(".product_name").html(result[1]);
						$(".product_stock").html(result[2]);
						$save = 1;
					}, error:function(request){
						
						$(".product_name").html("No se halló ningún producto");
						$(".product_stock").html("--");
						
						
					}, url:'/sales/auto_complete_for_input_order'}
					
					
					);



	    }
	});
	
	$("input#exit_order_detail_product_id").focus(function(){
		
		$save = 0;
		
	})
	
	$("input#exit_order_detail_product_id").blur(function(){
		
		$save = 1;
		
	})



	$("input#order_detail_product_id").focus(function(){
		
		$save = 0;
		
	})
	
	$("input#order_detail_product_id").blur(function(){
		
		$save = 1;
		
	})
	
	
	$("#exit_order_submit.form_button ").click(function(){		

		if 	($save == 1) {
			return confirm('¿Finalizar orden de envío?');
			}
			else			
			{				
				return false;
			}

	});	
	


	$("#order_submit.form_button ").click(function(){		

		if 	($save == 1) {
			return confirm('¿Finalizar venta?');
			}
			else			
			{				
				return false;
			}

	});	
	
	
		
	$("input#order_client_id").autocomplete("/sales/auto_complete_for_order", {  
		formatItem:formatItem, hidden_input:".order_hidden_client_id"});	

		$("input#sending_guide_client_id").autocomplete("/sales/auto_complete_for_order", {  
			formatItem:formatItem, hidden_input:".sending_guide_hidden_client_id"});	

	$("input#quote_client_id").autocomplete("/sales/auto_complete_for_order", {  
		formatItem:formatItem, hidden_input:".quote_hidden_client_id", callbackFunction:getClientData});	

	$("input#exit_order_client_id").autocomplete("/sales/auto_complete_for_order", {  
		formatItem:formatItem, hidden_input:".exit_order_hidden_client_id", callbackFunction:getClientData});	



		


		
//Cambio de Boleta - Factura - etc
$("a#boleta").click(function(){
	
	setup_boleta();
	getLastOrderByType("boleta");
});

$("a#factura").click(function(){

	setup_factura();
	getLastOrderByType("factura");	
});

$("a#nota_de_credito").click(function(){

	setup_nota_de_credito();
	getLastOrderByType("nota_de_credito");	
});
	

///// Actualización de Precios según elegido

$('input#buying_price').keyup(function(event){


	base = 1.10;
	boxed = 1.30;
	wholesale = 1.40;
	trigal = 1.50;
	polo = 1.60;


	category = $("#product_category_id").val()
	if ( category != "")
	{
			if (category == "11"){
				
				
				base = 1.03;
				boxed = 1.08;
				wholesale = 1.08;
				trigal = 1.25;
				polo = 0;

				
				
			}
			
		
	}
	
	subcategory = $("#product_subcategory_id").val()
	if ( subcategory != "")
	{
			if (subcategory == "10"){
				
				
				base = 1.03;
				boxed = 1.08;  
				wholesale = 1.25;
				trigal = 1.5;
				polo = 1.5;

				
				
			}
			
		
	}
	



	price_value = this.value / 1.19

  $("input#base_price").attr("value",roundNumber(price_value*base*1.19,2));
  $("input.input_order_boxed_price").attr("value",roundNumber(price_value*boxed*1.19,2));
  $("input.input_order_wholesale_price").attr("value",roundNumber(price_value*wholesale*1.19,2));
  $("input.input_order_final_price").attr("value",roundNumber(price_value*trigal*1.19,2));
 $("input.input_order_final_price_polo").attr("value",roundNumber(price_value*polo*1.19,2));	
	
});




$("#content").listen('focus','input, textarea, select',function(){ 

	$(this).addClass("active");

});	

$("#content").listen('blur','input, textarea, select', function(){

	$(this).removeClass("active");

});

$("#content table tbody tr").hover(function(){ 
	
	$(this).addClass("hover");
	
	},function(){
		
	$(this).removeClass("hover");
		
	})


});

$("img.product_image").hover(function(){ 
	
	$(this).parent('div').addClass("hover");
	
	},function(){
		
	$(this).parent('div').removeClass("hover");
		
	});


function clean_forms(){

	$('#fieldset_buying_orders').clearForm();
	$('#fieldset_sales').clearForm();	
	$('#fieldset_sending').clearForm();	

}

function setup_boleta(){
	
	$("#order_type").attr("value","boleta");
	$("a#boleta").parents("ul").find("a").each(function(){$(this).removeClass("active")})
	$("div#content h2").attr("innerHTML","Boleta de Venta")
	$("a#boleta").addClass("active");
	$("div.subtotal.factura").css("display","none");
	
}

function setup_factura(){
	
	
	$("a#factura").parents("ul").find("a").each(function(){$(this).removeClass("active")})
	$("#order_type").attr("value","factura");
	$("div#content h2").attr("innerHTML","Factura")
	$("a#factura").addClass("active");		
	$("div.subtotal.factura").css("display","block");	
}

function setup_nota_de_credito(){
	
	$("a#nota_de_credito").parents("ul").find("a").each(function(){$(this).removeClass("active")})	
	$("#order_type").attr("value","nota_de_credito");
	$("div#content h2").attr("innerHTML","Nota de cr&eacute;dito")
	$("a#nota_de_credito").addClass("active");	
	$("div.subtotal.factura").css("display","block");
	
}

function getLastOrderByType(type){
		$.ajax({data:'order[type]='+type, success:function(request){
		//	if ($("#order_number").val < request ){
				$("#order_number").attr("value",request);
		//		}
			}, 
			url:'/sales/last_order_number'});
	}
	

function roundNumber(rnum, rlength) { // Arguments: number to round, number of decimal places
  return Math.round(rnum*Math.pow(10,rlength))/Math.pow(10,rlength);
}

function setConfirmUnload(on) {
   
     window.onbeforeunload = (on) ? unloadMessage : null;

}

function unloadMessage() {
   
     return 'Aún no ha finalizado la cotización. Si cambia de pantalla podrá recuperarla luego en la zona superior.';

}
