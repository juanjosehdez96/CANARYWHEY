package modelo;

import java.io.File;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Part;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class EnviarEmail {

	/** Variables. */
	private Properties props;

	private String from, to, subject;

	/** MultiPart para crear mensajes compuestos. */
	MimeMultipart multipart = new MimeMultipart("related");

	public EnviarEmail() {

		props = new Properties();
		props.setProperty("mail.transport.protocol", "smtp");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		
	     props.put("mail.smtp.auth", "true");
	     props.put("mail.smtp.starttls.enable", "true");
	     props.put("mail.smtp.port", "587");
	     props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	}
	
	
	
    public void createAndSendEmail(String from, String to, String subject) throws Exception {
        this.from = from;
        this.to = to;
        this.subject = subject;
        enviarMailHtml(from, to, subject, null, null);
    }

	public Properties getProps() {
		return props;
	}

	public void setProps(Properties props) {
		this.props = props;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getTo() {
		return to;
	}

	public void setTo(String to) {
		this.to = to;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public MimeMultipart getMultipart() {
		return multipart;
	}

	public void setMultipart(MimeMultipart multipart) {
		this.multipart = multipart;
	}

	/* <-------------------------- Métodos --------------------------------> */

	public void addAttach(String pathname) throws Exception {
		File file = new File(pathname);
		BodyPart messageBodyPart = new MimeBodyPart();
		DataSource ds = new FileDataSource(file);
		messageBodyPart.setDataHandler(new DataHandler(ds));
		messageBodyPart.setFileName(file.getName());
		messageBodyPart.setDisposition(Part.ATTACHMENT);
		this.multipart.addBodyPart(messageBodyPart);
	}

	public void addCID(String cidname, String pathname) throws Exception {
		DataSource fds = new FileDataSource(pathname);
		BodyPart messageBodyPart = new MimeBodyPart();
		messageBodyPart.setDataHandler(new DataHandler(fds));
		messageBodyPart.setHeader("Content-ID", "<" + cidname + ">");
		this.multipart.addBodyPart(messageBodyPart);
	}

	public void addContent(String htmlText) throws Exception {
		// first part (the html)
		BodyPart messageBodyPart = new MimeBodyPart();
		messageBodyPart.setContent(htmlText, "text/html");
		// add it
		this.multipart.addBodyPart(messageBodyPart);
	}

	public void sendMultipart() throws Exception {
		Session mailSession = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication("juanjosehdez96@gmail.com", "gugamida2");
			}
		});
		mailSession.setDebug(true);
		Transport transport = mailSession.getTransport();
		MimeMessage message = new MimeMessage(mailSession);
		message.setSubject(this.getSubject());
		message.setFrom(new InternetAddress(this.getFrom()));
		message.addRecipient(Message.RecipientType.TO, new InternetAddress(this.getTo()));
		// put everything together
		message.setContent(multipart);
		transport.connect();
		transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
		transport.close();
	}

	public void enviarMailHtml(String from, String to, String subject, String body, List<String> adjuntos)
			throws Exception {
		// propiedades de conexion al servidor de correo
		this.from = from;
		this.subject = subject;
		this.to = to;

		String ipServidor = "localhost";
		String puertoServidor = "8081";
		String nombreAplicacion = "CANARYWHEY";
		String parametros = "misParametros";

		String cabecera = "<HTML><BODY><img src='cid:cidcabecera' /> <br/> <br/>";
		String pie = "<br/> <br/> <img src='cid:cidpie' /></BODY></HTML>";
		String boton = "<table><tr><td><form method='post' target='blank' action='http://" + ipServidor + ":"
				+ puertoServidor + "/" + nombreAplicacion + "/servlet/MiServlet?param=" + parametros
				+ "'> <input name='miBoton' type='submit' value='Boton' /></form>";
		String formulario = String.format("%s%s%s%s%s", cabecera, body, "<br/> <br/>", boton, pie);

		addContent(formulario);


		// enviar el correo MULTIPART
		sendMultipart();
	}

}
