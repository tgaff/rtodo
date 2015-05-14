require 'rails_helper'

RSpec.feature "Toggling a todo item" do
  background do
    TodoItem.create(:title => 'blah blah').save!
  end

  scenario "toggling it to true", js: true do
    pending("not working until we have database cleaner and can stop using transactions")
    visit '/'
    within(".todo-item") do
      click_button 'false'
      expect(page.find('button')).to have_content 'true'
    end
  end

  given(:true_todo) { TodoItem.create(title: 'im done', is_complete: true) }

  scenario "the item is shown as complete" do
    true_todo
    visit '/'
    expect(page.find('.todo-item', text: 'im done')).to have_button 'true'
  end
end
