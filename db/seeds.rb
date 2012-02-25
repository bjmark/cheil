#coding=utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create(:name=>'admin',:password=>'123')
rpm = {
  'TV/Color Television' => 'rpm_tv',
  'DVD' => 'rpm_dvd',
  'Refrigerator' => 'rpm_ref',
  'Washing Machine' => 'rpm_was',
  'Air Cleaner' => 'rpm_air',
  'HHP/Anycall' => 'rpm_hhp',
  'MP3 Player(Tab)' => 'rpm_mp3',
  'Notebook PC' => 'rpm_not',
  'Monitor' => 'rpm_mon',
  'Printer' => 'rpm_pri',
  'B2B' => 'rpm_b2b',
  'Camera/Digital Camera' => 'rpm_cam',
  'Camcorder' => 'rpm_camc',
  '人事Team' => 'rpm_tea',
  'Brand Shop' => 'rpm_bra'
}

rpm.each do |k,v|
  r = RpmOrg.create(:name=>k)
  r.users.create(:name=>v,:password=>'123')

  c = r.create_cheil_org(:name=>"Cheil #{k}")
  c.users.create(:name=>v.gsub(/rpm_/,'cheil_'),:password=>'123')
end

vendor = {
  '北京奥富万广告有限公司' => 'aofu',
  '易事特展览设备（北京）有限公司' => 'yishite',
  '北京因特费斯展览设计有限公司' => 'yintefeisi',
  '北京亮彩一品广告有限公司' => 'liangcai',
  '北京奥比广告有限公司' => 'aobi',
  '北京合众凯臣广告传媒有限公司' => 'hezhong',
  '北京橙果岭广告有限公司' =>	'chengguoling',
  '北京顶佳世纪印刷有限公司' => 'dingjiashiji',
  '北京福美瑞服装服饰设计中心' => 'fumeirui',
  '北京环亚运商物流有限公司' => 'huanya',
  '北京怡丽饰商贸有限公司' => 'yilishi',
  '北京恩尔福摄影有限公司' => 'enerfu',
  '北京八爪鱼图文制作有限公司' => 'bazhuayu',
  '黑方(北京)文化传播有限公司' =>	'heifang'
}

vendor.each do |k,v|
  d = VendorOrg.create(:name=>k)
  d.users.create(:name=>v,:password=>'123')
end

payer = %w{
三星（中国）投资有限公司 
三星（中国）投资有限公司北京分公司 
三星（中国）投资有限公司上海分公司 
三星（中国）投资有限公司成都分公司 
三星（中国）投资有限公司广州分公司
三星（中国）投资有限公司沈阳分公司 
天津三星电子显示器有限公司 
天津通广三星电子有限公司 
天津三星光电子有限公司 
苏州三星电子有限公司 
苏州三星电子电脑有限公司 
上海三星半导体有限公司 
惠州三星电子有限公司
} 

payer.each{|e| Payer.create(:name=>e)}


