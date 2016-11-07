class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session_user = request.remote_ip.to_s + request.env['HTTP_USER_AGENT'].to_s
      Rails.cache.write(session_user, @user.id)
      flash[:success] = "Has iniciado sesión " + @user.name + " " + @user.last_name
      redirect_to "/"
    else      
      flash[:danger] = "Lo sentimos, no has podido iniciar sesión, verifica tus credenciales"
      redirect_to init_session_path
    end
  end

  def destroy
    session_user = request.remote_ip.to_s + request.env['HTTP_USER_AGENT'].to_s
    Rails.cache.write(session_user, nil)
    #session[:user_id] = nil
    flash[:success] = "Has cerrado sesión "
    redirect_to "/"
  end

end