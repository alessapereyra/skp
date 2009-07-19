class LoginController < ApplicationController

  skip_before_filter :is_authenticated

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

          set_current_store(@server_user.store_id) unless @server_user.store_id.nil?
        
          session[:logged_user] = @user.username
        
          if @server_user.admin? 
            set_current_store(params[:user][:store_id])
          end #es admin
                
          redirect_to session[:last_url]
    
      else
   
        flash[:notice] = "<em>Usuario o contrase&ntilde;a err&oacute;neos</em>"      
        redirect_to :action=>:login
   
      end # password erróneo
      
      
    end   # usuario no existe
   
    end  # usuario no valido
    
  end

  def logout

    session[:logged_user] = nil
    redirect_to :action=>:login

  end


end