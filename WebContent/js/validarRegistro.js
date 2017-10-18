
(function(){
	
	var formulario = document.getElementsByName('formulario')[0];
	elementos = formulario.elements;
	boton = document.getElementById('btn-submit');
	
	
	
				
	var validarNombre = function(e){
		
		nombreRegex = /[A-Z]{2,50}/i;
		
		if(formulario.nombre.value === ""){
			formulario.nombre.style.border ="1px solid red";
			alert("Completa el campo nombre");
			e.preventDefault();
		}
			else{ if(!nombreRegex.test(formulario.nombre.value)){
				formulario.nombre.style.border ="1px solid red";
				alert("El nombre debe tener entre 2 y 50 caracteres sin numeros");
				e.preventDefault();
				} else{
					formulario.nombre.style.border ="1px solid darkgray";
					}
			}
	};
	
	
	
	var validarCorreo = function(e){
		
		emailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+$/i;
		
		if(formulario.email.value === ""){
			formulario.email.style.border ="1px solid red";
			alert("Completa el correo");
			e.preventDefault();
		}
			else{
				if(!emailRegex.test(formulario.email.value)){
					formulario.email.style.border ="1px solid red";
					alert("El correo no es correcto");
					e.preventDefault();
				} 	else{
						formulario.email.style.border ="1px solid darkgray";
					}
			}
	};
	
	
				
	var validarApellido = function(e){
		
		apellidoRegex = /[A-Z]{2,50}/i;
		
		if(formulario.apellido.value === ""){
			formulario.apellido.style.border ="1px solid red";
			alert("Completa el campo apellido");
			e.preventDefault();
		}
			else{ if(!apellidoRegex.test(formulario.apellido.value)){
				formulario.apellido.style.border ="1px solid blue";
				alert("El apellido debe tener entre  y 50 caracteres sin numeros");
				e.preventDefault();
				} else{
					formulario.apellido.style.border ="1px solid darkgray";
					}
			}
	};
	
	
				
	var validarContrasena = function(e){
		
		if(formulario.pass.value !== formulario.pass2.value){
			formulario.pass.style.border ="1px solid red";
			formulario.pass2.style.border ="1px solid red";	
			alert("Las contraseñas deben ser iguales");
			e.preventDefault();
		} else{
			if((formulario.pass.value && formulario.pass2.value) === ""){
				formulario.pass.style.border ="1px solid red";
				formulario.pass2.style.border ="1px solid red";
				alert("Completa la contraseña");
				e.preventDefault();
			} else{
				formulario.pass.style.border ="1px solid darkgray";
				formulario.pass2.style.border ="1px solid darkgray";
			}
		}
	};
	
	
				
	var validarUsuario = function(e){
		
		usuarioRegex = /[A-Z0-9]{4,50}/i;
		
		if(formulario.user.value === ""){
			formulario.user.style.border ="1px solid red";
			alert("Completa el campo usuario");
			e.preventDefault();
		}
			else{ if(!usuarioRegex.test(formulario.user.value)){
				formulario.user.style.border ="1px solid blue";
				alert("El usuario debe tener entre 4 y 50 caracteres sin numeros");
				e.preventDefault();
				} else{
					formulario.user.style.border ="1px solid darkgray";
					}
			}
	};
	
	
							
	var validar = function(e){
		validarNombre(e);
		validarApellido(e);
		validarContrasena(e);
		validarUsuario(e);
		validarCorreo(e);
	};
				
	formulario.addEventListener("submit", validar);
			
}());
	