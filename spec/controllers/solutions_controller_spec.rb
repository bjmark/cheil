require 'spec_helper'

describe SolutionsController do
  let(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  let(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}
  let(:vendor_org) {VendorOrg.create(:name=>'vendor')}

  let(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}
  let(:vendor_user) { vendor_org.users.create(:name=>'vendor_user',:password=>'123')}


  let(:rpm_org2) { RpmOrg.create(:name=>'rpm2') }
  let(:cheil_org2) {CheilOrg.create(:name=>'cheil2')}
  let(:vendor_org2) {VendorOrg.create(:name=>'vendor2')}


  let(:rpm2_user) { rpm_org2.users.create(:name=>'rpm2_user',:password=>'123')}
  let(:cheil2_user) { cheil_org2.users.create(:name=>'cheil2_user',:password=>'123')}
  let(:vendor2_user) { vendor_org2.users.create(:name=>'vendor2_user',:password=>'123')}

  let(:brief) { cheil_org.rpm_org.briefs.create(:name=>'brief') }

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe 'index' do
    context 'current user is a rpm_user' do
      specify{
        set_current_user(rpm_user)
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a vendor_user' do
      specify{
        set_current_user(vendor_user)
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a bad cheil_user' do
      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        expect{
          get :index,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'current user is a good cheil_user' do
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        get :index,:brief_id=>brief.id
        response.should render_template('index')
      }
    end
  end


  describe "show" do
    before do
      brief.send_to_cheil!
    end

    context 'a cheil_solution' do
      context 'a good rpm_user' do
        specify{
          set_current_user(rpm_user)
          get :show,:id=>brief.cheil_solution.id
          response.should render_template 'solutions/rpm/show'
        }
      end

      context 'a bad rpm_user' do
        specify{
          set_current_user(rpm2_user)
          expect{
            get :show,:id=>brief.cheil_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good cheil_user' do
        specify{
          set_current_user(cheil_user)
          get :show,:id=>brief.cheil_solution.id
          response.should render_template 'solutions/cheil/cheil_solution/show'
        }
      end

      context 'any vendor_user' do
        specify{
          set_current_user(vendor_user)
          expect{
            get :show,:id=>brief.cheil_solution.id
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a vendor_solution' do
      let(:vendor_solution){ brief.vendor_solutions.create(:org_id=>vendor_user.org_id)}
      context 'any rpm_user' do
        specify{
          set_current_user(rpm_user)
          expect{
            get :show,:id=>vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good cheil_user' do
        specify{
          set_current_user(cheil_user)
          get :show,:id=>vendor_solution.id
          response.should render_template 'solutions/cheil/vendor_solution/show'
        }
      end

      context 'a bad cheil_user' do
        specify{
          set_current_user(cheil2_user)
          expect{
            get :show,:id=>vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good vendor_user' do
        specify{
          set_current_user(vendor_user)
          get :show,:id=>vendor_solution.id
          response.should render_template 'solutions/vendor/show'
        }
      end

      context 'a bad vendor_user' do
        specify{
          set_current_user(vendor2_user)
          expect{
            get :show,:id=>vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end

    end
  end

  describe 'edit_rate' do
    before do
      brief.send_to_cheil!
    end

    context 'a cheil_solution' do
      context 'any rpm_user' do
        specify{
          set_current_user(rpm_user)
          expect{
            get :edit_rate,:id=>brief.cheil_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good cheil_user' do
        specify{
          set_current_user(cheil_user)
          get :edit_rate,:id=>brief.cheil_solution.id
          response.should render_template 'edit_rate'
        }
      end

      context 'a bad cheil_user' do
        specify{
          set_current_user(cheil2_user)
          expect{
            get :edit_rate,:id=>brief.cheil_solution.id
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a vendor_solution' do
      let(:vendor_solution){ brief.vendor_solutions.create(:org_id=>vendor_user.org_id)}

      context 'any rpm_user' do
        specify{
          set_current_user(rpm_user)
          expect{
            get :edit_rate,:id=>vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end

      context 'a good vendor_user' do
        specify{
          set_current_user(vendor_user)
          get :edit_rate,:id=>vendor_solution.id
          response.should render_template 'edit_rate'
        }
      end

      context 'a bad cheil_user' do
        specify{
          set_current_user(vendor2_user)
          expect{
            get :edit_rate,:id=>vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end
    end
  end

  describe 'create' do
    context 'any rpm_user' do
      specify{
          set_current_user(rpm_user)
          expect{
            get :create,:brief_id=>brief.id
          }.to raise_exception(SecurityError)
        }
    end

    context 'any vendor_user' do
      specify{
        set_current_user(vendor_user)
        expect{
          get :create,:brief_id=>brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'a good cheil_user' do
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        get :create,:brief_id=>brief.id
        response.should redirect_to solutions_path(:brief_id=>brief.id) 
      }
    end
  end

  describe 'destroy' do
    let(:vendor_solution) { brief.vendor_solutions.create(:org_id=>vendor_user.org_id)}
    before{
      brief.send_to_cheil!
    } 

    context 'any rpm_user' do
      specify{
        set_current_user(rpm_user)
        expect{
          get :destroy,:id=>vendor_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'any vendor_user' do
      specify{
        set_current_user(vendor_user)
        expect{
          get :destroy,:id=>vendor_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'a good cheil_user' do
      specify{
        set_current_user(cheil_user)
        get :destroy,:id=>vendor_solution.id
        brief.reload.vendor_solutions.where(:id=>vendor_solution.id).should == []
        response.should redirect_to solutions_path(:brief_id=>brief.id) 
      }
    end

    context 'a bad cheil_user' do
      specify{
        set_current_user(cheil2_user)
        expect{
          get :destroy,:id=>vendor_solution.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'approve' do
    before{
      brief.send_to_cheil!
    } 

    context 'a good rpm_user' do
      specify{
        set_current_user(rpm_user)
        put :approve,:id=>brief.cheil_solution.id
        brief.cheil_solution.reload.approved?.should be_true
        response.should redirect_to solution_path(brief.cheil_solution)
      }
    end

    context 'a bad rpm_user' do
      specify{
        set_current_user(rpm2_user)
        expect{
          put :approve,:id=>brief.cheil_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'any cheil_user' do
      specify{
        set_current_user(cheil_user)
        expect{
          put :approve,:id=>brief.cheil_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'any vendor_user' do
      specify{
        set_current_user(vendor_user)
        expect{
          put :approve,:id=>brief.cheil_solution.id
        }.to raise_exception(SecurityError)
      }
    end

  end
end
