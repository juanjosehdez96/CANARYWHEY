<%@page
	import="modelo.Usuarios, modelo.ProductoCarrito, modelo.HibernateUtil, org.hibernate.Session, java.util.ArrayList, java.util.HashMap, 
	modelo.Categorias, modelo.Productos, java.util.Set;"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>CANARYWHEY</title>

<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<link rel="stylesheet" href="css/estilos.css">
<link
	href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css"
	rel="stylesheet">

<link rel="stylesheet" href="css/jquery-confirm.min.css">
<script src="js/jquery-confirm.min.js"></script>

<script>
	$(document).ready(function() {
		$("button:even").on("click", function(event) {

			//event.preventDefault();

			$.confirm({
				title : '¿Estás seguro?',
				content : 'El producto será eliminado',
				type : 'red',
				typeAnimated : true,
				buttons : {
					tryAgain : {
						text : 'Aceptar',
						btnClass : 'btn-red',
						action : function(e) {
							$("#formulario").submit();

						}
					},
					cerrar : function() {
						return;
					}
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

		String idProducto = request.getParameter("proId");

		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carro = (HashMap<Integer, ProductoCarrito>) atrsesion
				.getAttribute("carrito");

		int numItems = 0;

		if (carro != null) {
			numItems = carro.size();

			atrsesion.setAttribute("numItems", carro.size());
		}
		//pageContext.setAttribute("arrayCarrito", carro);
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
					href="/CANARYWHEY/Servlet">Inicio</a></li>
				<li class="nav-item"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=Cuenta">Mi cuenta </a></li>
				<li class="nav-item"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=Productos">Productos<span
						class="sr-only">(current)</span></a></li>
				<li class="nav-item active"><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=carrito">Carrito [<%=numItems%>]
				</a></li>
				<li class="nav-item "><a class="nav-link"
					href="/CANARYWHEY/Servlet?action=pedidos">Mis Pedidos </a></li>
			</ul>
		</div>
	</div>
	</nav> </header>


	<%
		if (carro != null && (carro.size() > 0)) {

			Set<Integer> claves = carro.keySet();
	%>


	<div class="container">
		<table id="cart" class="table table-hover table-condensed">
			<thead>
				<tr>
					<th style="width: 50%">Producto</th>
					<th style="width: 10%">Precio</th>
					<th style="width: 8%">Cantidad</th>
					<th style="width: 22%" class="text-center">Subtotal</th>
					<th style="width: 10%"></th>
				</tr>
			</thead>



			<%
				int subtotal = 0;
					int total = 0;

					for (Integer clave : claves) {
						subtotal = carro.get(clave).getProducto().getPrecio() * carro.get(clave).getCatidad();
						total += subtotal;
			%>

			<tbody>
				<tr>
					<td data-th="Product">
						<div class="row">
							<div class="col-sm-2 hidden-xs">
								<img id="imagenCarro"
									src="imgsProductos/<%=carro.get(clave).getProducto().getCodigoProducto()%>.jpg"
									alt="..." class="img-responsive" />
							</div>
							<div class="col-sm-10">
								<h4 class="nomargin"><%=carro.get(clave).getProducto().getNombre()%></h4>

							</div>
						</div>
					</td>

					<form action="Servlet?action=carrito" method="post" id="formulario"
						name="form">
						<td data-th="Price"><%=carro.get(clave).getProducto().getPrecio()%>&euro;</td>
						<td data-th="Quantity"><input type="hidden" name="proId"
							value="<%=carro.get(clave).getProducto().getCodigoProducto()%>" />
							<input name="cantidad" min="1" type="number"
							class="form-control text-center"
							value="<%=carro.get(clave).getCatidad()%>" /></td>
						<td data-th="Subtotal" class="text-center" id="subtotal"><%=subtotal%>&euro;</td>
						<td class="actions" data-th=""><input type="hidden"
							name="borrar" id="borrame"
							value="<%=carro.get(clave).getProducto().getCodigoProducto()%>" />

							<button type="submit" name="actualizar"
								class="btn btn-info btn-sm">
								<i class="fa fa-refresh"></i>
							</button>
							<button type="submit" id="btnEliminar"
								class="btn btn-danger btn-sm">
								<i class="fa fa-trash-o"></i>
							</button></td>
					</form>
				</tr>
			</tbody>


			<%
				}
			%>

			<tfoot>

				<tr>
					<td><a href="/CANARYWHEY/Servlet?action=Productos"
						class="btn btn-warning"><i class="fa fa-angle-left"></i>
							Continuar comprando</a></td>
					<td colspan="2" class="hidden-xs"></td>
					<td class="hidden-xs text-center" id="total"><strong>Total
							<%=total%>&euro;
					</strong></td>
					<td><a href="/CANARYWHEY/Servlet?action=Checkout"
						class="btn btn-success btn-block">Checkout <i
							class="fa fa-angle-right"></i>
					</a></td>
				</tr>
			</tfoot>
		</table>
	</div>
	<%
		} else {
	%>
	<div id="carrito" style="text-align: center;">
		<h1>El carrito está vacío!!</h1>
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
