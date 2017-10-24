<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList, modelo.Categorias, modelo.Productos"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" href="css/estilos.css">



</head>
<body>



	<%
		HttpSession atrsesion = request.getSession();

		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session datos = HibernateUtil.getSessionFactory().openSession();
		String idCategoria = request.getParameter("id");

		if (user != null) {

			Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);
	%>

	<header> <!-- Navigation --> <nav
		class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container">
		<a class="navbar-brand" href="/CANARYWHEY/Servlet">BIENVENIDO: <%=user.toUpperCase()%></a>
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
					href="/CANARYWHEY/Servlet?action=Cuenta">Mi cuenta </a></li>
				<li class="nav-item active"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=Productos">Productos<span
						class="sr-only">(current)</span></a></li>
				<li class="nav-item"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=misPedidos">Mis Pedidos</a></li>
			</ul>
		</div>
	</div>
	</nav> </header>
	<%
		if (usuario.getRol().equals("Administrador")) {
	%>

	<form action="/CANARYWHEY/Servlet?action=addCategorias" method="post">
		<input class="btn btn-primary" type="submit" name="crearPCategoria" value="A�adir Categorias"
			style="margin-top: 7%; float: left; margin-left: 20%; position: absolute;" />
	</form>

	<form action="/CANARYWHEY/Servlet?action=addProductos" method="post">
		<input class="btn btn-primary" type="submit" name="crearProducto" value="A�adir Productos"
			id="a�adirProductos"
			style="margin-top: 7%; float: left; margin-left: 79%; position: absolute;" />
	</form>
	
	<%
		}

		} else {
	%>
	<header> <!-- Navigation --> <nav
		class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container">
		<a class="navbar-brand" href="/CANARYWHEY/Servlet">BIENVENIDO </a>
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
					href="/CANARYWHEY/Servlet?action=Acceder">Acceder</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=Productos">Productos<span
						class="sr-only">(current)</span></a></li>
			</ul>
		</div>
	</div>
	</nav> </header>
	<%
		}
	%>
	<!-- Sidebar -->
	<div id="barraizquierda">

		<h2 style="text-align: center;">
			<a href="#"> CATEGOR�AS</a>
		</h2>
		<ul>
			<%
				ArrayList<Categorias> arrayCategorias = new ArrayList<Categorias>();

				if (arrayCategorias != null) {
					arrayCategorias = (ArrayList<Categorias>) datos.createQuery("from Categorias").list();
					pageContext.setAttribute("arraycategorias", arrayCategorias);
			%>

			<c:forEach var="categorias" items="${arraycategorias}">
				<li><a
					href="/CANARYWHEY/Servlet?action=seleccionCategoria&id=${categorias.codigoCategoria}">
						${categorias.nombre} </a></li>

			</c:forEach>

		</ul>
	</div>

	<%
		}

		ArrayList<Productos> productos = new ArrayList<Productos>();
		if (idCategoria != null) {
			productos = (ArrayList<Productos>) datos
					.createQuery("from Productos where codigo_categoria=" + idCategoria).list();
			pageContext.setAttribute("arrayProductos", productos);
		}
		if (productos != null && idCategoria != null) {
	%>
	<div id="muestraProductos">
		<h2>PRODUCTOS</h2>


		<c:forEach var="producto" items="${arrayProductos}">
			<div class="productos">
				<a
					href="/CANARYWHEY/Servlet?action=seleccionProductos&proId=${producto.codigoProducto}">
					<img src="imgsProductos/${producto.codigoProducto}.jpg">
				</a><br />
				<div>${producto.nombre}</div>
				<div>${producto.precio}&euro;</div>
			</div>
		</c:forEach>
	</div>

	<%
		} else {
			productos = (ArrayList<Productos>) datos.createQuery("from Productos").list();
			pageContext.setAttribute("arrayProductos", productos);
	%>
	<div id="muestraProductos">
		<h2>PRODUCTOS</h2>
		<c:forEach var="producto" items="${arrayProductos}">
			<div class="productos">
				<a
					href="/CANARYWHEY/Servlet?action=seleccionProductos&proId=${producto.codigoProducto}">
					<img src="imgsProductos/${producto.codigoProducto}.jpg">
				</a><br />
				<div>${producto.nombre}</div>
				<div>${producto.precio}&euro;</div>
			</div>
		</c:forEach>

		<%
			}
		%>


	</div>


	<footer>
	<div id="footer">
		<div class="container">
			<p class="footertext text-center">Copyright &copy; Canarywhey
				2017</p>
		</div>
	</div>
	</footer>

	<script src="js/popper.js"></script>
	<script src="js/bootstrap.min.js"></script>

</body>


</html>
