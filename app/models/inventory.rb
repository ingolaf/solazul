class Inventory < ActiveRecord::Base
	NUMBER_OF_ITEMS_FOR_NORMAL_SALE = 1
	NUMBER_OF_ITEMS_FOR_INVENTORY = 1

	belongs_to :box

	def affect (factor)
		@boxes = Box.all

		if @boxes
			@boxes.each do |box|
				#First step to review the small box
				@inventory = Inventory.where(["box_id = ? AND package = ?", box.id, "1"]).order("update_date DESC").last


				if (@inventory)
					@total_by_box = Transaction.joins("INNER JOIN articles ON transactions.article_id = articles.id").
									where("articles.box_id = ? AND transactions.created_at > ?", box.id, @inventory.update_date).sum(:quantity)
				else
					@total_by_box = Transaction.joins("INNER JOIN articles ON transactions.article_id = articles.id").
									where("articles.box_id = ?", box.id).sum(:quantity)
				end

				@total = ((@total_by_box ? @total_by_box : 0) * factor)  
				@total_inventory = (@inventory ? @inventory.quantity : 0)

				@new_inventory = Inventory.new
				@new_inventory.box_id = box.id
				@new_inventory.update_date = Time.now.to_datetime
				@new_inventory.quantity = @total + @total_inventory
				@new_inventory.package = "1"

				@new_inventory.save

			end
		end
	end

	def check_availability(article)
		#Sum the total of boxes added previously to the oder
		@total_current_box = Article.all.where('order_id = ? AND box_id = ?', article.order_id, article.box_id).sum('quantity')
		#puts("Total boxes")
		#puts(@total_current_box);
		@inventory = Inventory.order("update_date DESC").where("box_id = ?", article.box_id).first
		#puts("Inventory quantity")
		#puts(@inventory.quantity)
		@is_available = true
		#puts(NUMBER_OF_ITEMS_FOR_NORMAL_SALE)

		#puts("Condition")
		#@totalote = @inventory.quantity - (@total_current_box+(article.quantity*NUMBER_OF_ITEMS_FOR_NORMAL_SALE))
		#puts(@totalote)
		
		if @inventory
			#Id the boxes for the same type plus the current one that is desired to add, is lower than current inventory
			# the flag to add is TRUE, otherwise FALSE
			if (@inventory.quantity - (@total_current_box+(article.quantity*NUMBER_OF_ITEMS_FOR_NORMAL_SALE)) > 0)
				@is_available = true
			else
				@is_available = false
			end
		else
			@is_available = false
		end

		return @is_available
	end
end
