# coding: utf-8
class Topic
  include Mongoid::Document

  field :name
  field :followed_count
  field :tags
  field :deleted
  scope :nondeleted, where(:deleted.nin=>[1,3])
  
  FIELDS=[:name,:followed_count]

  def as_json(opts={})
    {id:self.id,name:self.name,followers_count:self.followed_count}
  end
end
