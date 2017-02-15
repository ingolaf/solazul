class Article < ActiveRecord::Base
	belongs_to :order
	belongs_to :box
	belongs_to :price

	def add_transaction
		@transaction = Transaction.new
		@transaction.quantity = self.quantity
		@transaction.article_id = self.id
		@transaction.date = Date.today
		@transaction.active = 1
		@transaction.price_id = self.price_id
		@transaction.package = self.package
		@transaction.total_boxes = self.total_boxes
		
		@transaction.save
	end
end
