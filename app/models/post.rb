class Post < ActiveRecord::Base
  has_many :parts
  has_many :tags, through: :parts

  validates :author,  :presence => true
  validates :title,   :presence => true
  validates :body,    :presence => true
  validate :has_at_least_one_tag?

  def has_at_least_one_tag?
    errors.add(:tags, "post must have at least one tag") if tags.empty?
  end

  def save_tags(tag_string)
    tag_string.tr!(",", " ")
    tags = tag_string.split(' ')
    found_tag = Tag.new
    tags.each do |t|
      next if t.length == 0
      found_tag = Tag.find_by name: t
      if found_tag.nil?
        tag = Tag.create(name: t)
        self.tags << [tag]
      else
        self.tags << found_tag
      end
    end
  end

  def update_post(tag_string)
    tag_string.tr!(",", " ")
    tags = tag_string.split(' ')
    found_tag = Tag.new
    tags.each do |t|
      next if t.length == 0
      found_tag = Tag.find_by name: t
      if found_tag.nil?
        tag = Tag.create(name: t)
        self.tags << [tag]
      else
        self.tags << found_tag
      end
    end
  end
end
