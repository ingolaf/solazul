class ArticlesController < ApplicationController
	NUMBER_OF_ITEMS_FOR_NORMAL_SALE = 1
	NUMBER_OF_ITEMS_FOR_INVENTORY = 1

	def create
		@box = Box.find(params[:article][:box_id])
		@price = Price.find_by box_id: params[:article][:box_id]

		#If we don't have a configuration for the SIZE on prices lookup table
		if (@price.nil?)
			redirect_to url_for(:controller => :orders, :action => :show, :id => params[:article][:order_id]), notice: 'No existe una configuración de precio para la talla de ostión seleccionada'
		end

		#See if the price passed in the params array is empty o zero and use the price configured on the catalog
		if (!params[:article][:unit_price] || params[:article][:unit_price] == "" || params[:article][:unit_price] == 0 )
			params[:article][:unit_price] =  @price.price_by_dozen
		end
		#Same verification for the discount
		if (!params[:article][:discount] || params[:article][:discount] == ""  )
			params[:article][:discount] = 0
		end

		@article = Article.new(article_params)
		@article.price_id = @price.id
		@article.package = params[:package]
		@article.total_boxes = @price.get_total_boxes(@article.quantity, @article.package)

		@order   = Order.find(@article.order_id)
		@load = Load.find(@order.load_id)

		#Convert the quantity to the correct UNITS
		@article.quantity = @order.normal? ? (@article.quantity * NUMBER_OF_ITEMS_FOR_NORMAL_SALE) : (@article.quantity * NUMBER_OF_ITEMS_FOR_INVENTORY)

		#Check if the load still having enough space
		@can_be_added = @load.validate_percentage_to_update(@article.quantity)

		if (@can_be_added)
			#Let's validate the discount added to the article
			@is_discount_valid = @load.validate_rule(@article)
			
			if @is_discount_valid

				@inventory = Inventory.new
				@is_available = @inventory.check_availability(@article)

				if @is_available
			 		if @article.save
			 			#Calcuation total after insert
			 			@price_to_use = @article.discount > 0 ? (@article.unit_price - (@article.unit_price*(@article.discount/100))) : @article.unit_price
			 			@article_quantity =@order.normal? ? (@article.quantity / NUMBER_OF_ITEMS_FOR_NORMAL_SALE) : (@article.quantity / NUMBER_OF_ITEMS_FOR_INVENTORY)
			 			@article.total = @price_to_use * @article_quantity
			 			@article.save

			 			@order.update_total
						@load.update_percentage_load
			 			
				    	redirect_to url_for(:controller => :orders, :action => :show, :id => @article.order_id), notice: 'Cajas agredas correctamente'
			    	else
			    		#Same URL?? Let's wait for more development
			    		redirect_to url_for(:controller => :orders, :action => :show, :id => @article.order_id), notice: 'El descuento que se intenta otorgar aun no es permitido'
					end
				else 
					redirect_to url_for(:controller => :orders, :action => :show, :id => @article.order_id), notice: 'No existe suficiente inventario para vender'
				end
			else
				redirect_to url_for(:controller => :orders, :action => :show, :id => @article.order_id), notice: 'El descuento que se intenta otorgar aun no es permitido'
				#render :template => 'orders/show',  :params => { :id => @article.order_id }, notice: 'El descuento que se intenta otorgar aun no es permitido'
			end
		else
			redirect_to url_for(:controller => :orders, :action => :show, :id => @article.order_id), notice: 'No se puede agregar el item, porque superaría le capacidad máxima de carga'
		end
	end

	def destroy
	  @article = Article.find(params[:id])
	  @order = Order.find(@article.order_id)

	  @article.destroy

	  

	  if @order.normal?
	  	@load = Load.find(@order.load_id)

	  	@load.update_percentage_load
	  	@order.update_total
	  	redirect_to url_for(:controller => :orders, :action => :show, :id => @order.id), notice: 'Item removido del pedido correctamente'
	  else
	  	redirect_to url_for(:controller => :inventories, :action => :new, :id => @order.id), notice: 'Item removido de la afectación de inventario'
  	  end
	end

	def article_params
    	params[:article].permit(:box_id, :quantity, :unit_price, :order_id, :discount, :package, :description)
  	end
end
