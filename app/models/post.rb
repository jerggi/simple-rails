class Post < ActiveRecord::Base
  has_many :parts
  has_many :tags, through: :parts

  validates :author,  :presence => true
  validates :title,   :presence => true
  validates :body,    :presence => true
  validate :has_at_least_one_tag

  def has_at_least_one_tag
    if tags.empty?
      errors.add(:tags, "post must have at least one tag")
    end
  end
end
