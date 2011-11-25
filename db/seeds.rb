# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create(:name=>'admin',:password=>'123')

rpm1 = RpmOrg.create(:name=>'rpm1')
rpm2 = RpmOrg.create(:name=>'rpm2')

rpm1.users << User.new(:name=>'rpm_u1',:password=>'123')
rpm2.users << User.new(:name=>'rpm_u2',:password=>'123')

cheil1 = rpm1.create_cheil_org(:name=>rpm1.name)
cheil2 = rpm2.create_cheil_org(:name=>rpm2.name)

cheil1.users << User.new(:name=>'cheil_u1',:password=>'123')
cheil2.users << User.new(:name=>'cheil_u2',:password=>'123')

vendor1 = VendorOrg.create(:name=>'vendor1')
vendor1.users << User.new(:name=>'vendor1_u1',:password=>'123')

vendor2 = VendorOrg.create(:name=>'vendor2')
vendor2.users << User.new(:name=>'vendor2_u1',:password=>'123')

(1..100).each do |i|
  brief = rpm1.briefs.create(:name=>"brief#{i}",:deadline=>i.day.from_now)
  brief.send_to_cheil!
  brief.vendor_solutions.create(:org_id=>vendor1.id) 
end
