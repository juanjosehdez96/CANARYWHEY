<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session"%>
<head>

<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/estilos.css">
<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/popper.js"></script>
<script src="js/jquery.validate.min.js"></script>


<script>
	$(document)
			.ready(
					function() {
						$("#btnGuardar")
								.on(
										"click",
										function() {

											// name validation
											var nameregex = /^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+$/i;

											$.validator
													.addMethod(
															"validname",
															function(value,
																	element) {
																return this
																		.optional(element)
																		|| nameregex
																				.test(value);
															});

											$("#formulario")
													.validate(
															{

																errorClass : "my-error-class",
																validClass : "my-valid-class",

																rules : {
																	nombreCategoria : {
																		required : true,
																		validname : true
																	}

																},
																messages : {
																	nombreCategoria : "Nombre no válido."

																}
															});

										});

					});
</script>


</head>
<body>

	<%
		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
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
						<li class="nav-item "><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=usuarios">Usuarios</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<div id="table" class="table-editable" style="width: 100%;">
		<form action="Servlet?action=addCategorias" method="post"
			id="formulario">

			<span class="table-add glyphicon glyphicon-plus"></span>
			<table class="table">
				<thead>
					<tr>
						<th style="padding-left: 10%" colspan="3">AÑADIR CATEGORÍAS</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row">1</th>
						<td>Nombre de categoría</td>
						<td><input type="text" name="nombreCategoria" /></td>
					</tr>

				</tbody>
			</table>

			<input type="submit" style="margin-left: 30%" value="Guardar Cambios"
				id="btnGuardar" name="guardarCategorias" class="btn btn-primary" />
			<button type="submit" style="margin-left: 20%;" name="volver"
				onclick="window.location.href='/CANARYWHEY/Servlet?action=Productos';"
				class="btn btn-primary">Volver</button>
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