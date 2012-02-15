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
      org_id = org_id.to_i
      hash = read_from(target)
      return false unless hash[org_id]
      hash[org_id].include?(right_type)
    end

    def set(target,org_ids,*rights)
      org_ids = [org_ids] unless org_ids.instance_of?(Array)
      org_ids = org_ids.collect{|e| e.to_i}

      hash = read_from(target)
      
      org_ids.each{|i| hash[i] = rights}

      write_to(target,hash)
    end

    def add(target,org_ids,*rights)
      org_ids = [org_ids] unless org_ids.instance_of?(Array)
      org_ids = org_ids.collect{|e| e.to_i}

      hash = read_from(target)

      org_ids.each do |i|
        if hash[i] 
          hash[i] += rights 
        else
          hash[i] = rights
        end
      end

      write_to(target,hash)
    end

    # del_help([1,2,2,3],[1,2]) = [2,3]
    def del_help(a,b)
      h = {}
      a.each do |e|
        if h[e] 
          h[e] +=1
        else
          h[e] = 1
        end
      end

      b.each do |i|
        h[i] -= 1 if h[i]
      end

      c = []

      h.each do |k,v|
        c += [k] * v
      end
      
      return c
    end

    def del(target,org_ids,*rights)
      org_ids = [org_ids] unless org_ids.instance_of?(Array)
      org_ids = org_ids.collect{|e| e.to_i}

      hash = read_from(target)

      org_ids.each do |i|
        if hash[i] 
          hash[i] = del_help(hash[i],rights)
        end
      end

      write_to(target,hash)
    end

    def who_has(target,right)
      hash = read_from(target)
      org_ids = []
      hash.each do |k,v|
        org_ids << k if v.include?(right) 
      end
      return org_ids
    end
  end

  class OpNotice
    def initialize(obj)
      @obj = obj
    end

    def read
      s = @obj.notice
      s.blank? ? [] : s.split(',')
    end

    def write(a)
      @obj.notice = a.join(',')
    end

    def add(org_ids)
      org_ids = [org_ids] unless org_ids.instance_of?(Array)
      org_ids = org_ids.collect{|e| e.to_s}
      write(read - org_ids + org_ids)
    end

    def del(org_ids)
      org_ids = [org_ids] unless org_ids.instance_of?(Array)
      org_ids = org_ids.collect{|e| e.to_s}
      write(read - org_ids)
    end

    def include?(org_id)
      read.include?(org_id.to_s)
    end

    def changed_by(_org_id)
      ids = @obj.op_right.who_has('self','read') - [_org_id]
      self.add(ids) unless ids.blank?
      return ids
    end
  end

  def Cheil.test(s)
    File.open(File.join(Rails.root,'test'),'a') do |f|
      f.puts s
    end
  end
end
