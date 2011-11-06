class BriefAttach < Attach
  belongs_to :brief,:foreign_key => 'fk_id'
end
