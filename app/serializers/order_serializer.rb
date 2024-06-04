class OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at ,:return_date, :status, :book_id
  belongs_to :user
end
