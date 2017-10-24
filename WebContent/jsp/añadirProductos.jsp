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
		<form action="Servlet?action=addProductos" method="post">

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
						<td><input type="text" /></td>
					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Categoría a la que pertenece:</td>
						<td><select>
								<%
									ArrayList<Categorias> arrayCategorias = (ArrayList<Categorias>) datos.createQuery("from Categorias").list();

									pageContext.setAttribute("arraycategorias", arrayCategorias);
								%>
								<c:forEach var="categorias" items="${arraycategorias}">

									<option>${categorias.nombre}</option>


								</c:forEach>

						</select></td>

					</tr>


					<tr>
						<th scope="row">3</th>
						<td>Precio:</td>
						<td><input type="text" /></td>

					</tr>
					<tr>
						<th scope="row">4</th>
						<td>Stock:</td>
						<td><input type="text" /></td>
					</tr>
				</tbody>
			</table>
			<input type="submit" style="margin-left: 30%" value="Guardar Cambios"
				name="guardarCambios" class="btn btn-primary" /> <input
				type="submit" style="margin-left: 20%" value="Volver" name="volver"
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