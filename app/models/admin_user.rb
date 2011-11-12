#encoding=utf-8
require 'digest/sha2'

class AdminUser < User
  validates :name, :uniqueness => true

  def password
    ''
  end

  def password=(s)
    self.salt = self.object_id.to_s + rand.to_s
    self.hashed_password = AdminUser.encrypt_password(s, self.salt)
  end

  def AdminUser.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "wibble" + salt)
  end

  def AdminUser.check_pass(name,pass)
    return nil unless u = AdminUser.find_by_name(name)
    if u.hashed_password == AdminUser.encrypt_password(pass, u.salt)
      return u
    end
    return nil
  end

  def nav_links
    [
      ['管理员帐号','/users/admin'],
      ['RPM' , '/rpm_orgs'],
      ['Cheil' , '/cheil_orgs'],
      ['Vendor', '/vendor_orgs_path']
    ]
  end

  def home
    '/admins'
  end
end

