# coding: utf-8
class Answer
  include Mongoid::Document

  field :body
  field :comments_count
  field :vote_up_count
  field :vote_down_count
  field :ask_id
  field :user_id
  field :created_at
  field :updated_at
  field :deleted
  scope :nondeleted, where(:deleted.nin=>[1,3])
  
  FIELDS=[:ask_id,:body,:comments_count,:user_id,:created_at,:updated_at,:vote_up_count,:vote_down_count]
  
  def as_json(opts={})
    {id:self.id,ask_id:self.ask_id,body:self.body,comments_count:self.comments_count,created_at:self.created_at,updated_at:self.updated_at,user_id:self.user_id,vote_up_count:self.vote_up_count,vote_down_count:self.vote_down_count}
  end
end
