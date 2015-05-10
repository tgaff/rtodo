require 'rails_helper'

RSpec.describe TodoItem, type: :model do
  let(:empty) { TodoItem.new }
  it 'raises an error if no title is set' do
    expect{empty.save!}.to raise_error
  end

  it 'is invalid if the title is not at least 1 char' do
    empty.title = ''
    expect(empty).to be_invalid
  end

  it 'is valid if the title is at least 1 char' do
    empty.title = 'j'
    expect(empty).to be_valid
    expect{empty.save!}.to_not raise_error
  end

  it 'has a default value for is_complete of false' do
    t = TodoItem.new(title: 'asdf')
    t.save
    expect(t.is_complete).to eq false
  end
end
