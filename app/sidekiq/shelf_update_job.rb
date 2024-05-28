require 'sidekiq-scheduler'

class ShelfUpdateJob
    include Sidekiq::Job
    queue_as :default
    def perform
        @shelf = Shelf.all
        @shelf.each do |shelf|
            shelf.update(current_capacity: shelf.books.count)
        end
    end
end