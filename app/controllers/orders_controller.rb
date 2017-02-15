class OrdersController < ApplicationController
	NUMBER_OF_ITEMS_FOR_NORMAL_SALE = 1
	NUMBER_OF_ITEMS_FOR_INVENTORY = 1

	def index
		@orders = Order.all.where('order_type = ?', 1).order(:load_id)
	end

	def new
		@order = Order.new
		@loads = Load.all.where('status <> ? AND percentage_completed < 100', 'Finalizada')
	end

	def show
    	@order = Order.find params[:id]
    	@articles = Order.find(@order.id).articles
    	@boxes = Box.all
    	@load = Load.find(@order.load_id)

    	@load_total_dozens = @load.orders.includes(:articles).sum('quantity')

    	@config             = Config.new
    	
    	@config_load        = @config.get_minimum_percentage_load
    	@config_max_palet   = @config.get_max_palet
    	@config_boxes_palet = @config.get_boxes_palet

    	@order_total_boxes  = @order.articles.sum('total_boxes')
    	@order_total_dozens = @order.articles.sum('quantity')
    	@order_total_palets = @order_total_boxes > 0 ? (@order_total_boxes / @config_boxes_palet.configuration_value.to_f) : 0

    	@order_total_weight = @order.total_weight
    	@load_total_weight = @load.total_weight

    	@load_total_boxes = @load.orders.includes(:articles).sum('total_boxes')
    	@load_total_palets = @load_total_boxes > 0 ? (@load_total_boxes / @config_boxes_palet.configuration_value.to_f) : 0

    	@rules_to_apply = @load.get_rules_by_percentage

    	@divisor = NUMBER_OF_ITEMS_FOR_NORMAL_SALE

    	@packages = {
        	'1' => 'Caja chica',
        	'2' => 'Caja grande'
      	}
	end

	def create
		@order = Order.new(order_params)
		@order.normal!
		@order.progress!

		@order.date = DateTime.now
		@order.active = params[:active].to_i == 1
		
 		if @order.save
 			redirect_to url_for(:controller => :orders, :action => :show, :id => @order.id), notice: 'Pedido registrado, ahora puedes agregar los ostiones a vender' 
    	else
    		render :action => 'new', notice: 'Hubo algunos problemas al ingresar los datos del pedido, intenta de nuevo'
		end
	end

	def order_params
    	params[:order].permit(:number, :customer_name, :date_placed, :percentage_complete, :active, :load_id, :package)
  	end

  	def finalize
  		@order = Order.find params[:order][:id]
  		@articles = Order.find(@order.id).articles

  		if @articles
			@articles.each do |article|
				article.add_transaction
			end

			@order.finalized!

			@order.save
			#update the inventory
			@inventory = Inventory.new

			@factor = @order.normal? ? -1 : 1

			@inventory.affect(@factor)
		end

		if (@order.normal?)
			redirect_to :action => 'index'
		else
			redirect_to :action => 'index', :controller => 'inventories'
		end
	end
end
