class Price < ActiveRecord::Base
	ID_SMALL_BOX = 1
	ID_BIG_BOX = 2

	validates :box_id, :presence => {:message => ' no puede ser vacío'}
	validates :box_size_small, :presence => {:message => ' no puede ser vacío'}
	validates :box_size_big, :presence => {:message => ' no puede ser vacío'}
	validates :price_by_dozen, :presence => {:message => ' no puede ser vacío'}
	validates :weight_by_dozen, :presence => {:message => ' no puedes ser vacío'}

	belongs_to :box
	has_many :articles

	def get_total_boxes(quantity, package)
		#The param is the quantity of dozens added by the user, so, the number of boxes should be calculated
		#through the division between the quantity and the size of boxes. The result is rounded.
		#The number of boxes is calcualted jut for infomation, because the total of dozens by ORDER can be distinct

		@total_boxes = (quantity/(package.to_i == ID_SMALL_BOX ? self.box_size_small : self.box_size_big)).ceil

		@module = (quantity % (package.to_i == ID_SMALL_BOX ? self.box_size_small : self.box_size_big))

		if @module > 0 
			@total_boxes = @total_boxes + 1
		end

		return @total_boxes
	end
end
