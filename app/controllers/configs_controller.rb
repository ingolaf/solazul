class ConfigsController < ApplicationController
	def index
		@configs = Config.all
	end

	def new
		@config = Config.new
	end

	def edit
		@config = Config.find params[:id]
	end

	def create
		@config = Config.new(config_params)

		@config.active = params[:active].to_i == 1
		
 		if @config.save
	    	redirect_to url_for(:controller => 'configs', :action => 'index'), notice: 'Registro agregado correctamente'
    	else
    		render :action => 'new', notice: 'No fue posible agregar el registro, intenta nuevamente'
		end
	end

	def update
    	@config = Config.find params[:id]
    	
    	#Set the active flag
		@config.active = params[:active].to_i == 1

    	if @config.update_attributes(config_params)
      		redirect_to url_for(:controller => 'configs', :action => 'index'), notice: 'Registro actualizado correctamente'
  		else
			render :action => 'edit', notice: 'No fue posible agregar el registro, intenta nuevamente'
    	end
  	end

	def config_params
    	params[:config].permit(:configuration_name, :configuration_value, :active)
  	end
end
