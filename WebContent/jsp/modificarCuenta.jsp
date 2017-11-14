<!DOCTYPE html>
<html lang="es">
<%@page
	import="modelo.Usuarios, modelo.HibernateUtil, org.hibernate.Session, modelo.ProductoCarrito, java.util.HashMap, java.io.File"%>
<head>

<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/estilos.css">
<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<script src="js/popper.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/jquery.validate.min.js"></script>
<link href="css/estilos.css" rel="stylesheet">

<link rel="stylesheet" href="css/jquery-confirm.min.css">
<script src="js/jquery-confirm.min.js"></script>


<script>
	$(document)
			.ready(
					function() {

						// name validation
						var nameregex = /^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+$/i;

						$.validator.addMethod("validname", function(value,
								element) {
							return this.optional(element)
									|| nameregex.test(value);
						});

						var fecha = /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/;

						$.validator.addMethod("validfecha", function(value,
								element) {
							return this.optional(element) || fecha.test(value);
						});

						var useregex = /^[a-z\d_]{2,15}$/i;

						$.validator.addMethod("validuser", function(value,
								element) {
							return this.optional(element)
									|| useregex.test(value);
						});

						// valid email pattern
						var eregex = /^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})$/i;

						$.validator.addMethod("validemail",
								function(value, element) {
									return this.optional(element)
											|| eregex.test(value);
								});

						$("#btnGuardar")
								.on(
										"click",
										function(event) {

											event.preventDefault();

											$
													.confirm({
														title : '¿Estás seguro?',
														content : 'Los datos de tu cuenta serán modificados',
														type : 'red',
														typeAnimated : true,
														buttons : {
															tryAgain : {
																text : 'Aceptar',
																btnClass : 'btn-red',
																action : function(
																		e) {
																	var validado = $(
																			"#formulario")
																			.valid();
																	if (validado)
																		document.form
																				.submit();
																}
															},
															cerrar : function() {
																return;
															}
														}
													});

											$("#formulario")
													.validate(
															{

																errorClass : "my-error-class",
																validClass : "my-valid-class",

																rules : {
																	nombre : {
																		required : true,
																		validname : true
																	},
																	apellidos : {
																		required : true,
																		validname : true
																	},
																	email : {
																		required : true,
																		validemail : true
																	},
																	contrasena : {
																		required : true,
																		minlength : 6
																	},
																	fechaNacimiento : {
																		required : true,
																		validfecha : true
																	},
																	file : {
																		required : true
																	}
																},

																messages : {
																	nombre : "Nombre no válido.",
																	apellidos : "Apellidos no válidos.",
																	email : "Formato de email incorrecto.",
																	contrasena : "La contraseña debe tener minimo 6 caracteres.",
																	fechaNacimiento : "Fecha incorrecta",
																	file : " / Tipo de archivo no válido."

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
		pageContext.setAttribute("user", user);

		Session datos = HibernateUtil.getSessionFactory().openSession();
		Usuarios usuario = (Usuarios) datos.get(Usuarios.class, user);

		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carro = (HashMap<Integer, ProductoCarrito>) atrsesion
				.getAttribute("carrito");

		int numItems = 0;

		if (carro != null) {
			numItems = carro.size();

		}
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
							href="/CANARYWHEY/Servlet?action=InicioSesion">Inicio</a></li>
						<li class="nav-item active"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Cuenta">Mi cuenta <span
								class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
						<%
							if (!usuario.getRol().equals("Administrador")) {
						%>

						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=carrito">Carrito [<%=numItems%>]
						</a></li>
						<li class="nav-item "><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=pedidos">Mis Pedidos </a></li>

						<%
							} else {
						%>
						<li class="nav-item "><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=usuarios">Usuarios</a></li>

						<%
							}
						%>
					</ul>
				</div>
			</div>
		</nav>
	</header>

	<div id="table" class="table-editable">
		<form action="Servlet?action=modificarCuenta" method="post"
			enctype="multipart/form-data" id="formulario" name="form">

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
						<td><input type="text" name="nombre"
							value="<%=usuario.getNombre()%>" /></td>

					</tr>
					<tr>
						<th scope="row">3</th>
						<td>Apellidos:</td>
						<td><input type="text" name="apellidos"
							value="<%=usuario.getApellidos()%>" /></td>

					</tr>
					<tr>
						<th scope="row">4</th>
						<td>Correo electrónico:</td>
						<td><input type="text" name="email"
							value="<%=usuario.getEmail()%>" /></td>

					</tr>
					<tr>
						<th scope="row">5</th>
						<td>Fecha de nacimiento:</td>
						<td><input type="text" name="fechaNacimiento"
							value="<%=usuario.getFechaNacimiento()%>" /></td>

					</tr>
					<tr>
						<th scope="row">6</th>
						<td>Tipo de cuenta:</td>
						<td><%=usuario.getRol()%></td>
					</tr>

					<tr>
						<th scope="row">7</th>
						<td>Foto:</td>
						<td><input type="file" name="file" id="examinar"
							accept="image/*" /></td>
					</tr>



				</tbody>
			</table>
			<input type="hidden" name="guardarCambios" /> <input type="submit"
				style="margin-left: 40%; margin-bottom: 10%" id="btnGuardar"
				class="btn btn-primary" value="Guardar cambios" />
			<button type="submit" style="margin-left: 5%; margin-bottom: 10%"
				name=""
				onclick="window.location.href='/CANARYWHEY/Servlet?action=Cuenta';"
				class="btn btn-primary">Volver</button>



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


</body>


</html>