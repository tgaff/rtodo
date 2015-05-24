require 'rails_helper'

RSpec.shared_examples 'not logged in' do
  it 'redirects to sign_in' do
     #todo_item = TodoItem.create! valid_attributes
     action # define this like: get :index, {}
     expect(response).to redirect_to :user_session
  end
end

RSpec.describe TodoItemsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # TodoItem. As you add validations to TodoItem, be sure to
  # adjust the attributes here as well.

  let(:user) do
    user = User.new(email: 'ed@ed.com', password: '11114444')
    user.save!
    user
  end

  let(:valid_attributes) {
    { title: 'do this', user_id: user.id }
  }

  let(:invalid_attributes) {
    { title: '', user_id: user.id }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TodoItemsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'authentication' do
    it { should use_before_action :authenticate_user! }
    it 'assigns current_user' do
      expect { login_user }.to change { subject.current_user }.from(nil)
    end
  end

  describe "GET #index" do
    subject(:action) { get :index, {}, valid_session }
    let!(:todo_item) { TodoItem.create! valid_attributes }

    context "when logged in" do
      before { login_user }
      it "assigns all todo_items as @todo_items" do
        action
        expect(assigns(:todo_items)).to eq([todo_item])
      end
    end

    context "when not logged in" do
      it "redirects to sign_in" do
        action
        expect(response).to redirect_to :user_session
      end

      it_behaves_like 'not logged in'
    end
  end

  describe "GET #show" do
    subject(:action) { get :show, {:id => todo_item.to_param}, valid_session }
    let!(:todo_item) { TodoItem.create! valid_attributes }
    context "when logged in" do
      before { login_user }
      it "assigns the requested todo_item as @todo_item" do
        expect{action}.to change { assigns(:todo_item) }.from(nil).to todo_item
      end
    end
    context "when not logged in" do
      it_behaves_like 'not logged in'
    end
  end

  describe "GET #new", :focus do
    it "assigns a new todo_item as @todo_item" do
      get :new, {}, valid_session
      expect(assigns(:todo_item)).to be_a_new(TodoItem)
    end
  end

  describe "GET #edit" do
    it "assigns the requested todo_item as @todo_item" do
      todo_item = TodoItem.create! valid_attributes
      get :edit, {:id => todo_item.to_param}, valid_session
      expect(assigns(:todo_item)).to eq(todo_item)
    end
  end

  describe "POST #create" do
    context "using format HTML" do
      context "with valid params" do
        it "creates a new TodoItem" do
          expect {
            post :create, {:todo_item => valid_attributes}, valid_session
          }.to change(TodoItem, :count).by(1)
        end

        it "assigns a newly created todo_item as @todo_item" do
          post :create, {:todo_item => valid_attributes}, valid_session
          expect(assigns(:todo_item)).to be_a(TodoItem)
          expect(assigns(:todo_item)).to be_persisted
        end

        it "redirects to the created todo_item" do
          post :create, {:todo_item => valid_attributes}, valid_session
          expect(response).to redirect_to(TodoItem.last)
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved todo_item as @todo_item" do
          post :create, {:todo_item => invalid_attributes}, valid_session
          expect(assigns(:todo_item)).to be_a_new(TodoItem)
        end

        it "re-renders the 'new' template" do
          post :create, {:todo_item => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end
    context "using format JS" do
      context "with valid params" do
        it "creates a new TodoItem" do
          expect {
            post :create, {:todo_item => valid_attributes, format: 'js'}, valid_session
          }.to change(TodoItem, :count).by(1)
        end

        it "assigns a newly created todo_item as @todo_item" do
          post :create, {:todo_item => valid_attributes, format: 'js'}, valid_session
          expect(assigns(:todo_item)).to be_a(TodoItem)
          expect(assigns(:todo_item)).to be_persisted
        end

        it "renders the insert template with the created todo_item" do
          post :create, {:todo_item => valid_attributes, format: :js}, valid_session
          expect(response).to render_template('insert')
        end

        it "includes a notice" do
          post :create, { todo_item: valid_attributes, format: :js }, valid_session
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid params" do
        it "assigns a newly created but unsaved todo_item as @todo_item" do
          post :create, {:todo_item => invalid_attributes, format: :js}, valid_session
          expect(assigns(:todo_item)).to be_a_new(TodoItem)
        end

        it "renders the new template with the error messages" do
          post :create, {:todo_item => invalid_attributes, format: :js}, valid_session
          expect(response).to render_template("new")
          expect(assigns(:todo_item).errors).to be_present
        end
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: 'raise elephants', is_complete: true }
      }

      it "updates the requested todo_item" do
        todo_item = TodoItem.create! valid_attributes
        put :update, {:id => todo_item.to_param, :todo_item => new_attributes}, valid_session
        todo_item.reload
        expect(todo_item.title).to eq new_attributes[:title]
        expect(todo_item.is_complete).to be_truthy
      end

      it "doesn't change the title if unspecified" do
        todo_item = TodoItem.create! valid_attributes
        todo_item_original_title = todo_item.title
        put :update, {:id => todo_item.to_param, :todo_item => {is_complete: true}}, valid_session
        todo_item.reload
        expect(todo_item.is_complete).to be_truthy
        expect(todo_item.title).to eq todo_item_original_title
      end


      it "assigns the requested todo_item as @todo_item" do
        todo_item = TodoItem.create! valid_attributes
        put :update, {:id => todo_item.to_param, :todo_item => valid_attributes}, valid_session
        expect(assigns(:todo_item)).to eq(todo_item)
      end

      it "redirects to the todo_item" do
        todo_item = TodoItem.create! valid_attributes
        put :update, {:id => todo_item.to_param, :todo_item => valid_attributes}, valid_session
        expect(response).to redirect_to(todo_item)
      end
      context "with format js" do
        it "renders update_row" do
          todo_item = TodoItem.create! valid_attributes
          put :update, { format: :js, id: todo_item.to_param, todo_item: new_attributes }, valid_session
          expect(response).to render_template("update_row")
        end
      end
    end

    context "with invalid params" do
      it "assigns the todo_item as @todo_item" do
        todo_item = TodoItem.create! valid_attributes
        put :update, {:id => todo_item.to_param, :todo_item => invalid_attributes}, valid_session
        expect(assigns(:todo_item)).to eq(todo_item)
      end

      it "re-renders the 'edit' template" do
        todo_item = TodoItem.create! valid_attributes
        put :update, {:id => todo_item.to_param, :todo_item => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
      context "with format js" do
        it "re-renders the 'edit' template" do
          todo_item = TodoItem.create! valid_attributes
          put :update, {format: :js, id: todo_item.to_param, todo_item: invalid_attributes }, valid_session
          expect(response).to render_template("edit")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested todo_item" do
      todo_item = TodoItem.create! valid_attributes
      expect {
        delete :destroy, {:id => todo_item.to_param}, valid_session
      }.to change(TodoItem, :count).by(-1)
    end
    context 'using format: html' do
      it "redirects to the todo_items list" do
        todo_item = TodoItem.create! valid_attributes
        delete :destroy, {:id => todo_item.to_param}, valid_session
        expect(response).to redirect_to(todo_items_url)
      end
    end
    context 'using format: js' do
      let(:todo_item) { TodoItem.create! valid_attributes }
      it "renders destroy" do
        delete :destroy, format: :js, id: todo_item.to_param
        expect(response).to render_template("destroy")
      end
      it "displays a flash notice" do
        delete :destroy, format: :js, id: todo_item.to_param
        expect(flash[:notice]).to be_present
      end
    end
  end
end
