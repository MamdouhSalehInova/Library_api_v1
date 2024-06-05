class ReviewSerializer
  include JSONAPI::Serializer
  attributes :rating, :body

  attribute :user_email do |record|
    record.user.as_serialized_json
  end
  attribute :book do |record|
    record.book.as_serialized_json
  end
end
