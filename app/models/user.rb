class User < ActiveRecord::Base
  #belongs_to :rpm_org, :foreign_key=>:org_id
  #belongs_to :cheil_org, :foreign_key=>:org_id
  #belongs_to :vendor_org, :foreign_key=>:org_id
  belongs_to :org

  validates :name, :uniqueness => true
  validates :name, :presence => true

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
