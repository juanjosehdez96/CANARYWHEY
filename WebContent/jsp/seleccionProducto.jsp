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

	<header>
	
	<script>
	$(document).ready(function () {
		
		var boton = document.getElementById("btnCarrito");
		boton.style.display="block";
		
	});
		
	</script>
	
	
	 <!-- Navigation --> 
	 <nav
		class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container">
		<a class="navbar-brand" href="/CANARYWHEY/Servlet">BIENVENIDO:
			<%=user.toUpperCase()%></a> <a href="/CANARYWHEY/Servlet?action=Inicio">Cerrar
			sesion</a>
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
		<a class="navbar-brand" href="/CANARYWHEY/Servlet">BIENVENIDO
		</a>
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
		<h2>
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
	</div>

	<%
		String idProducto = request.getParameter("proId");
		Productos producto = (Productos) datos.get(Productos.class, Integer.parseInt(idProducto));

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
			<div>
				<button  style="display: none" class="btn btn-primary" id="btnCarrito"
					onclick="window.location.href='/CANARYWHEY/Servlet?action=Pedidos&proId=<%=idProducto%>'">Añadir
					al carro</button>
			</div>
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
