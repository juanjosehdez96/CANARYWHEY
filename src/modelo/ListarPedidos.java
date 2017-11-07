package modelo;

import java.util.ArrayList;

public class ListarPedidos {
	
	private ArrayList<Pedidos> pedidos;
	private ArrayList<DetallesPedido> detalles;
	
	
	public ListarPedidos(ArrayList<Pedidos> pedidos, ArrayList<DetallesPedido> detalles) {
		super();
		this.pedidos = pedidos;
		this.detalles = detalles;
	}
	
	
	public ArrayList<Pedidos> getPedidos() {
		return pedidos;
	}
	public void setPedidos(ArrayList<Pedidos> pedidos) {
		this.pedidos = pedidos;
	}
	public ArrayList<DetallesPedido> getDetalles() {
		return detalles;
	}
	public void setDetalles(ArrayList<DetallesPedido> detalles) {
		this.detalles = detalles;
	}
	
	
	

}
