<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Acceder</title>

<link
	href='https://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">

<script
	src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<link href="css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<script src="js/bootstrap.min.js"></script>
<link rel="stylesheet" href="css/bootstrap-datepicker.min.css" />
<script src="js/bootstrap-datepicker.min.js"></script>


</head>

<body>


	<header>

		<!-- Navigation -->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
			<div class="container">
				<a class="navbar-brand" href="#">BIENVENIDO</a>
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
							href="/CANARYWHEY/Servlet?action=Acceder">Acceder <span
								class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>

	<div class="form">

		<ul class="tab-group">
			<li class="tab active"><a href="#signup">Registrarse</a></li>
			<li class="tab"><a href="#login">Iniciar Sesión</a></li>
		</ul>

		<div class="tab-content">
			<div id="signup">
				<h1>Bienvenido/a!</h1>

				<form action="Servlet?action=Registro" method="post">

					<div class="top-row">
						<div class="field-wrap">
							<label> Nombre<span class="req">*</span>
							</label> <input name="nombre" type="text" required autocomplete="off" />
						</div>

						<div class="field-wrap">
							<label> Apellidos<span class="req">*</span>
							</label> <input name="apellidos" type="text" required autocomplete="off" />
						</div>
					</div>

					<div class="field-wrap">
						<label> Nombre de usuario<span class="req">*</span>
						</label> <input name="nombreUsuario" type="text" required
							autocomplete="off" />
					</div>
					<div class="field-wrap">
						<label> Correo Electrónico<span class="req">*</span>
						</label> <input name="email" type="email" required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Contraseña<span class="req">*</span>
						</label> <input name="contraseña" type="password" required
							autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Repetir Contraseña<span class="req">*</span>
						</label> <input type="password" required autocomplete="off" />
					</div>

					<div class="input-group date">
						<input id="datepicker" type="text" name="fechaNacimiento"
							placeholder="Fecha de Nacimieto*" class="form-control"><span
							class="input-group-addon"><i
							class="glyphicon glyphicon-th"></i></span>
					</div>
					<br />

					<div class="form-group">
						<div class="col-xs-5 selectContainer">
							<select class="form-control" name="rol">
								<option value="Cliente">Cliente</option>
								<option value="Administrador">Administrador</option>
							</select>
						</div>
					</div>
					<br />

					<button type="submit" class="button button-block">Enviar</button>

				</form>

			</div>

			<div id="login">
				<h1>Bienvenido/a!</h1>

				<form action="Servlet?action=InicioSesion" method="post">

					<div class="field-wrap">
						<label> Nombre Usuario<span class="req">*</span>
						</label> <input type="text" name="nombre" required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Contraseña<span class="req">*</span>
						</label> <input type="password" name="contraseña" required
							autocomplete="off" />
					</div>

					<p class="forgot">
						<a href="#">¿Olvidaste tu contraseña?</a>
					</p>

					<button class="button button-block">Iniciar Sesión</button>

				</form>

			</div>

		</div>
		<!-- tab-content -->

	</div>
	<!-- /form -->


	<script src="js/index.js"></script>

</body>
</html>
