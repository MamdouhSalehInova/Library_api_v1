class BookSerializer < ActiveModel::Serializer
  attributes :id, :title


  belongs_to :author
  belongs_to :shelf
  has_many :categories
  has_many :reviews

end
