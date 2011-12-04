#encoding=utf-8
class Payer < ActiveRecord::Base
  validates_presence_of :name , :message => '不可为空'
  validates_uniqueness_of :name,:message=>'已存在' 
end
