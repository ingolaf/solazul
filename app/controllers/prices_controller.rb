class PricesController < ApplicationController
	def index
		@prices = Price.all
	end

	def new
		@price = Price.new
		@boxes = Box.all
	end

	def edit
		@price = Price.find params[:id]
		@boxes = Box.all
	end

	def create
		@price = Price.new(price_params)
		@boxes = Box.all

 		if @price.save
	    	redirect_to url_for(:controller => 'prices', :action => 'index'), notice: 'Registro agregado correctamente'
    	else
    		render :action => 'new', notice: 'Se encontaron algunos errores, intenta de nuevo'
		end
	end

	def update
    	@price = Price.find params[:id]
    	@boxes = Box.all

    	if @price.update_attributes(price_params)
      		redirect_to url_for(:controller => 'prices', :action => 'index'), notice: 'Registro actualizado correctamente'
  		else
			render :action => 'edit', notice: 'Se encontaron algunos errores, intenta de nuevo'
    	end
  	end

  	def price_params
    	params[:price].permit(:box_id, :box_size_small, :box_size_big, :dozens_by_size, :price_by_dozen, :weight_by_dozen)
  	end
end
