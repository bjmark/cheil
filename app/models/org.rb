class Org < ActiveRecord::Base
  has_many :users
  has_many :briefs
  has_many :brief_vendors
  validates :name,:role,:presence => true
  validates :name, :uniqueness => true
end
