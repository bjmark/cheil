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

end
