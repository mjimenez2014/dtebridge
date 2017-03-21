$(document).ready(function(){
	$('#boton').click(function(){
		var url1 = 'http://localhost:3000/contribuyentes/busca_por_rut?utf8=%E2%9C%93&rut=';
		var url2 = $("#recipient-name").val();
		var url3 = '&commit=buscar'

		$.getJSON(url1+url2+url3, function(response) { 
			$("#idRutEmisor").css("display", "block");
			$("#compmanual_rutemisor").val(response.rut);
			$("#idRznSocEmisor").css("display", "block");
			$("#compmanual_rznsocemisor").val(response.nombre);
		});
	});

	$("#busca_cliente").click(function(){
        //alert("Focus");
        $('#recipient-name').focus();				
    });
});

