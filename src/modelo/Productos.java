package modelo;
// Generated 13-oct-2017 14:16:47 by Hibernate Tools 5.2.5.Final

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Productos generated by hbm2java
 */
@Entity
@Table(name = "productos")
public class Productos implements java.io.Serializable {
	
	
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "codigo_producto")
	private Integer codigoProducto;
	
	@Column(name = "nombre")
	private String nombre;
	
	@Column(name = "codigo_categoria")
	private int codigoCategoria;
	
	@Column(name = "precio")
	private int precio;
	
	@Column(name = "stock")
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
