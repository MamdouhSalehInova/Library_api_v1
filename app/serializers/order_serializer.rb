class OrderSerializer < ActiveModel::Serializer

  attributes :id, :return_date, :status, :book_id

  belongs_to :user
  
end
