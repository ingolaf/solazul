class Box < ActiveRecord::Base
	has_many :articles
	has_many :inventories
end
