$('#botonImp').click(function(ev){
	ev.stopImmediatePropagation()
	ev.preventDefault()
	var url1 = 'http://localhost:3000/impuestos/';
	var url2 = $("#recipient-name").val();
	$.getJSON(url1+url2, function(response) { 
		$("#idRutEmisor").css("display", "block");
		$("#compmanual_rutemisor").val(response.rut);

	});
});

$("#bus").click(function(){ // bind a function to the change event  
    var idImpuesto = "";
    for (var i = 1; i < 8; i++) {
	   if($('#radioID' + i).is(':checked')) {
	      idImpuesto = $('#radioID'+ i).val(); 
	    }
	}
    var url1 = 'http://localhost:3000/impuestos/';
	var url2 = idImpuesto;
	$.getJSON(url1+url2, function(response) { 
	   $("#labelNomImp").text("Nombre: "+response.name);	
       $("#otrosimpcompmanual_TipoImp").val(response.tipoimp);
       $("#labelTipoImp").text("Codigo Impuesto: "+response.tipoimp);      
       $("#otrosimpcompmanual_TasaImp").val(response.tasaimp);
       $("#labelTasaImp").text("Tasa Impuesto: " + response.tasaimp + " %");       
       $("#MontoImp").css("display", "block");
       $("#btAgregarOtrosImp").css("display", "block");     
       $("#otrosimpcompmanual_MontoImp").focus();
       console.log(response);      
	});

});

 