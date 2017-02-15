class BoxesController < ApplicationController
	def index
		@boxes = Box.all
	end

	def new
	end

	def edit
		@box = Box.find params[:id]
	end

	def create
		@box = Box.new(box_params)
		#Set the active flag
		@box.active = params[:active].to_i == 1
		@box.price = 0
 		if @box.save
	    	redirect_to url_for(:controller => 'boxes', :action => 'index'), notice: 'Registro agregado correctamente'
    	else
    		render :action => 'new', notice: 'Se encontaron algunos errores, intenta de nuevo'
		end
	end

	def update
    	@box = Box.find params[:id]

    	#Set the active flag
		@box.active = params[:active].to_i == 1

    	if @box.update_attributes(box_params)
      		redirect_to url_for(:controller => 'boxes', :action => 'index'), notice: 'Registro actualizado correctamente'
  		else
			render :action => 'edit', notice: 'Se encontaron algunos errores, intenta de nuevo'
    	end
  	end

	def box_params
    	params[:box].permit(:description, :price, :capacity, :minimum_percentage_load, :active)
  	end
end
