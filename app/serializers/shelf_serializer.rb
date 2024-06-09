class ShelfSerializer 
  include JSONAPI::Serializer
  attributes :id, :name, :current_capacity, :max_capacity

end
