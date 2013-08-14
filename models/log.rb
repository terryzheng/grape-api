# coding: utf-8
class Log
  include Mongoid::Document
  field :title
  field :action
  field :target_id
  
  belongs_to :user, :inverse_of => :logs
  
  FIELDS=[:title,:action,:target_id,:user_id,:_type]
  
  def as_json(opts={})
    {type:self._type,action:self.action,id:self.id,title:self.title,user_id:self.user_id,target_id:self.target_id}
  end
end

class AskLog < Log
end

class TopicLog < Log
end

class UserLog < Log
end

class AnswerLog < Log
end

class CommentLog < Log
end