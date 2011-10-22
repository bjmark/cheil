class AddSendCheilToBriefs < ActiveRecord::Migration
  def change
    add_column :briefs, :send_to_cheil, :string ,:limit=>1,:default=>'n'
  end
end
