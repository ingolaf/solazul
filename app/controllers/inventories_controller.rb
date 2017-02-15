class InventoriesController < ApplicationController
	 ORDER_TYPE_INVENTORY = 0
	 ORDER_TYPE_ORDER = 1
	 ORDER_CUSTOMER_NAME_INVENTORY = 'Inventory Customer'
	 ORDER_LOAD_ID = 0

	def index
		@boxes = Box.all
		@inventories = []

		if @boxes
			@boxes.each do |box|
				@inventory = Inventory.order("update_date DESC").where("box_id = ? AND package = ?", box.id, "1").first
				if !@inventory.nil?
					@inventories << @inventory
				end
			end
		end
	end

	def new
		@order = nil
		if(params.has_key?(:id))
			@order = Order.find params[:id]
		end

		@articles = nil
		if (@order)
    		@articles = Order.find(@order.id).articles
		end

    	@boxes = Box.all
    	@packages = {
        	'1' => 'Caja chica',
        	'2' => 'Caja grande'
      	}
	end

	def show
		@order = nil
		if(params.has_key?(:id))
			@order = Order.find params[:id]
		end

		@articles = nil
		if (@order)
    		@articles = Order.articles
		end

		@boxes = Box.all
	end

	def create
		@price = Price.find_by box_id: params[:article][:box_id]

		if (!@price.nil?)
			#The record for the order doesn't exist, and it must created before to add the relation with the article
			if(params[:article][:order_id].nil? || params[:article][:order_id] == 0 || params[:article][:order_id] == "0")
				@order = Order.new
				@max_number = Order.where('order_type = ?', ORDER_TYPE_INVENTORY).maximum('number');
				@max_number = @max_number ? @max_number.to_i + 1 : 1

				@order.number = @max_number
				@order.customer_name = ORDER_CUSTOMER_NAME_INVENTORY
				@order.date = Time.now.to_datetime
				@order.active = 1
				@order.status = 1
				@order.load_id = ORDER_LOAD_ID
				@order.inventory!

				@order.save

				params[:article][:order_id] = @order.id
			end

			params[:article][:price_id] = @price.id
			
			@article = Article.new(inventory_params)
			@article.unit_price = 0
			@article.package = "1"
			@article.total_boxes = @price.get_total_boxes(@article.quantity, @article.package)
			@article.total = 0

			if(params[:article][:order_id].nil?)
				@article.order_id = @order.id
			end

			if @article.save
	 			redirect_to url_for(:controller => :inventories, :action => :new, :id => @article.order_id), notice: "Cajas adjuntadas correctamente"
	    	else
	    		#Same URL?? Let's wait for more development
	    		redirect_to url_for(:controller => :inventories, :action => :new, :id => @article.order_id)
			end
		else
			if params[:article][:order_id] > 0
				redirect_to url_for(:controller => :inventories, :action => :new, :id => params[:article][:order_id]), notice: "No se ha configurado aun el catálogo de precios con los datos ingresados"
			else
				redirect_to url_for(:controller => :inventories, :action => :new), notice: "No se ha configurado aun el catálogo de precios con los datos ingresados"
			end
		end
		
	end

	def inventory_params
		params[:article].permit(:box_id, :quantity, :order_id, :package, :price_id)
	end

	def show
	end
end
