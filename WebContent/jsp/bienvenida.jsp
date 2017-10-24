<!DOCTYPE html>
<html lang="es">
<head>

<title>CANARYWHEY</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/estilos.css">
<link href="css/bootstrap.min.css" rel="stylesheet">
<script src="jquery/jquery-3.2.1.min.js"></script>
<script src="js/popper.js"></script>
<script src="js/bootstrap.min.js"></script>



</head>

<body>
	<header>
		<!-- Navigation -->
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
			<div class="container">
				<a class="navbar-brand" href="/CANARYWHEY/Servlet">BIENVENIDO</a>
				<button class="navbar-toggler" type="button" data-toggle="collapse"
					data-target="#navbarResponsive" aria-controls="navbarResponsive"
					aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbarResponsive">
					<ul class="navbar-nav ml-auto">
						<li class="nav-item active"><a class="nav-link"
							href="/CANARYWHEY/Servlet">Inicio <span class="sr-only">(current)</span>
						</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Acceder">Acceder</a></li>
						<li class="nav-item"><a class="nav-link"
							href="/CANARYWHEY/Servlet?action=Productos">Productos</a></li>
					</ul>
				</div>
			</div>
		</nav>
	</header>



	<section>
		<div id="carouselExampleIndicators" class="carousel slide"
			data-ride="carousel">
			
			<div class="carousel-inner" role="listbox">
				<div class="carousel-item active">
					<img class="d-block img-fluid" src="img/1.jpg" alt="First slide">
				</div>
				<div class="carousel-item">
					<img class="d-block img-fluid" src="img/2.jpg" alt="Second slide">
				</div>
				<div class="carousel-item">
					<img class="d-block img-fluid" src="img/3.jpg" alt="Third slide">
				</div>
				<div class="carousel-item">
					<img class="d-block img-fluid" src="img/4.jpg" alt="Third slide">
				</div>
			</div>
			<a class="carousel-control-prev" href="#carouselExampleIndicators"
				role="button" data-slide="prev"> <span
				class="carousel-control-prev-icon" aria-hidden="true"></span> <span
				class="sr-only">Previous</span>
			</a> <a class="carousel-control-next" href="#carouselExampleIndicators"
				role="button" data-slide="next"> <span
				class="carousel-control-next-icon" aria-hidden="true"></span> <span
				class="sr-only">Next</span>
			</a>
		</div>

	</section>

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