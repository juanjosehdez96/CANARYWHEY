package modelo;
// Generated 13-oct-2017 14:16:47 by Hibernate Tools 5.2.5.Final

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Categorias generated by hbm2java
 */
@Entity
@Table(name = "categorias")
public class Categorias implements java.io.Serializable {

	@Id
	@Column(name = "codigo_categoria")
	private Integer codigoCategoria;
	
	@Column(name = "nombre")
	private String nombre;

	public Categorias() {
	}

	public Categorias(String nombre) {
		this.nombre = nombre;
	}

	public Integer getCodigoCategoria() {
		return this.codigoCategoria;
	}

	public void setCodigoCategoria(Integer codigoCategoria) {
		this.codigoCategoria = codigoCategoria;
	}

	public String getNombre() {
		return this.nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

}
