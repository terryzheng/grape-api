# coding: utf-8
class Comment
  include Mongoid::Document

  field :body
  field :commentable_id
  field :commentable_type
  field :user_id
  field :created_at
  field :updated_at
  field :deleted
  scope :nondeleted, where(:deleted.nin=>[1,3])
  
  FIELDS=[:body,:commentable_id,:commentable_type,:user_id,:created_at,:updated_at]
  
  def as_json(opts={})
    {id:self.id,body:self.body,commentable_id:self.commentable_id,commentable_type:self.commentable_type,created_at:self.created_at,updated_at:self.updated_at,user_id:self.user_id}
  end
end
