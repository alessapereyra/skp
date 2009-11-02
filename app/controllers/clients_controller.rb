class ClientsController < ApplicationController


  before_filter [:has_privileges?,:no_cache]

  # GET /clients
  # GET /clients.xml
  def index
    @clients = Client.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
      format.js {render :text => @client.to_json, :layout=>false}
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        flash[:notice] = 'Cliente creado exitosamente.'
        format.html { redirect_to clients_path }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'Cliente actualizado exitosamente.'
        format.html { redirect_to clients_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
  
  def search_client

       respond_to do |wants|        
         wants.js { 

           search = ""
           search = params[:client][:name] if params[:client]
           search = params["q"] if params["q"]
           render :update do |page|
             #CHANGE THIS
             @clients = Client.search  '"*' + search + '*"' # :limit => 15 #:conditions=>"status NOT LIKE 'pendiente'", 
             #@clients = Client.find_all_by_name("*" + params["q"]+"*",:limit => 15)        
             page.replace 'detalle', :partial => 'client_list'
             page.visual_effect :highlight, 'list'                
           end

           }

       end

   end
   
   
end
