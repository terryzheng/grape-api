# coding: utf-8
class Ask
  include Mongoid::Document

  field :title
  field :user_id
  field :answers_count
  field :spams_count
  field :deleted
  scope :unanswered, where(:answers_count => 0)
  scope :normal, where(:spams_count.lt => 8)
  scope :nondeleted, where(:deleted.nin=>[1,3])
  
  FIELDS=[:title,:user_id,:answers_count]
  
end