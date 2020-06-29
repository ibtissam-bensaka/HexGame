package classesServlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//doGet(request, response);
		int trouver;
		try {
			Joueur user=new Joueur();
			String userName=request.getParameter("username");
			String password=request.getParameter("passwd");
			String submitType=request.getParameter("login");
			if(submitType.equals("Login") && user!=null && userName!=null && userName!="" && password!=null && password!="") {
				trouver=user.rechercherJoueur(userName, password);
				if(trouver==1) {
					request.setAttribute("successMessage","successful authentication");
					request.getRequestDispatcher("menu.jsp").forward(request, response);//
				}else {
					request.setAttribute("echecMessage","username does not exist");
					request.getRequestDispatcher("login.jsp").forward(request, response);
				}
			}else {
				request.setAttribute("echecMessage","fill in all fields");
				request.getRequestDispatcher("login.jsp").forward(request, response);
			}
			}catch(Exception e) {
	    		e.printStackTrace();
	    		System.out.println("Exception is --->"+e);
	    }
	}
}

