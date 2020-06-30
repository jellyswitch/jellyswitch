# typed: true
class SessionsController < ApplicationController
  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?
    users = User.where(email: params[:session][:email].downcase, admin: true)

    if users.count < 1
      flash[:error] = "No such user found."
      turbolinks_redirect(new_session_path)
    elsif users.count == 1
      if users.first.superadmin?
        # redirect to password form
        session[:email] = users.first.email
        turbolinks_redirect(password_form_path)
      else
        turbolinks_redirect( landing_url(subdomain: users.first.operator.subdomain) )
      end
    else
      # redirect to choose_operator
      session[:email] = params[:session][:email].downcase
      turbolinks_redirect(choose_operator_path)
    end
  end

  def choose_operator
    email = session[:email]

    users = User.where(email: email, superadmin: false, admin: true)
    @operators = users.collect(&:operator).uniq.compact
  end

  def password_form
    email = session[:email]
    
    @user = User.find_by(email: email, superadmin: true)
    if @user.blank?
      flash[:error] = "No such user."
      turbolinks_redirect(new_session_path)
    end
  end

  def real_create
    # for admins only
    user = User.find_by(email: params[:session][:email].downcase, superadmin: true)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      remember(user)
      redirect_to operators_path
    else
      flash[:error] = "Invalid email/password combination."
      turbolinks_redirect(password_form_path)
    end
  end

  def destroy
    log_out
    turbolinks_redirect(root_path, action: "restore")
  end
end
