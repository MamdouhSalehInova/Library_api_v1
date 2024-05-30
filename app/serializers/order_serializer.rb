class OrderSerializer < ActiveModel::Serializer

  attributes :id, :return_date, :status, :book_id, :user_id


end
