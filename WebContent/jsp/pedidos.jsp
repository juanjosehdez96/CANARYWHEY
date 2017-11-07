<%@page
	import="com.sun.org.apache.xpath.internal.axes.HasPositionalPredChecker"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="org.hibernate.annotations.Synchronize"%>
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, modelo.ListarPedidos, java.util.Set, modelo.Pedidos, modelo.DetallesPedido, modelo.ProductoCarrito, java.util.HashMap, java.util.ArrayList, modelo.Categorias, modelo.Productos"%>
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

<style>
#tabla {
	margin-top: 7%;
	width: 30%;
	margin-left: 2%;
	background-color: #2c3e50;
	float: left;
	margin-bottom: 6%;	
	
}

#tabla tr {
	font-size: 20px;
	color: white;
}

#tabla th {
	text-align: center;
	color:white;
}
</style>

</head>
<body>



	<%
		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session datos = HibernateUtil.getSessionFactory().openSession();
		//String idCategoria = request.getParameter("id");

		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carro = (HashMap<Integer, ProductoCarrito>) atrsesion
				.getAttribute("carrito");

		if (user != null) {

			Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);

			int numItems = 0;

			if (carro != null) {
				numItems = carro.size();

			}
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
				<li class="nav-item"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=Productos">Productos<span
						class="sr-only">(current)</span></a></li>
				<li class="nav-item"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=carrito">Carrito [<%=numItems%>]
				</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=pedidos">Mis Pedidos </a></li>
			</ul>
		</div>
	</div>
	</nav> </header>

	<%
		} else {
	%>
	<header> <nav
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
		@SuppressWarnings("unchecked")
		HashMap<Integer, ListarPedidos> hashPedidos = (HashMap<Integer, ListarPedidos>) request
				.getAttribute("hashPedidos");

		if (hashPedidos != null) {

			Set<Integer> claves = hashPedidos.keySet();

			for (Integer clave : claves) {
	%>

	<table id="tabla" class="table">
		<thead>

			<tr>
				<th colspan="3"><h3>
						Pedido número
						<%=hashPedidos.get(clave).getDetalles().get(clave - 1).getCodigoPedido()%></h3></th>

			</tr>
		</thead>
		<tfoot>
			<tr>
				<th>Nombre</th>
				<th>Precio</th>
				<th>Cantidad</th>
			</tr>


			<%
				int precioTotal = 0;
						for (int i = 0; i < hashPedidos.get(clave).getDetalles().size(); i++) {
			%>
			<tr>
				<th><%=hashPedidos.get(clave).getDetalles().get(i).getNombreProducto()%></th>
				<th><%=hashPedidos.get(clave).getDetalles().get(i).getPrecio()%>&euro;</th>
				<th><%=hashPedidos.get(clave).getDetalles().get(i).getCantidad()%></th>
			</tr>


			<%
				precioTotal += hashPedidos.get(clave).getDetalles().get(i).getPrecio();
						}
			%>



			<tr>
				<th>Fecha pedido:</th>
				<th colspan="3" style="padding-top: 3%"><%=hashPedidos.get(clave).getPedidos().get(clave - 1).getFechaPedido()%></th>
			</tr>
			<tr>
				<th>Precio Total:</th>
				<th colspan="3" style="padding-top: 3%"><%=precioTotal%>&euro;</th>
			</tr>



		</tfoot>
	</table>


	<%
		}
		} else {
	%>


	<div style="text-align: center; margin-top: 10%">
		<h1>No has realizado ningún pedido aún!!</h1>
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
