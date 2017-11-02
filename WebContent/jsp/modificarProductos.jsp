<%@page import="java.nio.charset.CodingErrorAction"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList, modelo.Categorias, modelo.Productos"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" href="css/estilos.css">
<script src="js/jquery.validate.min.js"></script>


<script>

$(document).ready(function () {
	$("#btnGuardar").on("click", function() {
		
		// name validation
	    var nameregex = /^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+$/i;  
	   
	   $.validator.addMethod("validname", function( value, element ) {
	       return this.optional( element ) || nameregex.test( value );
	   }); 
	      
	   
	
	   $("#formulario").validate({
		   
		   errorClass: "my-error-class",
		   validClass: "my-valid-class",
		    
		    rules: {
		        nombre: {  required: true, validname: true},
		        precio: { required: true, digits:true},
		        stock: { required:true, digits:true},
		        file: { required: true}
		       
		    },
		    messages: {
		        nombre: "Nombre no válido.",
		        precio: "Introduzca valor numérico.",
		        stock: "Introduzca valor numérico.",
		        file: "Tipo de archivo no válido."
		        
		    
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
		int idProducto = Integer.parseInt(request.getParameter("proId"));

		Productos producto = (Productos) datos.get(Productos.class, idProducto);
		pageContext.setAttribute("producto", producto);

		Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);

		if (usuario.getRol().equals("Administrador")) {
	%>

	<header> <!-- Navigation --> <nav
		class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
	<div class="container">
		<a class="navbar-brand" href="/CANARYWHEY/Servlet?action=InicioSesion">BIENVENIDO:
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
					href="/CANARYWHEY/Servlet?action=InicioSesion">Inicio</a></li>
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
	</nav> </header>


	<!-- Sidebar -->
	<div id="barraizquierda">
		<h2 style="text-align: center;">
			<a href="/CANARYWHEY/Servlet?action=Productos"> CATEGORÍAS</a>
		</h2>
		<ul>
			<%
				ArrayList<Categorias> arrayCategorias = (ArrayList<Categorias>) datos.createQuery("from Categorias")
							.list();
					pageContext.setAttribute("arraycategorias", arrayCategorias);
			%>

			<c:forEach var="categorias" items="${arraycategorias}">
				<li><a
					href="/CANARYWHEY/Servlet?action=seleccionCategoria&id=${categorias.codigoCategoria}">
						${categorias.nombre} </a></li>

			</c:forEach>

		</ul>
	</div>

	<div id="table" class="table-editable"
		style="margin-left: 15%; width: 100%">
		<form action="Servlet?action=modificarProductos&proId=<%=idProducto%>"
			method="post" enctype="multipart/form-data" id="formulario">

			<span class="table-add glyphicon glyphicon-plus"></span>
			<table class="table">
				<thead>
					<tr>
						<th style="padding-left: 10%" colspan="3">INFORMACIÓN DEL
							PRODUCTO</th>
					</tr>
				</thead>
				<tbody>

					<tr>
						<th scope="row">1</th>
						<td>Nombre del producto:</td>
						<td><input type="text" name="nombre"
							value="<%=producto.getNombre()%>" /></td>

					</tr>
					<tr>
						<th scope="row">2</th>
						<td>Precio:</td>
						<td><input type="text" name="precio"
							value="<%=producto.getPrecio()%>" /></td>

					</tr>
					<tr>
						<th scope="row">3</th>
						<td>Unidades disponibles:</td>
						<td><input type="text" name="stock"
							value="<%=producto.getStock()%>" /></td>

					</tr>

					<tr>

						<th scope="row">3</th>
						<td>Categoría a la que pertenece:</td>
						<td><select name="nombreCategoria">

								<c:forEach var="categorias" items="${arraycategorias}">
									<c:choose>
										<c:when
											test="${producto.codigoCategoria == categorias.codigoCategoria}">
											<option selected value="${categorias.codigoCategoria}">${categorias.nombre}</option>
										</c:when>
										<c:otherwise>
											<option value="${categorias.codigoCategoria}">${categorias.nombre}</option>
										</c:otherwise>
									</c:choose>

								</c:forEach>

						</select></td>
					</tr>


					<tr>
						<th scope="row">5</th>
						<td>Foto:</td>
						<td><input type="file" name="file" id="examinar" src="imgsProductos/<%=producto.getCodigoProducto()%>.jpg" accept="image/*" /></td>
					</tr>



				</tbody>
			</table>
			<button style="margin-left: 30%; margin-bottom: 1.5%;"
				name="guardarCambios" type="submit" id="btnGuardar"class="btn btn-primary">Guardar
				cambios</button>
			<button type="submit" style="margin-left: 5%; margin-bottom: 1.5%"
				name="volver" onclick="window.location.href='/CANARYWHEY/Servlet?action=Productos';"
				class="btn btn-primary" >Volver</button>




		</form>
	</div>

	<%
		} else {
	%>

	<p>No tiene permisos de administrador para ver esta pagina!!!</p>
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