package modelo;
// Generated 13-oct-2017 14:16:47 by Hibernate Tools 5.2.5.Final

import java.util.Date;

/**
 * Pedidos generated by hbm2java
 */
public class Pedidos implements java.io.Serializable {

	private Integer codigoPedido;
	private int nombreUsuario;
	private Date fechaPedido;
	private Date horaPedido;

	public Pedidos() {
	}

	public Pedidos(int nombreUsuario, Date fechaPedido, Date horaPedido) {
		this.nombreUsuario = nombreUsuario;
		this.fechaPedido = fechaPedido;
		this.horaPedido = horaPedido;
	}

	public Integer getCodigoPedido() {
		return this.codigoPedido;
	}

	public void setCodigoPedido(Integer codigoPedido) {
		this.codigoPedido = codigoPedido;
	}

	public int getNombreUsuario() {
		return this.nombreUsuario;
	}

	public void setNombreUsuario(int nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public Date getFechaPedido() {
		return this.fechaPedido;
	}

	public void setFechaPedido(Date fechaPedido) {
		this.fechaPedido = fechaPedido;
	}

	public Date getHoraPedido() {
		return this.horaPedido;
	}

	public void setHoraPedido(Date horaPedido) {
		this.horaPedido = horaPedido;
	}

}
