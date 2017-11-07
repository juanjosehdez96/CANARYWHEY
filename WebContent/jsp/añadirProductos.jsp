<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList, modelo.Categorias, modelo.Productos"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
	$(document).ready(function() {
		$("#btnGuardar").on("click", function() {

			// name validation
			var nameregex = /^[a-z\d_\d-]{2,15}$/i;

			$.validator.addMethod("validname", function(value, element) {
				return this.optional(element) || nameregex.test(value);
			});

			$("#formulario").validate({

				errorClass : "my-error-class",
				validClass : "my-valid-class",

				rules : {
					nombre : {
						required : true,
						validname : true
					},
					precio : {
						required : true,
						digits : true
					},
					stock : {
						required : true,
						digits : true
					},
					file : {
						required : true,
						extension : "jpg|png"
					}

				},
				messages : {
					nombre : "Nombre no válido.",
					precio : "Introduzca valor numérico.",
					stock : "Introduzca valor numérico.",
					file : "Tipo de archivo no válido."

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
						<li class="nav-item "><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=usuarios">Usuarios</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<div id="table" class="table-editable" style="width: 100%;">
		<form action="Servlet?action=addProductos" method="post"
			enctype="multipart/form-data" id="formulario">

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
						<td>Nombre del producto:</td>
						<td><input type="text" name="nombre" /></td>
					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Categoría a la que pertenece:</td>
						<td><select name="nombreCategoria">
								<%
									ArrayList<Categorias> arrayCategorias = (ArrayList<Categorias>) datos.createQuery("from Categorias").list();

									pageContext.setAttribute("arraycategorias", arrayCategorias);
								%>
								<c:forEach var="categorias" items="${arraycategorias}">

									<option value="${categorias.codigoCategoria}">${categorias.nombre}</option>


								</c:forEach>

						</select></td>

					</tr>


					<tr>
						<th scope="row">3</th>
						<td>Precio:</td>
						<td><input type="text" name="precio" /></td>

					</tr>
					<tr>
						<th scope="row">4</th>
						<td>Unidades disponibles:</td>
						<td><input type="text" name="stock" /></td>
					</tr>

					<tr>
						<th scope="row">5</th>
						<td>Imagen:</td>
						<td><input type="file" name="file" accept="image/*" /></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" style="margin-left: 30%" value="Guardar Cambios"
				name="guardarProductos" class="btn btn-primary" id="btnGuardar" />
			<input type="submit" style="margin-left: 20%" value="Volver"
				name="volver"
				onclick="window.location.href='/CANARYWHEY/Servlet?action=Productos';"
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