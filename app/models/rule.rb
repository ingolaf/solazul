class Rule < ActiveRecord::Base
	validates :box_id, :presence => {:message => ' no puede ser vacío'}
	validates :percentage_load, :presence => {:message => ' no puede ser vacío'}
	validates :max_discount, :presence => {:message => ' no puede ser vacío'}

	belongs_to :box
end
