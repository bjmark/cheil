#encoding=utf-8
class Org < ActiveRecord::Base
  validates_presence_of :name , :message => '不可为空'

  has_many :users
  has_many :solutions
end
