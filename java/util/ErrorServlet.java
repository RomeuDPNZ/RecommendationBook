
package recBook;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

/* javac -cp .;%CATALINA_HOME%\lib\servlet-api.jar ErrorServlet.java */

public class ErrorServlet extends HttpServlet {

	public ErrorServlet() {
		
	}

	public void Redireciona(HttpServletResponse response) throws ServletException, IOException {

		response.sendRedirect("Error.jsp?error=Teste");

	}

}