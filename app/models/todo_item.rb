class TodoItem < ActiveRecord::Base

  validates :title, presence: true
  validates :title, length: { minimum: 1 }
end
