require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AttachesController do

  # This should return the minimal set of attributes required to create a valid
  # Attach. As you add validations to Attach, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all attaches as @attaches" do
      attach = Attach.create! valid_attributes
      get :index
      assigns(:attaches).should eq([attach])
    end
  end

  describe "GET show" do
    it "assigns the requested attach as @attach" do
      attach = Attach.create! valid_attributes
      get :show, :id => attach.id
      assigns(:attach).should eq(attach)
    end
  end

  describe "GET new" do
    it "assigns a new attach as @attach" do
      get :new
      assigns(:attach).should be_a_new(Attach)
    end
  end

  describe "GET edit" do
    it "assigns the requested attach as @attach" do
      attach = Attach.create! valid_attributes
      get :edit, :id => attach.id
      assigns(:attach).should eq(attach)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Attach" do
        expect {
          post :create, :attach => valid_attributes
        }.to change(Attach, :count).by(1)
      end

      it "assigns a newly created attach as @attach" do
        post :create, :attach => valid_attributes
        assigns(:attach).should be_a(Attach)
        assigns(:attach).should be_persisted
      end

      it "redirects to the created attach" do
        post :create, :attach => valid_attributes
        response.should redirect_to(Attach.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved attach as @attach" do
        # Trigger the behavior that occurs when invalid params are submitted
        Attach.any_instance.stub(:save).and_return(false)
        post :create, :attach => {}
        assigns(:attach).should be_a_new(Attach)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Attach.any_instance.stub(:save).and_return(false)
        post :create, :attach => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested attach" do
        attach = Attach.create! valid_attributes
        # Assuming there are no other attaches in the database, this
        # specifies that the Attach created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Attach.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => attach.id, :attach => {'these' => 'params'}
      end

      it "assigns the requested attach as @attach" do
        attach = Attach.create! valid_attributes
        put :update, :id => attach.id, :attach => valid_attributes
        assigns(:attach).should eq(attach)
      end

      it "redirects to the attach" do
        attach = Attach.create! valid_attributes
        put :update, :id => attach.id, :attach => valid_attributes
        response.should redirect_to(attach)
      end
    end

    describe "with invalid params" do
      it "assigns the attach as @attach" do
        attach = Attach.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Attach.any_instance.stub(:save).and_return(false)
        put :update, :id => attach.id, :attach => {}
        assigns(:attach).should eq(attach)
      end

      it "re-renders the 'edit' template" do
        attach = Attach.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Attach.any_instance.stub(:save).and_return(false)
        put :update, :id => attach.id, :attach => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested attach" do
      attach = Attach.create! valid_attributes
      expect {
        delete :destroy, :id => attach.id
      }.to change(Attach, :count).by(-1)
    end

    it "redirects to the attaches list" do
      attach = Attach.create! valid_attributes
      delete :destroy, :id => attach.id
      response.should redirect_to(attaches_url)
    end
  end

end
