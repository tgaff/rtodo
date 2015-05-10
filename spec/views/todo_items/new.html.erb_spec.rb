require 'rails_helper'

RSpec.describe "todo_items/new", type: :view do
  before(:each) do
    assign(:todo_item, TodoItem.new(
      :title => "MyString",
      :is_complete => false
    ))
  end

  it "renders new todo_item form" do
    render

    assert_select "form[action=?][method=?]", todo_items_path, "post" do

      assert_select "input#todo_item_title[name=?]", "todo_item[title]"

      assert_select "input#todo_item_is_complete[name=?]", "todo_item[is_complete]"
    end
  end
end
