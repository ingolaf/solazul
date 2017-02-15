class LoadsController < ApplicationController
	def index
		@loads = Load.all
	end

	def new
		@load = Load.new
	end

	def edit
		@load = Load.find params[:id]
	end

	def update
    	@load = Load.find params[:id]

    	@sent_date = params[:load][:sent_date]

    	if ( (@sent_date.include? "/") )
    		@sent_date = params[:load][:sent_date].split('/')
    		@new_date = (@sent_date[2] + "-" + @sent_date[0] + "-" + @sent_date[1])
    		params[:load][:sent_date] = @new_date
		end

    	if @load.update_attributes(load_params)
      		redirect_to url_for(:controller => 'loads', :action => 'index'), notice: 'Registro actualizado correctamente'
  		else
			render :action => 'edit'
    	end
  	end

  	def show
  		@load = Load.find(params[:id])

  		@config             = Config.new
    	
    	@config_load        = @config.get_minimum_percentage_load
    	@config_max_palet   = @config.get_max_palet
    	@config_boxes_palet = @config.get_boxes_palet

    	#@order_total_boxes  = @order.articles.sum('quantity')
    	#@order_total_palets = @order_total_boxes > 0 ? (@order_total_boxes / @config_boxes_palet.configuration_value.to_f) : 0

    	@load_total_boxes = @load.orders.includes(:articles).sum('total_boxes')
    	@load_total_palets = @load_total_boxes > 0 ? (@load_total_boxes / @config_boxes_palet.configuration_value.to_f) : 0
	end

	def create
		@load = Load.new(load_params)
		@load.percentage_completed = 0
		@load.status = 'En progreso'

		@sent_date = params[:load][:sent_date].split('/')
    	@new_date = (@sent_date[2] + "-" + @sent_date[0] + "-" + @sent_date[1])
    	@load.sent_date = @new_date
    	
 		if @load.save
	    	redirect_to url_for(:controller => 'loads', :action => 'index'), notice: 'Registro agregado correctamente'
    	else
    		render :action => 'new'
		end
	end

	def load_params
    	params[:load].permit(:percentage_completed, :number, :sent_date, :order_number, :delivery_place)
  	end

  	def finalize
  		@order = Order.find(params[:order][:id])
  		@load = Load.find(@order.load_id)
  		@boxes = Box.all.where('active = ?', true)

  		@has_enough = true

  		@boxes.each do |box|
			if @load.has_enough_inventory(box.id)
				@has_enough = true
			else
				puts(box.id)
				@has_enough = false
				break
			end
		end
		#The inventory has enough items to places the order related with the load
		if (@has_enough)
			@orders = @load.orders

			@orders.each do |order|
				order.finalize
			end

			@load.status = 'Finalizada'
			@load.save
			redirect_to url_for(:controller => :orders, :action => :index), notice: 'Los pedidos se han enviado correctamente en la carga'
		else
			redirect_to url_for(:controller => :orders, :action => :show, :id => @order.id), notice: 'No existe suficiente inventario para todos los pedidos de la carga'
		end
	end


end
