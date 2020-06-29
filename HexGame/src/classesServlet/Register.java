package classesServlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Register
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Register() {
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
			String name=request.getParameter("name");
			String password=request.getParameter("passwd");
			String submitType=request.getParameter("register");
			if(submitType.equals("Register") && user!=null && userName!=null && userName!="" && name!=null && name!="" && password!=null && password!="") {
				trouver=user.rechercherJoueur(userName);
				if(trouver==0) {
					user.ajouterJoueur(userName, name, password);
					request.setAttribute("successMessage","successful registration");
					request.getRequestDispatcher("menu.jsp").forward(request, response);//
				}else {
					request.setAttribute("echecMessage","Existing username");
					request.getRequestDispatcher("register.jsp").forward(request, response);
				}
	
			}else {
				request.setAttribute("echecMessage","fill in all fields");
				request.getRequestDispatcher("register.jsp").forward(request, response);
			}
			
			
		}catch(Exception e) {
    		e.printStackTrace();
    		System.out.println("Exception is --->"+e);
    	}
	}

}
