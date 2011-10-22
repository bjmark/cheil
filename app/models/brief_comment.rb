class BriefComment < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
end
