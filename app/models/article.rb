class Article < ApplicationRecord
  has_many :comments
  has_many :taggings
  has_many :tags, through: :taggings

  def tag_list
    self.tags.map { |tag| tag.name}.join(", ")
  end

  def tag_list=(tags_string)
    self.tags = tags_string.split(", ").collect{ |s| s.downcase}.uniq
                           .collect { |name| Tag.find_or_create_by(name: name)}
  end
end
