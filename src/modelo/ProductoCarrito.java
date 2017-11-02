package modelo;

public class ProductoCarrito {

	private Productos producto;
	private int catidad;

	public ProductoCarrito(Productos producto, int catidad) {
		super();
		this.producto = producto;
		this.catidad = catidad;
	}

	public Productos getProducto() {
		return producto;
	}

	public void setProducto(Productos producto) {
		this.producto = producto;
	}

	public int getCatidad() {
		return catidad;
	}

	public void setCatidad(int catidad) {
		this.catidad = catidad;
	}

}
