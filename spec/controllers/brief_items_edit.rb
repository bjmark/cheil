describe 'edit' do
  context 'no update right' do
    specify {
      set_current_user(rpm_tv_u1)
      design1 = brief1.items.create(:name=>'design1')
      expect {
        get :edit,:id => design1.id
      }.to raise_exception(SecurityError)
    }
  end

  context 'has update rigt' do
    specify {
      set_current_user(rpm_tv_u1)

      design1 = brief1.items.new(:name=>'design1')
      design1.op_right.add('self',rpm_tv.id,'update')
      design1.save

      get :edit,:id => design1.id
      assigns(:brief).id.should == brief1.id
    }
  end
end

