class RulesController < ApplicationController
	def index
		@rules = Rule.all
	end

	def new
		@rule = Rule.new
		@boxes = Box.all
	end

	def edit
		@rule = Rule.find params[:id]
		@boxes = Box.all
	end

	def update
    	@rule = Rule.find params[:id]
    	
    	#Set the active flag
		@rule.active = params[:active].to_i == 1

    	if @rule.update_attributes(rule_params)
      		redirect_to url_for(:controller => 'rules', :action => 'index'), notice: 'Registro actualizado correctamente'
  		else
  			@boxes = Box.all
			render :action => 'edit'
    	end
  	end

	def create
		@rule = Rule.new(rule_params)
		
		@rule.active = params[:active].to_i == 1
		
 		if @rule.save
	    	redirect_to url_for(:controller => 'rules', :action => 'index'), notice: 'Registro agregado correctamente'
    	else
    		@boxes = Box.all
    		render :action => 'new'
		end
	end

	def rule_params
    	params[:rule].permit(:percentage_load, :box_id, :max_discount, :active)
  	end
end
