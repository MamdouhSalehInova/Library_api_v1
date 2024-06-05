class BookSerializer 
  include JSONAPI::Serializer
  attributes :id, :title, :is_available, :ratings

  attribute :author do |record|
    record.author.as_serialized_json
  end
  attribute :categories do |record|
    record.categories.map{|cat| cat.as_serialized_json}
  end
  attribute :shelf do |record|
    record.shelf.as_serialized_json
  end
  
end