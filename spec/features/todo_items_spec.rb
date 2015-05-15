require 'rails_helper'

RSpec.feature "Toggling a todo item" do
  background do
    TodoItem.create(:title => 'blah blah').save!
  end

  scenario "toggling it to true", js: true do
    visit '/'
    within(".todo-item") do
      click_button 'false'
      expect(page.find('button')).to have_content 'true'

      # also verify it's true on view page
      click_link('Show')
    end
    expect(page).to have_content 'blah blah'
    expect(page).to have_content "Iscomplete: true"

  end

  given(:true_todo) { TodoItem.create(title: 'im done', is_complete: true) }

  scenario "the item is shown as complete" do
    true_todo
    visit '/'
    expect(page.find('.todo-item', text: 'im done')).to have_button 'true'
  end

  scenario "deleting an item", js: true, focus: true do
    visit '/'
    expect(page.find('.todo-item')).to have_content 'blah blah'
    page.accept_alert 'Are you sure?' do
      click_link 'Delete'
    end
    expect(page.find('#notice')).to have_content('the todo was successfully deleted')
    expect(page).to have_no_css('.todo-item')
    expect(page).to have_no_content 'blah blah'
  end
end
