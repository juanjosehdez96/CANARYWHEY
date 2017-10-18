package modelo;
// Generated 13-oct-2017 14:16:47 by Hibernate Tools 5.2.5.Final

/**
 * Productos generated by hbm2java
 */
public class Productos implements java.io.Serializable {

	private Integer codigoProducto;
	private String nombre;
	private int codigoCategoria;
	private int precio;
	private int stock;


	public Productos() {
	}

	public Productos(String nombre, int codigoCategoria, int precio, int stock) {
		this.nombre = nombre;
		this.codigoCategoria = codigoCategoria;
		this.precio = precio;
		this.stock = stock;
	}

	public Integer getCodigoProducto() {
		return this.codigoProducto;
	}

	public void setCodigoProducto(Integer codigoProducto) {
		this.codigoProducto = codigoProducto;
	}

	public String getNombre() {
		return this.nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public int getCodigoCategoria() {
		return this.codigoCategoria;
	}

	public void setCodigoCategoria(int codigoCategoria) {
		this.codigoCategoria = codigoCategoria;
	}

	public int getPrecio() {
		return this.precio;
	}

	public void setPrecio(int precio) {
		this.precio = precio;
	}

	public int getStock() {
		return this.stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

}
