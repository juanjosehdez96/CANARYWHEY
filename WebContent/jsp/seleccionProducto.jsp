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
		String imageURL = "imgsProductos/";

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
			<a href="#"> CATEGORÍAS</a>
		</h2>
		<ul>
			<%
				ArrayList<Categorias> arrayCategorias = (ArrayList<Categorias>) datos.createQuery("from Categorias").list();
				pageContext.setAttribute("arraycategorias", arrayCategorias);
			%>

			<c:forEach var="categorias" items="${arraycategorias}">
				<li><a
					href="/CANARYWHEY/Servlet?action=seleccionCategoria&id=${categorias.codigoCategoria}">
						${categorias.nombre} </a></li>

			</c:forEach>

		</ul>

		<form action="/CANARYWHEY/Servlet?action=Productos" method="post">
			<div class="col-lg-6" style="max-width: 100%">
				<div class="input-group">
					<input type="text" name="busqueda" class="form-control" /> <span
						class="input-group-btn">
						<button class="btn btn-primary" type="submit">Buscar</button>
					</span>
				</div>
			</div>
		</form>
	</div>

	<%
		int idProducto = Integer.parseInt(request.getParameter("proId"));
		Productos producto = (Productos) datos.get(Productos.class, idProducto);

		if (producto != null) {
	%>


	<div id="container">
		<div id="imagen">
			<img src="<%=(imageURL + idProducto)%>.jpg" />
		</div>
		<div id="precio">
			<div>
				<strong><%=producto.getNombre()%></strong>
			</div>
			<div>
				<p>
					Stock:
					<%=producto.getStock()%>&nbsp;Unidades
				</p>
			</div>
			<div>
				<p>
					Precio:
					<%=producto.getPrecio()%>&euro;
				</p>
			</div>
			<%
				if (user != null) {
			%>

			<form action="Servlet?action=Pedidos&proId=<%=idProducto%>"
				method="post">
				<div id="botonesProductos">
					<input type="submit" class="btn btn-primary"
						value="Añadir al carro" id="btnCarrito" name="btnCarrito" />

					<%
						Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);
								if (usuario.getRol().equals("Administrador")) {
					%>

					<input style="display: block; margin-top: 5%;" type="submit"
						class="btn btn-primary" value="Eliminar Producto"
						name="btnEliminar" /> <input
						style="display: block; margin-top: 5%;" type="button"
						class="btn btn-primary" value="Modificar Producto"
						onclick="window.location.href='/CANARYWHEY/Servlet?action=modificarProductos&proId=<%=idProducto%>';" />


					<input type="button" style="float: right; margin-left: 5%;"
						onclick="window.location.href='/CANARYWHEY/Servlet?action=Productos';"
						value="Volver" class="btn btn-primary" />
				</div>


				<%
					}
						}
				%>
			
		</div>
		</form>
	</div>
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

	<script src="js/popper.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>


</html>
