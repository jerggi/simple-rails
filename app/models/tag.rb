class Tag < ActiveRecord::Base
  has_many :parts
  has_many :posts, through: :parts
end
