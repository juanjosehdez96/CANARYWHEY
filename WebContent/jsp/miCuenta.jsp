<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.io.File;"%>
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
		pageContext.setAttribute("user", user);

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
						<li class="nav-item active"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Cuenta">Mi cuenta <span
								class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=misPedidos">Mis Pedidos</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<div id="table" class="table-editable">
		<form action="Servlet?action=Cuenta" method="post">

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
						<td>Nombre de usuario:</td>
						<td><%=usuario.getNombreUsuario()%></td>
					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Nombre:</td>
						<td><%=usuario.getNombre()%></td>

					</tr>
					<tr>
						<th scope="row">3</th>
						<td>Apellidos:</td>
						<td><%=usuario.getApellidos()%></td>

					</tr>
					<tr>
						<th scope="row">4</th>
						<td>Contraseña:</td>
						<td><%=usuario.getContraseña()%></td>

					</tr>
					<tr>
						<th scope="row">5</th>
						<td>Correo electrónico:</td>
						<td><%=usuario.getEmail()%></td>

					</tr>
					<tr>
						<th scope="row">6</th>
						<td>Fecha de nacimiento:</td>
						<td><%=usuario.getFechaNacimiento()%></td>

					</tr>
					<tr>
						<th scope="row">7</th>
						<td>Tipo de cuenta:</td>
						<td><%=usuario.getRol()%></td>
					</tr>
				</tbody>
			</table>
			<button style="margin-left: 10%" name="modificar"
				class="btn btn-primary">Modificar</button>
			<button style="margin-left: 30%" name="borrarCuenta"
				class="btn btn-primary">Eliminar Cuenta</button>


		</form>
	</div>

	<%	
		File file = new File("C://Users/Juan José/git/CANARYWHEY/WebContent/imgsUsuarios", user + ".jpg");
		if (!file.exists()) {
	%>
	<div id="imagenUsuario">
		<img src="imgsUsuarios/0.jpg" />
	</div>

	<%
		} else {
	%>

	<div id="imagenUsuario">
		<img src="imgsUsuarios/${user}.jpg" />
	</div>

	<%
		}
	%>


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