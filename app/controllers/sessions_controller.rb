class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      Rails.cache.write("user_id", @user.id)
      flash[:success] = "Has iniciado sesión " + @user.name + " " + @user.last_name
      #flash[:success] = "Has iniciado sesión " + @user.name + " " + @user.last_name + " id:" + Rails.cache.read("foo")
      redirect_to "/"
    else      
      flash[:danger] = "Lo sentimos, no has podido iniciar sesión, verifica tus credenciales"
      redirect_to init_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Has cerrado sesión "
    redirect_to "/"
  end

end