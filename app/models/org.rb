class Org < ActiveRecord::Base
  has_many :users
  has_many :solutions
end
