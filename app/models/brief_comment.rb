class BriefComment < Comment
  belongs_to :brief,:foreign_key => 'fk_id'
  belongs_to :user
end
