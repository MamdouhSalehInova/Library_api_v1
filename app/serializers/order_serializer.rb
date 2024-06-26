class OrderSerializer 
  include JSONAPI::Serializer
  attributes :id, :created_at ,:return_date, :status

  attribute :user do |record|
    record.user.as_serialized_json
  end
  attribute :book do |record|
    record.book.as_serialized_json
  end

end
