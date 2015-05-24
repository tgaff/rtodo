class TodoItem < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :title, length: { minimum: 1 }
end
