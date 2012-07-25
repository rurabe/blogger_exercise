class Article < ActiveRecord::Base
  attr_accessible :title, :body, :tag_list, :image

  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  has_attached_file :image

  def tag_list
    return self.tags.join(", ")
  end

  def tag_list=(tags_string)
    self.taggings.destroy_all

    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by_name(tag_name)
      tagging = self.taggings.new
      tagging.tag_id = tag.id
    end
  end

  def self.ordered_by(param)
    case param
    when 'word_count'   then self.order('(LENGTH(body)-(LENGTH(REPLACE(body," ","")))) DESC')
    when 'title'        then self.order('title')
    when 'published'    then self.order('created_at DESC')     
    
    else                     Article.order()
    end
  end
  
  def self.search_for(param)
    self.find(:all, :conditions => ['title LIKE ?',"%#{param}%"])
  end
  
  def self.but_only(limit)
    self.limit(limit)
  end
end
