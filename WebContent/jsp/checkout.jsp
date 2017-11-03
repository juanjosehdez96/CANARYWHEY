<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList, modelo.Categorias, modelo.Productos"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<head>

<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/popper.js"></script>
<script src="js/jquery.validate.min.js"></script>
<link rel="stylesheet" href="css/estilos.css">


<script>

$(document).ready(function () {
	$("#btnGuardar").on("click", function() {
		
		 var nameregex = /^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+$/i;
		   
		   $.validator.addMethod("validname", function( value, element ) {
		       return this.optional( element ) || nameregex.test( value );
		   }); 
		   
		 
		   
		   
		   var useregex = /^[a-z\d_]{2,15}$/i;  


		   $.validator.addMethod("validuser", function( value, element ) {
		       return this.optional( element ) || useregex.test( value );
		   }); 
		   
		   var n_tarjeta = /^(?:4\d([\- ])?\d{6}\1\d{5}|(?:4\d{3}|5[1-5]\d{2}|6011)([\- ])?\d{4}\2\d{4}\2\d{4})$/i;
		   
		   $.validator.addMethod("validtarjeta", function( value, element ) {
		       return this.optional( element ) || n_tarjeta.test( value );
		   }); 
		   
		   var codigoPostal = /^(5[0-2]|[0-4][0-9])[0-9]{3}$/i;

		   $.validator.addMethod("validcodigo", function( value, element ) {
		       return this.optional( element ) || codigoPostal.test( value );
		   });
		   
		   // valid email pattern
		   var eregex = /^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})$/i;

		   
		   $.validator.addMethod("validemail", function( value, element ) {
		       return this.optional( element ) || eregex.test( value );
		   });
	   
	   $("#formulario").validate({
		   
		   errorClass: "my-error-class",
		   validClass: "my-valid-class",
		    
		    rules: {
		        nombre: {  required: true, validname: true},
		        apellidos: {  required: true, validname: true},
		        direccion: { required: true, validname:true},
		        ciudad: { required:true, validname: true},
		        codigoPostal: { required:true, validcodigo: true},
		        telefono: {required: true, digits: true},
		        email: { required:true, validemail:true},
		        tarjeta: { required:true, validtarjeta:true}
		      
		       
		    },
		    messages: {
		        nombre: "Nombre no válido.",
		        apellidos: "Apellidos no válidos",
		        direccion: "Introduzca una dirección válida.",
		        ciudad: "Introduzca una ciudad válida.",
		        codigoPostal: "Código postal incorrecto.",
		        telefono: "Número de teléfono incorrecto",
		        email: "Formato no válido.",
		        tarjeta: "Formato incorrecto."
		      
		        
		    
		    }});  
		
		});

});


</script>

</head>
<body>

	<%
		HttpSession atrsesion = request.getSession();
			String user = (String) atrsesion.getAttribute("nombreDeUsuario");

		Session datos = HibernateUtil.getSessionFactory().openSession();
		Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);
	%>

	<header>
		<!-- Navigation -->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
			<div class="container">
				<a class="navbar-brand"
					href="/CANARYWHEY/Servlet?action=InicioSesion">BIENVENIDO: <%=user.toUpperCase()%></a>
				<a href="/CANARYWHEY/Servlet?action=Inicio">Cerrar sesion</a>
				<button class="navbar-toggler" type="button" data-toggle="collapse"
					data-target="#navbarResponsive" aria-controls="navbarResponsive"
					aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarResponsive">
					<ul class="navbar-nav ml-auto">
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet">Inicio</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Cuenta">Mi cuenta <span
								class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item active"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=misPedidos">Mis Pedidos</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<div id="table" class="table-editable" style="width: 100%;">
		<form action="Servlet?action=addProductos" method="post" enctype="multipart/form-data" id="formulario">

			<span class="table-add glyphicon glyphicon-plus"></span>
			<table class="table">
				<thead>
					<tr>
						<th style="padding-left: 10%" colspan="3">INFORMACIÓN
							PERSONAL</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row">1</th>
						<td>Nombre</td>
						<td><input type="text" name="nombre" /></td>
					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Apellidos</td>
						<td><input type="text" name="apellidos" /></td>
					</tr>
					<tr>
						<th scope="row">3</th>
						<td>Direccion:</td>
						<td><input type="text" name="direccion" /></td>
					</tr>

					<tr>
						<th scope="row">4</th>
						<td>Ciudad:</td>
						<td><input type="text" name="ciudad"/></td>

					</tr>
					
					<tr>
						<th scope="row">5</th>
						<td>Teléfono:</td>
						<td><input type="text" name="telefono"/></td>

					</tr>
					<tr>
						<th scope="row">6</th>
						<td>Codigo postal:</td>
						<td><input type="text" name="codigoPostal"/></td>
					</tr>

					<tr>
						<th scope="row">7</th>
						<td>Correo electrónico:</td>
						<td><input type="text" name="email"/></td>
					</tr>
					
					<tr>
						<th scope="row">8</th>
						<td>Número de tarjeta:</td>
						<td><input type="text" name="tarjeta"/></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" style="margin-left: 30%" value="Guardar Cambios"
				name="guardarProductos" class="btn btn-primary" id="btnGuardar"/> 
				<input	type="submit" style="margin-left: 20%" value="Volver" name="volver" 
				class="btn btn-primary" />

		</form>
	</div>



	<footer>
		<div id="footer">
			<div class="container">
				<p class="footertext text-center">Copyright &copy; Canarywhey
					2017</p>
			</div>
		</div>
	</footer>

	<script src="js/index.js"></script>
</body>


</html>