$(document).ready(function() {
	$('#boton').click(function() {
		$.getJSON('http://localhost:3000/contribuyentes/348270.json', function(response) { 
			console.log(response)
			$("#idRutEmisor").css("display", "block");
			$("#compmanual_rutemisor").val(response.rut);
			$("#idRznSocEmisor").css("display", "block");
			$("#compmanual_rznsocemisor").val(response.nombre);
		});
	});
});

