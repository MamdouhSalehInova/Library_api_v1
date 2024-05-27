class Book < ApplicationRecord

  after_save :update_shelf



  #before_update :update_old_shelf
  #before_save :check_shelf


  has_many :books_categories, dependent: :destroy
  has_many :categories, through: :books_categories


  #has_and_belongs_to_many :categories, 
  has_many :reviews, dependent: :delete_all
  belongs_to :author
  belongs_to :shelf
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true



  def update_shelf
    @shelf =  self.shelf
    @shelf.update(current_capacity: @shelf.books.count)
    if self.shelf_id_previously_was != nil
    @old_shelf = Shelf.find(self.shelf_id_previously_was)
    @old_shelf.update(current_capacity: @shelf.current_capacity - 1)
    puts "#{self.shelf_id_previously_was} //////////////--------------------//////////////"
    end
  end

  


  end
