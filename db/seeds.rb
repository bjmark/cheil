# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create(:name=>'mark',:password=>'123')

rpm1 = RpmOrg.create(:name=>'rpm_dep1')
rpm2 = RpmOrg.create(:name=>'rpm_dep2')

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
=begin
rpm_u1 = User.find_by_name('rpm_u1')
(1..10).each do |n|
   b = Brief.create(:name=>"brief#{n}",:org_id=>rpm1.id,:user_id=>rpm_u1.id)
   b.items << Item.new(:name=>"design#{n}",:kind=>'design')
   b.items << Item.new(:name=>"product1#{n}",:kind=>'product')
end
=end
