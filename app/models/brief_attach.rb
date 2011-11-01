class BriefAttach < ActiveRecord::Base
  has_attached_file :attach,:path => ":rails_root/attach_files/:id/:filename" 
end
