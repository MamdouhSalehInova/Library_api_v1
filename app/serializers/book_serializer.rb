class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :is_available

  belongs_to :author
  belongs_to :shelf
  has_many :categories
  has_many :reviews

end
