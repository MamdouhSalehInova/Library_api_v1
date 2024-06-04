class ShelfSerializer < ActiveModel::Serializer
  attributes  :name, :current_capacity, :max_capacity
end
