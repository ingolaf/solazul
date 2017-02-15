class Order < ActiveRecord::Base
	validates :load_id, :presence => {:message => ' no puede ser vacío'}
	validates :number, :presence => {:message => ' no puede ser vacío'}
	validates :customer_name, :presence => {:message => ' no puede ser vacío'}

	enum status: [:progress, :finalized, :canceled]
	enum order_type: [:inventory, :normal]

	has_many :articles
	belongs_to :load

	def update_total
		@total = self.articles.sum('total')

		self.total = @total
		self.save
	end

	def total_boxes
		@total = self.articles.sum('quantity')
	end

	def total_dozens_boxes
		@total = self.articles.sum('total_boxes')
	end

	def total_weight
		@total_weight = 0
		@articles = self.articles

		if @articles
			@articles.each do |article|
				@total_weight = @total_weight + (article.quantity * article.price.weight_by_dozen.to_f)
			end
		end

		return @total_weight
	end

	def finalize
		@articles = self.articles

  		if @articles
			@articles.each do |article|
				article.add_transaction
			end

			self.finalized!

			self.save

			#update the inventory
			@inventory = Inventory.new

			@factor = self.normal? ? -1 : 1

			@inventory.affect(@factor)
		end
	end
end