package controlador;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.hibernate.Session;

import javafx.embed.swing.SwingFXUtils;
import javafx.scene.image.Image;
import modelo.Categorias;
import modelo.HibernateUtil;
import modelo.Productos;
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

			case "Pedidos":
				añadirProductos(request);
				url = base + "pedidos.jsp";
				break;

			case "misPedidos":
				url = base + "pedidos.jsp";
				break;

			case "addProductos":
				if (request.getParameter("volver") != null) {
					url = base + "productos.jsp";
					break;
				} else {

					if (request.getParameter("guardarCambios") != null) {
						addProductos(request);
						url = base + "productos.jsp";
					}
					url = base + "añadirProductos.jsp";
					
				}
				break;

				

			case "addCategorias":
				if (request.getParameter("volver") != null) {
					url = base + "productos.jsp";
					break;
				} else {

					if (request.getParameter("guardarCambios") != null) {
						addCategorias(request);
						url = base + "productos.jsp";

					} else {
						url = base + "añadirCategorias.jsp";
						break;
					}
				}

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

	public void añadirProductos(HttpServletRequest request) {

		HttpSession carritoSesion = request.getSession();

		@SuppressWarnings("unchecked")
		HashMap<Integer, Productos> carrito = (HashMap<Integer, Productos>) carritoSesion.getAttribute("carrito");

		if (carrito == null) {
			carrito = new HashMap<Integer, Productos>();
		}

		Session sesion = HibernateUtil.getSessionFactory().openSession();

		int idProducto = Integer.parseInt(request.getParameter("proId"));

		Productos producto = (Productos) sesion.get(Productos.class, idProducto);

		carrito.put(idProducto, producto);

		carritoSesion.setAttribute("carrito", carrito);

	}

	public void addProductos(HttpServletRequest request) {

	}

	public void addCategorias(HttpServletRequest request) {

		String nombreCategoria = request.getParameter("nombreCategoria");

		if (!nombreCategoria.equals("")) {
			Categorias categoria = new Categorias(nombreCategoria);

			Session session = HibernateUtil.getSessionFactory().openSession();
			session.beginTransaction();

			session.save(categoria); // <|--- Aqui guardamos el objeto en la base de datos.

			session.getTransaction().commit();
			session.close();
		}

	}

	public Image abrirImagen() throws SQLException, IOException {
		BufferedImage rpta = null;
		Image image = null;
		File fichero = new File("imgsUsuarios/.png");
		try {

			InputStream in = new FileInputStream(fichero);
			rpta = javax.imageio.ImageIO.read(in);
			image = SwingFXUtils.toFXImage(rpta, null);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return image;
	}

}
