package controlador;

import java.awt.image.BufferedImage;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

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
@MultipartConfig
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

				if (request.getParameter("volver") != null) {
					url = base + "miCuenta.jsp";
				} else {
					if (request.getParameter("guardarCambios") != null) {

						try {
							modificarUsuarios(request);
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

						url = base + "miCuenta.jsp";
					} else
						url = base + "modificarCuenta.jsp";
				}
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
				if (request.getParameter("busqueda") != null) {
					busquedaProductos(request);
					url = base + "productos.jsp";
					break;
				} else {
					url = base + "productos.jsp";
					break;
				}

			case "seleccionCategoria":
				url = base + "productos.jsp";
				break;
			case "seleccionProductos":
				url = base + "seleccionProducto.jsp";
				break;

			case "Pedidos":
				if (request.getParameter("btnCarrito") != null) {
					añadirProductosCarrito(request);
					url = base + "pedidos.jsp";
					break;
				}
				if (request.getParameter("btnEliminar") != null) {
					eliminarProducto(request);
					url = base + "productos.jsp";
					break;
				}

			case "misPedidos":
				url = base + "pedidos.jsp";
				break;

			case "addProductos":
				String user = (String) atrsesion.getAttribute("nombreDeUsuario");
				Session session = HibernateUtil.getSessionFactory().openSession();
				Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

				if (usuario.getRol().equals("Administrador")) {
					if (request.getParameter("volver") != null) {
						url = base + "productos.jsp";
						break;
					} else {

						if (request.getParameter("guardarProductos") != null) {
							addProductos(request);
							url = base + "productos.jsp";
							break;
						} else {
							url = base + "añadirProductos.jsp";
							break;
						}
					}
				} else {
					url = base + "bienvenidaLogueado.jsp";

				}

			case "addCategorias":
				String user1 = (String) atrsesion.getAttribute("nombreDeUsuario");
				Session session1 = HibernateUtil.getSessionFactory().openSession();
				Usuarios usuario1 = (Usuarios) session1.get(Usuarios.class, user1);

				if (usuario1.getRol().equals("Administrador")) {
					if (request.getParameter("volver") != null) {
						url = base + "productos.jsp";
						break;
					} else {

						if (request.getParameter("guardarCategorias") != null) {
							addCategorias(request);
							url = base + "productos.jsp";
							break;

						} else {
							url = base + "añadirCategorias.jsp";
							break;
						}
					}
				} else {
					url = base + "bienvenidaLogueado.jsp";
					break;

				}

			case "modificarProductos":
				if (request.getParameter("volver") != null) {
					url = base + "productos.jsp";
					break;
				} else {

					if (request.getParameter("guardarCambios") != null) {
						try {
							modificarProductos(request);
							url = base + "productos.jsp";
							break;
						} catch (Exception e) {
							e.printStackTrace();
						}

					} else {

						url = base + "modificarProductos.jsp";
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
		String contraseña = request.getParameter("contrasena");
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

	public void modificarUsuarios(HttpServletRequest request) throws Exception {

		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session session = HibernateUtil.getSessionFactory().openSession();

		Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

		usuario.setNombre(request.getParameter("nombre"));
		usuario.setApellidos(request.getParameter("apellidos"));
		usuario.setContraseña(request.getParameter("contrasena"));
		usuario.setEmail(request.getParameter("email"));

		LocalDate fechaNacimiento = LocalDate.parse(request.getParameter("fechaNacimiento"));
		usuario.setFechaNacimiento(fechaNacimiento);

		atrsesion.setAttribute("nombreDeUsuario", usuario.getNombreUsuario());

		Part fotoPart = request.getPart("file");
		int fotoSize = (int) fotoPart.getSize();

		byte[] foto = null;
		if (fotoSize > 0) {

			foto = new byte[fotoSize];
			try (DataInputStream dis = new DataInputStream(fotoPart.getInputStream())) {
				dis.readFully(foto);

				File file = new File("C://Users/Juan José/git/CANARYWHEY/WebContent/imgsUsuarios", user + ".jpg");
				FileOutputStream salida = new FileOutputStream(file);
				salida.write(foto);
				salida.close();

			}
		}

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
					&& usuario.getContraseña().equals(request.getParameter("contrasena"))) {
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

	public void añadirProductosCarrito(HttpServletRequest request) {

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

	public void addProductos(HttpServletRequest request) throws IllegalStateException, IOException, ServletException {

		String nombreProducto = request.getParameter("nombre");

		int codigoCategoria = Integer.parseInt(request.getParameter("nombreCategoria"));
		int precio = Integer.parseInt(request.getParameter("precio"));
		int stock = Integer.parseInt(request.getParameter("stock"));

		if (codigoCategoria != 0 && !nombreProducto.equals("") && precio != 0 && stock != 0) {

			Productos producto = new Productos(nombreProducto, codigoCategoria, precio, stock);

			Session session = HibernateUtil.getSessionFactory().openSession();
			session.beginTransaction();

			session.save(producto); // <|--- Aqui guardamos el objeto en la base de datos.
			session.getTransaction().commit();
			session.close();

			Part fotoPart = request.getPart("file");
			int fotoSize = (int) fotoPart.getSize();

			byte[] foto = null;
			if (fotoSize > 0) {

				foto = new byte[fotoSize];
				try (DataInputStream dis = new DataInputStream(fotoPart.getInputStream())) {
					dis.readFully(foto);

					File file = new File("C://Users/Juan José/git/CANARYWHEY/WebContent/imgsProductos",
							(producto.getCodigoProducto()) + ".jpg");
					System.out.println(codigoCategoria);
					FileOutputStream salida = new FileOutputStream(file);
					salida.write(foto);
					salida.close();
				}
			}

		}
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

	public void eliminarProducto(HttpServletRequest request) {

		String idProducto = request.getParameter("proId");

		Session session = HibernateUtil.getSessionFactory().openSession();

		Productos producto = (Productos) session.get(Productos.class, Integer.parseInt(idProducto));

		File file = new File("C://Users/Juan José/git/CANARYWHEY/WebContent/imgsProductos", idProducto + ".jpg");
		file.delete();

		session.beginTransaction();

		session.delete(producto);

		session.getTransaction().commit();
		session.close();

	}

	public void modificarProductos(HttpServletRequest request) throws Exception {

		int idProducto = Integer.parseInt(request.getParameter("proId"));
		Session session = HibernateUtil.getSessionFactory().openSession();
		Productos producto = (Productos) session.get(Productos.class, idProducto);

		producto.setNombre(request.getParameter("nombre"));
		producto.setPrecio(Integer.parseInt(request.getParameter("precio")));
		producto.setStock(Integer.parseInt(request.getParameter("stock")));
		producto.setCodigoCategoria(Integer.parseInt(request.getParameter("nombreCategoria")));

		Part fotoPart = request.getPart("file");
		int fotoSize = (int) fotoPart.getSize();

		byte[] foto = null;
		if (fotoSize > 0) {

			foto = new byte[fotoSize];
			try (DataInputStream dis = new DataInputStream(fotoPart.getInputStream())) {
				dis.readFully(foto);

				File file = new File("C://Users/Juan José/git/CANARYWHEY/WebContent/imgsProductos",
						idProducto + ".jpg");
				FileOutputStream salida = new FileOutputStream(file);
				salida.write(foto);
				salida.close();

			}
		}

		session.beginTransaction();

		session.update(producto);

		session.getTransaction().commit();
		session.close();

	}

	public void busquedaProductos(HttpServletRequest request) {
		Session datos = HibernateUtil.getSessionFactory().openSession();

		String nombre = request.getParameter("busqueda");
		Query query = datos.createQuery("from Productos where nombre LIKE '%" + nombre + "%'");
		if (query != null) {

			@SuppressWarnings("unchecked")
			ArrayList<Productos> productos = (ArrayList<Productos>) query.getResultList();

			request.setAttribute("productosBuscados", productos);
		}

	}

}
