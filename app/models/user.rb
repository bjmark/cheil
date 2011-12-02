#encoding=utf-8
class User < ActiveRecord::Base
  belongs_to :org

  validates_presence_of :name , :message=>'不可为空'
  validates_presence_of :password , :on=>:create,:message=>'不可为空'
  validates_uniqueness_of :name , :message=>'已存在'

  def password
    ''
  end

  def password=(s)
    return if s.blank?
    self.salt = self.object_id.to_s + rand.to_s
    self.hashed_password = User.encrypt_password(s, self.salt)
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  def User.check_pass(name,pass)
    return nil unless u = User.find_by_name(name)
    if u.hashed_password == User.encrypt_password(pass, u.salt)
      return u
    end
    return nil
  end

  def nav_links
    org.nav_links
  end

  def home
    '/briefs'
  end
end
