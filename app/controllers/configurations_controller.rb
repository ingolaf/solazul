class ConfigurationsController < ApplicationController
	def index
		@configurations = Configuration.All
	end

	def new
	end

	def create
		@configuration = Configuration.new(configuration_params)
		
 		if @configuration.save
	    	redirect_to :action => 'index'
    	else
    		render :action => 'new'
		end
	end

	def configuration_params
    	params[:configuration].permit(:configuration_name, :configuration_value, :active)
  	end
end
