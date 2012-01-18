#coding=utf-8
require 'spec_helper'

describe ItemsController do
  let(:rpm_org) { RpmOrg.create(:name=>'rpm') }
  #和rpm_org对应的cheil_org
  let(:cheil_org) { rpm_org.create_cheil_org(:name=>'cheil')}
  let(:vendor_org) {VendorOrg.create(:name=>'vendor')}

  let(:rpm_org2) { RpmOrg.create(:name=>'rpm2') }
  let(:cheil_org2) {CheilOrg.create(:name=>'cheil2')}
  let(:vendor_org2) {VendorOrg.create(:name=>'vendor2')}

  let!(:rpm_user) { rpm_org.users.create(:name=>'rpm_user',:password=>'123')}
  let!(:cheil_user) { cheil_org.users.create(:name=>'cheil_user',:password=>'123')}
  let!(:vendor_user) { vendor_org.users.create(:name=>'vendor_user',:password=>'123')}

  let(:rpm2_user) { rpm_org2.users.create(:name=>'rpm2_user',:password=>'123')}
  let(:cheil2_user) { cheil_org2.users.create(:name=>'cheil2_user',:password=>'123')}
  let(:vendor2_user) { vendor_org2.users.create(:name=>'vendor2_user',:password=>'123')}

  let!(:brief){ rpm_user.org.briefs.create(:name=>'brief')}

  def set_current_user(user)
    session[:user_id] = user.id
  end

  describe "GET new" do
    context 'not login' do
      specify{
        get 'new'
        response.should redirect_to(new_session_path)
      }
    end

    context 'lack of param' do
      specify{
        set_current_user(rpm_user) 
        expect{
          get :new 
        }.to raise_exception(SecurityError)
      } 
    end

    context 'new BriefItem' do
      specify{
        set_current_user(rpm_user) 
        get :new , :brief_id => brief.id
        assigns(:item).should be_a_new(BriefItem)
      }

      specify{
        set_current_user(rpm2_user)
        expect{
          get :new , :brief_id => brief.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'new CheilSolutionItem' do
      specify{
        set_current_user(cheil_user) 
        brief.send_to_cheil!
        get :new , :solution_id => brief.cheil_solution.id
        assigns(:item).should be_a_new(SolutionItem)
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        expect{
          get :new , :solution_id => brief.cheil_solution.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'new VendorSolutionItem' do
      specify{
        set_current_user(vendor_user) 
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.id)
        get :new , :solution_id => vendor_solution.id
        assigns(:item).should be_a_new(SolutionItem)
      }

      specify{
        set_current_user(vendor2_user)
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.id)
        expect{
          get :new , :solution_id => vendor_solution.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'GET edit' do
    context 'BriefItem' do
      specify{
        set_current_user(rpm_user)
        brief_item = brief.items.create(:name=>'design',:kind=>'design')
        get :edit,:id=>brief_item.id
        assigns(:item).should be_a(BriefItem)
        assigns(:form).should be_nil
      }

      specify{
        set_current_user(rpm2_user)
        brief_item = brief.items.create(:name=>'design',:kind=>'design')
        expect{
          get :edit,:id=>brief_item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'SolutionItem' do
      #cheil_solution
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        item = brief.cheil_solution.items.create(:name=>'trans',:kind=>'tran')
        get :edit,:id=>item.id
        assigns(:item).should be_a(SolutionItem)
        assigns(:form).should == 'tran_form'
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        item = brief.cheil_solution.items.create(:name=>'trans',:kind=>'tran')
        expect{
          get :edit,:id=>item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'VendorItem' do
      #vendor_solution
      specify{
        set_current_user(vendor_user)
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.org_id)
        item = vendor_solution.items.create(:name=>'trans',:kind=>'tran')
        get :edit,:id=>item.id
        assigns(:item).should be_a(SolutionItem)
        assigns(:form).should == 'tran_form'

        get :edit,:id=>item.id,:spec=>'price'
        assigns(:form).should == 'price_form'
      }

      specify{
        set_current_user(vendor2_user)
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user.org_id)
        item = vendor_solution.items.create(:name=>'trans',:kind=>'tran')
        expect{
          get :edit,:id=>item.id
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'create' do
    context 'assign a brief_item to a vendor_solution' do
      specify{
        set_current_user(cheil_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)
        post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        vendor_solution.items.find{|e| e.parent_id == brief_item.id}.should_not be_nil
      }

      specify{
        set_current_user(cheil2_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)

        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)
        
        set_current_user(rpm_user)
        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)

        set_current_user(vendor_user)
        expect{
          post :create,:solution_id=>vendor_solution.id,:item_id=>brief_item.id
        }.to raise_exception(SecurityError)
      }
    end

    context 'wrong params' do
      specify{
        set_current_user(cheil_user)
        brief_item = brief.items.create(:name=>'design1',:kind=>'design')
        brief.send_to_cheil!
        vendor_solution = brief.vendor_solutions.create(:org_id=>vendor_user)
        expect{
          post :create
        }.to raise_exception(SecurityError)
      }
    end

    context 'brief ower(rpm_user) create a brief_item' do
      specify{
        set_current_user(rpm_user)
        post :create,:brief_id=>brief.id , :brief_item=>{:name=>'design1',:kind=>'design'}
        response.should redirect_to(brief_path(brief))
        brief.items.first.name.should == 'design1'
        brief.items.first.op.read_by_to_a.should == [rpm_user.id.to_s]

        #brief should be touched
        brief.reload.op.read_by_to_a.should == [rpm_user.id.to_s]
      }

      it "should have 1 errors,as name is blank" do
        set_current_user(rpm_user)
        post :create,:brief_id=>brief.id , :brief_item=>{:name=>'',:kind=>'design'}
        response.should render_template('new')
        assigns(:item).should have(1).errors_on(:name)
      end

      it "raise exception,as rpm2_user is not owner" do
        set_current_user(rpm2_user)
        expect{
          post :create,:brief_id=>brief.id , :brief_item=>{:name=>'design1',:kind=>'design'}
        }.to raise_exception(SecurityError)
      end
    end

    context 'brief send to cheil,cheil can create a brief_item' do
      specify{
        brief.send_to_cheil!
        
        set_current_user(cheil_user)

        post :create,:brief_id=>brief.id , :brief_item=>{:name=>'design1',:kind=>'design'}
        response.should redirect_to(brief_path(brief))
        brief.items.first.name.should == 'design1'
        brief.items.first.op.read_by_to_a.should == [cheil_user.id.to_s]

        #brief should be touched
        brief.reload.op.read_by_to_a.should == [cheil_user.id.to_s]
      }
    end

    context 'create a solution_item' do
      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'other1',:kind=>'other'}

        response.should redirect_to(solution_path(solution)) 
        assigns(:item).solution.should eq(solution)
      }

      specify{
        set_current_user(cheil_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'',:kind=>'other'}

        response.should render_template('new') 
        assigns(:item).should have(1).errors_on(:name)
      }

      specify{
        set_current_user(cheil2_user)
        brief.send_to_cheil!
        solution = brief.cheil_solution

        expect{
          post :create,:solution_id=>solution.id,
          :solution_item=>{:name=>'other1',:kind=>'other'}
        }.to raise_exception(SecurityError)
      }
    end
  end

  describe 'update' do
    context 'a brief_item' do
      let(:item){ brief.items.create(:name=>'ddd',:kind=>'design') }

      context 'with the right rpm_user' do
        context 'and params are valid' do
          before do
            set_current_user(rpm_user)
            put :update,:id=>item.id,:brief_item => {:name => 'ppp',:kind => 'product'}
          end

          it 'should redirect to show brief page' do
            response.should redirect_to(brief_path(item.fk_id))
          end

          it 'item name should be changed' do
            item.reload.name.should == 'ppp'
          end
        end

        context 'but params are invalid' do
          specify{
            set_current_user(rpm_user)
            put :update,:id=>item.id,:brief_item => {:name => '',:kind => 'product'}
            assigns(:item).should have(1).errors_on(:name)
          }
        end
      end

      context 'with the wrong rpm_user2' do
        specify{
          set_current_user(rpm2_user)
          expect{
            put :update,:id=>item.id,:brief_item => {:name => 'ppp',:kind => 'product'}
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a solution_item' do
      context 'with the right cheil_user' do
        before do
          brief.send_to_cheil!
          set_current_user(cheil_user)
          solution = brief.cheil_solution
          item = solution.items.create(:name=>'ddd',:kind=>'other')
          put :update,:id => item.id,:solution_item => {:name=>'kkk',:kind=>'other'}
        end

        it 'should redirect to show solution page' do
          response.should redirect_to(solution_path(assigns(:item).fk_id))
        end

        it 'item name should be changed' do
          assigns(:item).name.should == 'kkk'
        end
      end

      context 'with the wrong cheil2_user' do
        specify{
          brief.send_to_cheil!
          set_current_user(cheil2_user)
          solution = brief.cheil_solution
          item = solution.items.create(:name=>'ddd',:kind=>'other')
          expect{
            put :update,:id => item.id,:solution_item => {:name=>'kkk',:kind=>'other'}
          }.to raise_exception(SecurityError)
        }
      end
    end
  end

  describe 'delete' do
    context 'a assigned item from a vendor_solution' do
      let(:brief_item) { brief.items.create(:name=>'ddd',:kind=>'design') }
      let(:vendor_solution) { brief.vendor_solutions.create(:org_id=>vendor_user.org_id) }
      before do
        brief.send_to_cheil!
        brief_item.add_to_solution(vendor_solution)
      end
      context 'with the right cheil_user' do
        specify{
          set_current_user(cheil_user)
          vendor_solution.items.where(:parent_id=>brief_item).should_not be_empty

          delete :destroy,:id => brief_item.id, :solution_id => vendor_solution.id
          vendor_solution.items.where(:parent_id=>brief_item).should be_empty
        }
      end

      context 'with the wrong cheil2_user' do
        specify{
          set_current_user(cheil2_user)
          expect{
            delete :destroy,:id => brief_item.id, :solution_id => vendor_solution.id
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a item from brief' do
      let(:brief_item) { brief.items.create(:name=>'ddd',:kind=>'design') }

      context 'with the right rpm_user' do
        specify{
          set_current_user(rpm_user)
          delete :destroy,:id => brief_item.id
          brief.items.where(:id=>brief_item.id).should be_empty
          response.should redirect_to(brief_path(brief))
        }
      end

      context 'with the wrong rpm_user' do
        specify{
          set_current_user(rpm2_user)
          expect{
            delete :destroy,:id => brief_item.id
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a item from chieil_solution' do
      let(:cheil_solution) { brief.cheil_solution }
      let(:solution_item) { cheil_solution.items.create(:name=>'trans',:kind=>'tran')}
      before do
        brief.send_to_cheil!
      end

      context 'with the right cheil_user' do
        specify{
          set_current_user(cheil_user)
          delete :destroy,:id => solution_item.id
          cheil_solution.items.reload.should be_empty
          response.should redirect_to(solution_path(cheil_solution))
        }
      end

      context 'with the wrong cheil_user' do
        specify{
          set_current_user(cheil2_user)
          expect{
            delete :destroy,:id => solution_item.id
          }.to raise_exception(SecurityError)
        }
      end
    end

    context 'a item from vendor_solution' do
      let(:vendor_solution) { brief.vendor_solutions.create(:org_id=>vendor_user.org_id) }
      let(:solution_item) { vendor_solution.items.create(:name=>'other',:kind=>'other')}

      context 'with the right vendor_user' do
        specify{
          set_current_user(vendor_user)
          delete :destroy,:id => solution_item.id
          vendor_solution.items.reload.should be_empty
          response.should redirect_to(solution_path(vendor_solution))
        }
      end

      context 'with the wrong vendor_user' do
        specify{
          set_current_user(vendor2_user)
          expect{
            delete :destroy,:id => solution_item.id
          }.to raise_exception(SecurityError)
        }
      end
    end
  end

  context 'check' do
    context 'a vendor_solution item' do
      let(:vendor_solution) { brief.vendor_solutions.create(:org_id=>vendor_user.org_id) }
      let(:solution_item) { vendor_solution.items.create(:name=>'other',:kind=>'other')}
      before { brief.send_to_cheil! }

      context 'with the right cheil_user' do
        specify{
          set_current_user(cheil_user)
          put :check,:id=>solution_item.id
          solution_item.reload.checked.should == 'y'
        }
      end

      context 'with the wrong cheil2_user' do
        specify{
          set_current_user(cheil2_user)
          expect {
            put :check,:id=>solution_item.id
          }.to raise_exception(SecurityError)
        }
      end
    end
  end
end
