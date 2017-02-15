class Config < ActiveRecord::Base
	validates :configuration_name, :presence => {:message => ' no puede ser vacío'}
	validates :configuration_value, :presence => {:message => ' no puede ser vacío'}

	CONFIG_DISCOUNT_NAME = 'Descuento'
	CONFIG_MINIMUM_PERCENTAGE_LOAD = 'Minimo para carga'
	CONFIG_MAXIMO_TARIMAS = 'Numero maximo de tarimas'
	CONFIG_CAJAS_TARIMA = 'Numero de cajas por tarima'

	def get_discount
		Config.all.where('active = ? AND configuration_name = ?', true, CONFIG_DISCOUNT_NAME).first;
	end

	def get_minimum_percentage_load
		Config.all.where('active = ? AND configuration_name = ?', true, CONFIG_MINIMUM_PERCENTAGE_LOAD).first;
	end

	def get_max_palet
		Config.all.where('active = ? AND configuration_name = ?', true, CONFIG_MAXIMO_TARIMAS).first;
	end

	def get_boxes_palet
		Config.all.where('active = ? AND configuration_name = ?', true, CONFIG_CAJAS_TARIMA).first;
	end
end