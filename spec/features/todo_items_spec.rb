require 'rails_helper'

RSpec.feature "todo item" do
  background do
    TodoItem.create(:title => 'blah blah').save!
  end

  scenario "toggling the item to true", js: true do
    visit '/'
    within(".todo-item") do
      click_button 'false'
      expect(page.find('button')).to have_content 'true'
      click_link('Edit')
    end
    expect(page).to have_field 'Title', with: 'blah blah'
    expect(page).to have_checked_field('Is complete')

  end

  given(:true_todo) { TodoItem.create(title: 'im done', is_complete: true) }

  scenario "the item is shown as complete" do
    true_todo
    visit '/'
    expect(page.find('.todo-item', text: 'im done')).to have_button 'true'
  end

  context "deleting a todo:", js: true do

    scenario "it is removed from the page and a message displayed", js: true do
      visit '/'
      expect(page.first('.todo-item')).to have_content 'blah blah'
      page.accept_alert 'Are you sure?' do
        click_link 'Delete'
      end
      expect(page.find('#notice')).to have_content('The todo was successfully deleted')
      expect(page).to have_no_css('.todo-item')
      expect(page).to have_no_content 'blah blah'
    end

    context "when the todo doesn't actually exist:" do

      scenario "the page is reloaded showing only existing items" do
        visit '/'
        expect(page.first('.todo-item')).to have_content 'blah blah'

        TodoItem.create(title: 'blah2')
        TodoItem.find_by_title('blah blah').destroy
        page.accept_alert do
          click_link 'Delete'
        end
        page.has_no_content? 'blah blah' # wait for transition
        expect(page.first('.todo-item')).to have_content 'blah2'
      end
    end
  end

  context 'creating a new todo', js: true do
    background do
      visit '/'
    end

    scenario "clicking 'new Todo item'  displays a new form" do
      expect(page).to have_no_field 'Title'
      expect(page).to have_no_field 'Save'
      click_link 'New Todo item'
      expect(page).to have_field 'Title'
      expect(page).to have_button 'Save'
    end

    scenario "clicking 'Save' saves the todo" do
      click_link 'New Todo item'
      fill_in('Title', with: 'dishes')
      click_button 'Save'
      expect(page).to have_content 'dishes'
    end
  end
end
