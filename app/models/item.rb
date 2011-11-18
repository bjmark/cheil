#encoding:utf-8
class Item < ActiveRecord::Base
  #item分两种情况
  #1.belongs to brief
  #2.belongs to brief_vendor,in this case,name,quantity,kind must take from his parent if it has a parent.
  #it has a parent if parent_id > 0
  #it has no parent if parent_id ==0

  
  def total
    a1 = quantity.to_f * price.to_f
    a2 = a1.to_i 
    a1 = a2 if a1 == a2
    return a1
  end
    
  def check_edit_right(a_user)
  end

  def belongs_to?(a_solution)
    a_solution.items.find{|e| e.id == id or e.parent_id == id}
  end

end
