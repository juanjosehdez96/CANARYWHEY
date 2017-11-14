package controlador;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;

import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.commons.codec.digest.DigestUtils;
import org.hibernate.Session;

import modelo.Categorias;
import modelo.DetallesPedido;
import modelo.EnviarCorreo;
import modelo.EnviarEmail;
import modelo.HibernateUtil;
import modelo.ListarPedidos;
import modelo.Pedidos;
import modelo.ProductoCarrito;
import modelo.Productos;
import modelo.Usuarios;

/**
 * Servlet implementation class Servlet
 */
@WebServlet("/Servlet")
@MultipartConfig
public class Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public Servlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String base = "/jsp/";
		String url = base + "bienvenida.jsp";
		String action = request.getParameter("action");

		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Usuarios usuario = null;
		if (user != null) {
			Session session = HibernateUtil.getSessionFactory().openSession();
			usuario = (Usuarios) session.get(Usuarios.class, user);
		}

		if (atrsesion.getAttribute("nombreDeUsuario") != null) {
			url = base + "bienvenidaLogueado.jsp";
		}

		if (action != null) {
			switch (action) {
			case "Acceder":
				url = base + "acceder.jsp";
				break;
			case "Registro":
				try {
					añadirUsuarios(request);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				url = base + "bienvenidaLogueado.jsp";
				break;
			case "InicioSesion":
				if (request.getParameter("nombre") != null) {
					if (iniciarSesion(request)) {
						url = base + "bienvenidaLogueado.jsp";
					} else {
						request.setAttribute("error", "Usuario o contraseña incorrectos");
						url = base + "acceder.jsp";
					}
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
							e.printStackTrace();
						}

						url = base + "miCuenta.jsp";
					} else
						url = base + "modificarCuenta.jsp";
				}
				break;

			case "Cuenta":
				if (request.getParameter("modificar") != null) {
					url = base + "modificarCuenta.jsp";
					break;
				} else {
					if (request.getParameter("borrarCuenta") != null) {
						eliminarCuenta(request);
						url = base + "bienvenida.jsp";
					} else {
						url = base + "miCuenta.jsp";
					}
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

			case "añadirCarrito":
				if (request.getParameter("btnCarrito") != null) {
					añadirProductosCarrito(request);
					url = base + "carrito.jsp";
					break;
				}
				if (request.getParameter("btnEliminar") != null) {
					eliminarProducto(request);
					response.sendRedirect("/CANARYWHEY/Servlet?action=Productos");
					return;
				}

			case "addProductos":

				if (usuario.getRol().equals("Administrador")) {
					if (request.getParameter("volver") != null) {
						url = base + "productos.jsp";
						break;
					} else {

						if (request.getParameter("guardarProductos") != null) {
							addProductos(request);
							response.sendRedirect("/CANARYWHEY/Servlet?action=Productos");
							return;

						} else {
							url = base + "añadirProductos.jsp";
							break;
						}
					}
				} else {
					url = base + "bienvenidaLogueado.jsp";

				}

			case "addCategorias":

				if (usuario.getRol().equals("Administrador")) {
					if (request.getParameter("volver") != null) {
						url = base + "productos.jsp";
						break;
					} else {

						if (request.getParameter("guardarCategorias") != null) {
							addCategorias(request);
							response.sendRedirect("/CANARYWHEY/Servlet?action=Productos");
							return;

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
			case "carrito":
				if (usuario.getRol().equals("Cliente")) {
					if (request.getParameter("actualizar") != null) {
						actualizarCarrito(request);
						url = base + "carrito.jsp";
						break;
					}
					if (request.getParameter("borrar") != null) {
						borrarProductosCarrito(request);
						url = base + "carrito.jsp";
						break;
					}
				} else {
					url = base + "bienvenidaLogueado.jsp";
					break;
				}

				url = base + "carrito.jsp";
				break;

			case "Checkout":
				if (usuario.getRol().equals("Cliente")) {
					if (request.getParameter("comprar") != null) {
						if (checkout(request)) {
							request.setAttribute("checkout", "La compra se ha realizado con éxito");
							atrsesion.setAttribute("carrito", null);
							url = base + "checkout.jsp";
						} else {
							request.setAttribute("checkout", "Error al realizar la compra");
						}

					} else {
						url = base + "checkout.jsp";
					}
				}
				break;

			case "pedidos":
				if (usuario.getRol().equals("Cliente")) {
					if (mostrarPedidos(request)) {
						mostrarPedidos(request);
						url = base + "pedidos.jsp";
					} else {
						url = base + "pedidos.jsp";
					}
				} else {
					url = base + "bienvenidaLogueado.jsp";
				}
				break;

			case "usuarios":
				if (usuario.getRol().equals("Administrador")) {
					if (request.getParameter("borrarUsuario") != null) {
						eliminarUsuario(request);
						url = base + "usuarios.jsp";
					}
					url = base + "usuarios.jsp";
				} else {
					url = base + "bienvenidaLogueado.jsp";
				}
				break;

			}

		}
		request.getRequestDispatcher(url).forward(request, response);

	}

	public void añadirUsuarios(HttpServletRequest request) throws Exception {

		String rol = request.getParameter("rol");
		String nombre = request.getParameter("nombre");
		String apellidos = request.getParameter("apellidos");
		String nombreUsuario = request.getParameter("nombreUsuario");
		String contraseña = DigestUtils.md5Hex(request.getParameter("contrasena"));
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
		String contraseña = DigestUtils.md5Hex(request.getParameter("contrasena"));

		if (usuario == null) {
			System.out.println("USUARIO NO REGISTRADO");
			session.close();
			return false;
		} else {

			if (usuario.getNombreUsuario().equals(user) && usuario.getContraseña().equals(contraseña)) {
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
		HashMap<Integer, ProductoCarrito> carrito = (HashMap<Integer, ProductoCarrito>) carritoSesion
				.getAttribute("carrito");

		if (carrito == null) {
			carrito = new HashMap<Integer, ProductoCarrito>();
		}

		Session sesion = HibernateUtil.getSessionFactory().openSession();

		int idProducto = Integer.parseInt(request.getParameter("proId"));

		if (carrito.get(idProducto) != null) {
			int cantidad = carrito.get(idProducto).getCatidad();
			carrito.get(idProducto).setCatidad(cantidad + 1);

		} else {
			Productos producto = (Productos) sesion.get(Productos.class, idProducto);
			ProductoCarrito item = new ProductoCarrito(producto, 1);
			carrito.put(idProducto, item);
		}

		carritoSesion.setAttribute("carrito", carrito);

	}

	public void borrarProductosCarrito(HttpServletRequest request) {

		HttpSession carritoSesion = request.getSession();

		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carrito = (HashMap<Integer, ProductoCarrito>) carritoSesion
				.getAttribute("carrito");

		int idProducto = Integer.parseInt(request.getParameter("proId"));

		carrito.remove(idProducto);

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

	public void actualizarCarrito(HttpServletRequest request) {

		HttpSession sesion = request.getSession();
		int catidad = Integer.parseInt(request.getParameter("cantidad"));
		int idProducto = Integer.parseInt(request.getParameter("proId"));

		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carro = (HashMap<Integer, ProductoCarrito>) sesion.getAttribute("carrito");

		ProductoCarrito producto = carro.get(idProducto);
		System.out.println(producto.getProducto().getNombre());

		producto.setCatidad(catidad);

	}

	public boolean checkout(HttpServletRequest request) {

		HttpSession sesion = request.getSession();
		@SuppressWarnings("unchecked")
		HashMap<Integer, ProductoCarrito> carro = (HashMap<Integer, ProductoCarrito>) sesion.getAttribute("carrito");

		Set<Integer> claves = carro.keySet();

		String nombre = (String) sesion.getAttribute("nombreDeUsuario");
		String direccion = request.getParameter("direccion");

		int telefono = Integer.parseInt(request.getParameter("telefono"));
		int codigoPostal = Integer.parseInt(request.getParameter("codigoPostal"));
		String num_tarjeta = request.getParameter("tarjeta");

		LocalDate fechaPedido = LocalDate.now();
		LocalTime horaPedido = LocalTime.now();

		Pedidos pedido = new Pedidos(nombre, fechaPedido, horaPedido, telefono, num_tarjeta, direccion, codigoPostal);
		Session session = HibernateUtil.getSessionFactory().openSession();

		session.beginTransaction();

		session.save(pedido); // <|--- Aqui guardamos el objeto en la base de datos.

		session.getTransaction().commit();

		for (Integer clave : claves) {

			DetallesPedido detalles = new DetallesPedido(pedido.getCodigoPedido(),
					carro.get(clave).getProducto().getCodigoProducto(), carro.get(clave).getProducto().getNombre(),
					carro.get(clave).getProducto().getPrecio(), carro.get(clave).getCatidad());

			session.beginTransaction();

			session.save(detalles); // <|--- Aqui guardamos el objeto en la base de datos.

			session.getTransaction().commit();
		}
		request.setAttribute("codigoPedido", pedido.getCodigoPedido());
		session.close();
		return true;
	}

	@SuppressWarnings("unchecked")
	public boolean mostrarPedidos(HttpServletRequest request) {

		HttpSession atrsesion = request.getSession();
		String user = (String) atrsesion.getAttribute("nombreDeUsuario");
		Session datos = HibernateUtil.getSessionFactory().openSession();

		HashMap<Integer, ListarPedidos> hashPedidos = new HashMap<Integer, ListarPedidos>();

		ArrayList<Pedidos> arrayPedidos = (ArrayList<Pedidos>) datos
				.createQuery("from Pedidos where nombre_usuario='" + user + "'").list();

		if (!arrayPedidos.isEmpty()) {

			ArrayList<DetallesPedido> arrayDetalles = new ArrayList<DetallesPedido>();

			for (int i = 0; i < arrayPedidos.size(); i++) {
				arrayDetalles = (ArrayList<DetallesPedido>) datos
						.createQuery("from DetallesPedido where codigo_pedido=" + arrayPedidos.get(i).getCodigoPedido())
						.list();
				ListarPedidos lista = new ListarPedidos(arrayPedidos, arrayDetalles);
				hashPedidos.put(arrayPedidos.get(i).getCodigoPedido(), lista);
			}

			request.setAttribute("hashPedidos", hashPedidos);
			return true;
		}
		return false;

	}

	public void eliminarUsuario(HttpServletRequest request) {

		String user = request.getParameter("borrarUsuario");

		Session session = HibernateUtil.getSessionFactory().openSession();

		Usuarios usuario = (Usuarios) session.get(Usuarios.class, user);

		session.beginTransaction();

		session.delete(usuario);

		session.getTransaction().commit();
		session.close();

	}

}
