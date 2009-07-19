class FundsController < ApplicationController

  before_filter :has_privileges?

  # GET /funds
  # GET /funds.xml
  def index
    @funds = Fund.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @funds }
    end
  end

  # GET /funds/1
  # GET /funds/1.xml
  def show
    @fund = Fund.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fund }
    end
  end

  # GET /funds/new
  # GET /funds/new.xml
  def new
    @fund = Fund.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fund }
    end
  end

  # GET /funds/1/edit
  def edit
    @fund = Fund.find(params[:id])
  end

  # POST /funds
  # POST /funds.xml
  def create
    @fund = Fund.new(params[:fund])
    @fund.cash_amount = @fund.net_income - @fund.widthdrawal
    respond_to do |format|
      if @fund.save
        flash[:notice] = 'Marca creada exitosamente.'
        format.html { redirect_to expenses_path }
        format.xml  { render :xml => @fund, :status => :created, :location => @fund }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @fund.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /funds/1
  # PUT /funds/1.xml
  def update
    @fund = Fund.find(params[:id])
    previous_cash_amount = @fund.cash_amount
    respond_to do |format|
      if @fund.update_attributes(params[:fund])
        
        unless @fund == Fund.yesterday_fund(get_current_store)
          @fund.cash_amount = @fund.net_income - @fund.widthdrawal
        else
          tmp = previous_cash_amount - @fund.cash_amount 
          @todays_fund = Fund.todays_fund(get_current_store)
          @todays_fund.cash_amount -= tmp
          @todays_fund.save 
        end
        
        @fund.save
        flash[:notice] = 'Fondos actualizados.'
        format.html { redirect_to expenses_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @fund.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /funds/1
  # DELETE /funds/1.xml
  def destroy
    @fund = Fund.find(params[:id])
    @fund.destroy

    respond_to do |format|
      format.html { redirect_to(funds_url) }
      format.xml  { head :ok }
    end
  end
end
