#encoding=utf-8
require 'digest/sha2'

class AdminUser < User
  def nav_links
    [
      ['管理员列表','/admin_users'],
      ['RPM列表' , '/rpm_orgs'],
      ['Cheil列表' , '/cheil_orgs'],
      ['Vendor列表', '/vendor_orgs'],
      ['payer列表', '/payers']
    ]
  end

  def home
    '/admin_users'
  end
end

