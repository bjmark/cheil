class Payment < ActiveRecord::Base
  belongs_to :solution
  belongs_to :payer
  belongs_to :org
=begin
  def amount
    v = (read_attribute(:amount) or 0)
    v == 0 ? v : v.to_f
  end
=end
end
