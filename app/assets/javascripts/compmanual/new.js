$(document).ready(function(){
	$("#recipient-name").focus();
});

$('#boton').click(function(ev){
	ev.stopImmediatePropagation()
	ev.preventDefault()
	var url1 = 'http://localhost:3000/contribuyentes/busca_por_rut?utf8=%E2%9C%93&rut=';
	var url2 = $("#recipient-name").val();
	var url3 = '&commit=buscar'
	$.getJSON(url1+url2+url3, function(response) { 
		$("#RutCliente").text("Rut:  " + response.rut);
		$("#RzsCliente").text("Razón Social: " + response.nombre);		
		//$("#idRutEmisor").css("display", "block");
		$("#compmanual_rutemisor").val(response.rut);
		//$("#idRznSocEmisor").css("display", "block");
		$("#compmanual_rznsocemisor").val(response.nombre);
	});
	$("#recipient-name").val(""); 
	$("#compmanual_tipodoc").focus();
});

