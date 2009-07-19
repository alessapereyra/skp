class LoginController < ApplicationController

  skip_before_filter :is_authenticated
  protect_from_forgery :except => [:authenticate, :login]
  

  def login
    @user = User.new
  end

  def authenticate
    @user = User.new(params[:user])

    unless @user.valid?
      flash[:notice] = "<em>Debe enviar todos los cambios</em>"
      redirect_to login_path

    else

      @server_user = User.find_by_username(@user.username)
      
      if @server_user.nil? || @user.nil?
        flash[:notice] = "<em>El usuario no existe</em>"
      redirect_to login_path
      
    else
      
      
       if @user.password == @server_user.password 

          session[:logged_user] = @user.username
          set_current_store(@server_user.store_id) unless @server_user.store_id.nil?
          set_current_store(3) if @user.username == "almacen"
        
          if @server_user.admin? 
            set_current_store(params[:user][:store_id])
          end #es admin
                
          redirect_to session[:last_url] || order_path
    
      else
   
        flash[:notice] = "<em>Usuario o contrase&ntilde;a err&oacute;neos</em>"      
        redirect_to :action=>:login
   
      end # password erróneo
      
      
    end   # usuario no existe
   
    end  # usuario no valido
    
  end

  def logout

    session[:logged_user] = nil
    reset_session
    redirect_to :action=>:login

  end


end