package controlador;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;

import modelo.Categorias;
import modelo.HibernateUtil;
import modelo.Usuarios;

/**
 * Servlet implementation class Servlet
 */
@WebServlet("/Servlet")
public class Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Servlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String base = "/jsp/";
		String url = base + "bienvenida.jsp";
		String action = request.getParameter("action");
		HttpSession atrsesion = request.getSession();

		if (atrsesion.getAttribute("nombreDeUsuario") != null) {
			url = base + "bienvenidaLogueado.jsp";
		}

		if (action != null) {
			switch (action) {
			case "Acceder":
				url = base + "acceder.jsp";
				break;
			case "Registro":
				añadirUsuarios(request);
				url = base + "bienvenidaLogueado.jsp";
				break;
			case "InicioSesion":
				if (request.getParameter("nombre") != null) {
					if (iniciarSesion(request))
						url = base + "bienvenidaLogueado.jsp";
					else
						url = base + "acceder.jsp";
				} else {
					url = base + "bienvenidaLogueado.jsp";
				}
				break;

			case "modificarCuenta":
				if (request.getParameter("guardarCambios") != null) {
					modificarUsuarios(request);
					url = base + "miCuenta.jsp";
				} else
					url = base + "modificarCuenta.jsp";
				break;

			case "Cuenta":
				if (request.getParameter("borrarCuenta") != null) {
					eliminarCuenta(request);
					url = base + "bienvenida.jsp";
				} else {

					if (request.getParameter("modificar") != null)
						url = base + "modificarCuenta.jsp";
					else
						url = base + "miCuenta.jsp";
				}
				break;

			case "Inicio":
				cerrarSesion(request);
				url = base + "bienvenida.jsp";
				break;

			case "Productos":
				url = base + "productos.jsp";
				break;

			case "seleccionCategoria":
				url = base + "productos.jsp";
				break;
			case "seleccionProductos":
				url = base + "seleccionProducto.jsp";
				break;
			}
		}
		request.getRequestDispatcher(url).forward(request, response);

	}

	public void añadirUsuarios(HttpServletRequest request) {

		String rol = request.getParameter("rol");
		String nombre = request.getParameter("nombre");
		String apellidos = request.getParameter("apellidos");
		String nombreUsuario = request.getParameter("nombreUsuario");
		String contraseña = request.getParameter("contraseña");
		String email = request.getParameter("email");

		DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd-MM-yyyy");
		LocalDate fechaNacimiento = LocalDate.parse(request.getParameter("fechaNacimiento"), formato);

		Usuarios usuario = new Usuarios(nombreUsuario, rol, nombre, apellidos, contraseña, email, fechaNacimiento);

		HttpSession atrsesion = request.getSession();
		atrsesion.setAttribute("nombreDeUsuario", request.getParameter("nombreUsuario"));

		Session session = HibernateUtil.getSessionFactory().openSession();
		session.beginTransaction();

		session.save(usuario); // <|--- Aqui guardamos el objeto en la base de datos.

		session.getTransaction().commit();
		session.close();

	}

	public void eliminarCuenta(HttpServletRequest request) {

		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");

		Session session = HibernateUtil.getSessionFactory().openSession();

		Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

		session.beginTransaction();

		session.delete(usuario);

		session.getTransaction().commit();
		session.close();

		atrsesion.invalidate();

	}

	public void modificarUsuarios(HttpServletRequest request) {

		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session session = HibernateUtil.getSessionFactory().openSession();

		Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

		usuario.setNombre(request.getParameter("nombre"));
		usuario.setApellidos(request.getParameter("apellidos"));
		usuario.setContraseña(request.getParameter("contraseña"));
		usuario.setEmail(request.getParameter("email"));

		LocalDate fechaNacimiento = LocalDate.parse(request.getParameter("fechaNacimiento"));
		usuario.setFechaNacimiento(fechaNacimiento);

		atrsesion.setAttribute("nombreDeUsuario", usuario.getNombreUsuario());
		session.beginTransaction();

		session.update(usuario);

		session.getTransaction().commit();
		session.close();

	}

	public boolean iniciarSesion(HttpServletRequest request) {

		HttpSession atrsesion = request.getSession();
		atrsesion.setAttribute("nombreDeUsuario", request.getParameter("nombre"));

		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session session = HibernateUtil.getSessionFactory().openSession();

		Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

		if (usuario == null) {
			System.out.println("USUARIO NO REGISTRADO");
			session.close();
			return false;
		} else {

			if (usuario.getNombreUsuario().equals(user)
					&& usuario.getContraseña().equals(request.getParameter("contraseña"))) {
				session.close();
				return true;

			} else {
				session.close();
				return false;
			}
		}

	}

	public void cerrarSesion(HttpServletRequest request) {

		HttpSession atrsesion = request.getSession();
		atrsesion.invalidate();

	}
}
