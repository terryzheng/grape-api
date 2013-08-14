class TopicCache
  include Mongoid::Document
  
  field :name
  field :followers_count

  FIELDS=[:name,:followers_count]
  
  def as_json(opts={})
    {id:self.id,name:self.name,followers_count:self.followers_count}
  end
end