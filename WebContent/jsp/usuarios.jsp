<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>


<head>

<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/estilos.css">
<link href="css/bootstrap.min.css" rel="stylesheet">
<link
	href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css"
	rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<script src="js/popper.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/jquery.validate.min.js"></script>

</head>


<%
	HttpSession atrsesion = request.getSession();
	String user = (String) atrsesion.getAttribute("nombreDeUsuario");
	Session datos = HibernateUtil.getSessionFactory().openSession();

	ArrayList<Usuarios> usuarios = (ArrayList<Usuarios>) datos.createQuery("from Usuarios where rol!='Administrador'").list();

	pageContext.setAttribute("arrayUsuarios", usuarios);
%>

<body>
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
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
						<li class="nav-item active "><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=usuarios">Usuarios</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<div class="container">
		<table id="cart" class="table table-hover table-condensed">
			<thead>
				<tr>
					<th style="width: 10%" class="text-center">Foto</th>
					<th style="width: 20%" class="text-center">Nombre de usuario</th>
					<th style="width: 20%" class="text-center">Tipo de cuenta</th>
					<th style="width: 20%" class="text-center">Email</th>
					<th style="width: 20%" class="text-center">Fecha de nacimiento</th>
					<th style="width: 20%"></th>


				</tr>
			</thead>


			<c:forEach var="usuario" items="${arrayUsuarios}">

				<tbody>
					<tr>
						<td data-th="Product" style="padding: 1em">
							<div class="row">
								<div class="col-sm-2 hidden-xs">
									<img style="width: 110px" id="imagenCarro"
										src="imgsUsuarios/${usuario.nombreUsuario}.jpg" alt="..."
										class="img-responsive" />
								</div>
							</div>
						</td>
						<td class="text-center"><h4>${fn:toUpperCase(usuario.nombreUsuario)}</h4></td>
						<td class="text-center">${usuario.rol}</td>
						<td class="text-center" id="subtotal">${usuario.email}</td>
						<td class="text-center" id="subtotal">${usuario.fechaNacimiento}</td>

						<form action="Servlet?action=usuarios" method="post">
							<td class="actions" data-th=""><input type="hidden"
								name="borrarUsuario" value="${usuario.nombreUsuario}" />
								<button class="btn btn-danger btn-sm">
									<i class="fa fa-trash-o"></i>
								</button></td>
						</form>

					</tr>
				</tbody>


			</c:forEach>

			<tfoot>

				<tr>
					<td colspan="5" class="hidden-xs"></td>
					<td><a href="/CANARYWHEY/Servlet?action=Productos"
						class="btn btn-success btn-block">Atrás <i
							class="fa fa-angle-right"></i>
					</a></td>
				</tr>
			</tfoot>
		</table>
	</div>

</body>
</html>