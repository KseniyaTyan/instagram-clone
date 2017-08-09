class AddImages < ActiveRecord::Migration
  def change
    add_attachment :users, :avatar
    add_attachment :posts, :image
  end
end
