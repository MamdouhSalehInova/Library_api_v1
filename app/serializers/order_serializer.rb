class OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at ,:return_date, :status
  belongs_to :user
  belongs_to :book
end
