class Load < ActiveRecord::Base
	validates :number, :presence => {:message => ' no puede ser vacío'}
	
	has_many :orders

	def total_weight
		@total_weight = 0
		@orders = self.orders

		if @orders
			@orders.each do |order|
				@total_weight = @total_weight + order.total_weight
			end
		end

		return @total_weight
	end

	def validate_percentage_to_update(quantity)
		@config                = Config.new
    	
		@config_max_palet   = @config.get_max_palet
		@config_boxes_palet = @config.get_boxes_palet

		@total_boxes_by_load = @config_max_palet.configuration_value.to_f * @config_boxes_palet.configuration_value.to_f

		@total_boxes_added = self.orders.includes(:articles).sum('total_boxes')

		@can_be_added_to_load = true

		if ( (@total_boxes_added + quantity) > @total_boxes_by_load)
			@can_be_added_to_load = false
		end

		return @can_be_added_to_load
	end

	def update_percentage_load
		@total_boxes = self.orders.includes(:articles).sum('total_boxes')

		@config                = Config.new
    	
		@config_max_palet   = @config.get_max_palet
		@config_boxes_palet = @config.get_boxes_palet

		@boxes_palet = @config_boxes_palet.configuration_value
		
		@tarimas_completas = (@total_boxes.to_f / @boxes_palet.to_f)
		@numero_maximo_cajas = (@config_boxes_palet.configuration_value.to_f * @config_max_palet.configuration_value.to_f)

		@percentage_load = ( (@total_boxes * 100) / @numero_maximo_cajas ) ;

		self.percentage_completed = @percentage_load

		self.save
	end

	def has_enough_inventory(box_id)
		@total_boxes = self.orders.includes(:articles).where('box_id = ?', box_id).sum('quantity')
		@inventory = Inventory.order("update_date DESC").where("box_id = ?", box_id).first

		@is_enough = false
		if @total_boxes && @total_boxes > 0 
			if ((@inventory.quantity - @total_boxes) > 0)
				@is_enough = true
			end
		else
			#If this piece of code is executed, it means that we don´t have data added to the load for the current box
			@is_enough = true
		end
		
		return @is_enough
	end

	def get_rules_by_percentage
		@config = Config.new
		@config_load = @config.get_minimum_percentage_load

		@boxes = Box.all.where('active = ?', true)

		@rules_to_apply = []

		if (self.percentage_completed.to_f >= @config_load.configuration_value.to_f)
			puts("Searching rules")
			@boxes.each do |box|
				@rule = Rule.all.where('box_id = ? AND percentage_load > ?', box.id,  self.percentage_completed).order('percentage_load ASC').first
				
				if (@rule)
					@rules_to_apply << @rule
				end
			end
		end
		return @rules_to_apply
	end

	def validate_rule (article)
		@is_valid = true

		@rule = Rule.all.where('box_id = ? AND percentage_load > ?', article.box_id,  self.percentage_completed).order('percentage_load ASC').first

		if article.discount > 0 #Discount was added on the form to add the article
			if (@rule)
				if (@rule.max_discount >= article.discount ) #The discount entered id the greater that the one allowed by the rule
					@is_valid = true
				else
					@is_valid = false
				end
			else
				@is_valid = true
			end
		else
			@is_valid = true
		end #Discount was added on the form to add the article

		return @is_valid
	end
end
