package classesServlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ChangeMDP
 */
@WebServlet("/ChangeMDP")
public class ChangeMDP extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangeMDP() {
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
			String expassword=request.getParameter("Expasswd");
			String newpassword=request.getParameter("Newpasswd");
			String confirmpassword=request.getParameter("Confirmpasswd");
			String submitType=request.getParameter("submit");
			if(submitType.equals("Back to menu")) {
				request.getRequestDispatcher("menu.jsp").forward(request, response);
			}
			if(submitType.equals("Confirm")) {
				if(user!=null && userName!=null && userName!="" && expassword!=null && expassword!="" && newpassword!=null && newpassword!="" && confirmpassword!=null && confirmpassword!="") {
					 trouver=user.rechercherJoueur(userName, expassword);
					 if(trouver==1) {
						    int succes=0;
						    succes=user.modifierMDP(userName, newpassword);
						    if(succes==1) {
							request.setAttribute("successMessage","successful change");
							request.getRequestDispatcher("account.jsp").forward(request, response);
							}
					 }else {
							request.setAttribute("echecMessage","username does not exist");
							request.getRequestDispatcher("account.jsp").forward(request, response);
						}
				}else {
					request.setAttribute("echecMessage","fill in all fields");
					request.getRequestDispatcher("account.jsp").forward(request, response);
				}
			}
		}catch(Exception e) {
    		e.printStackTrace();
    		System.out.println("Exception is --->"+e);
    }
	}

}
