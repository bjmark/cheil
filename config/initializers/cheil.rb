require 'yaml'

module Cheil
  class Op
    def initialize(obj)
      @obj = obj
    end

    def save_by(user_id)
      @obj.read_by = user_id.to_s
      if @obj.save
        return true
      end
      return false
    end

    def read_by(user_id)
      ids = read_by_to_a
      user_id = user_id.to_s

      unless ids.include?(user_id)
        ids << user_id
        @obj.read_by = ids.join(',')
        @obj.save
      end
    end

    def read_by_to_a
      if @obj.read_by.blank?
        []
      else
        @obj.read_by.split(',')
      end
    end

    def read?(user_id)
      read_by_to_a.include?(user_id.to_s)
    end

    def touch(user_id)
      @obj.updated_at = Time.now
      @obj.read_by = user_id.to_s
      @obj.save
    end
  end

  class OpRight
    def initialize(obj)
      @obj = obj
    end

    def read_from(target)
      attr_name = "#{target}_right"
      attr_value = @obj.send(attr_name) 
      attr_value.blank? ? {} : YAML.load(attr_value)
    end

    def write_to(target,value)
      @obj.send("#{target}_right=",value.to_yaml)
    end
=begin
right structure as follwing
{1=>['read','update'],2=>['delete']}
=end

    #target = attr_name saving right value
    #org_id 
    #right_type should be one of 'read','update','delete','create'
    def check(target,org_id,right_type)
      hash = read_from(target)
      return false unless hash[org_id]
      hash[org_id].include?(right_type)
    end

    def set(target,org_id,*rights)
      hash = read_from(target)
      hash[org_id] = rights
      write_to(target,hash)
    end

    def add(target,org_id,*rights)
      hash = read_from(target)
      if hash[org_id] 
        hash[org_id] += rights-hash[org_id]
      else
        hash[org_id] = rights
      end
      write_to(target,hash)
    end

    def del(target,org_id,*rights)
      hash = read_from(target)
      if hash[org_id] 
        hash[org_id] -= rights
        write_to(target,hash)
      end
    end
  end

  def Cheil.test(s)
    File.open(File.join(Rails.root,'test'),'a') do |f|
      f.puts s
    end
  end
end
