require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "todo_items/index", type: :view do
  before(:each) do
    assign(:todo_items, [
      TodoItem.create!(
        :title => "Title",
        :is_complete => false
      ),
      TodoItem.create!(
        :title => "Title",
        :is_complete => true
      )
    ])
  end

  it "renders a list of todo_items" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 1
    assert_select "tr>td", :text => true.to_s, :count => 1
  end

  it "has a button that shows the is_complete status" do
    render
    page = Capybara::Node::Simple.new(rendered)
    expect(page).to have_css "button.complete-toggle", count: 2
    expect(page.first('button.complete-toggle')).to have_text "false"
  end

end
