class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many_attached :images, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validate :image_type

  def thumbnail input
    return self.images[input].variant(resize: "300x300!").processed
  end

  def tag_list
    self.tags.map { |tag| tag.name}.join(", ")
  end

  def tag_list=(tags_string)
    self.tags = tags_string.split(", ").collect{ |s| s.downcase}.uniq
                           .collect { |name| Tag.find_or_create_by(name: name)}
  end

  private
  def image_type
    images.each do |image|
      if !image.content_type.in?(%('image/jpeg image/png'))
        errors.add(:images, "must be a JPEG or PNG")
      end
    end
  end
end
