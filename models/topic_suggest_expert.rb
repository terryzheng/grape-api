# coding: utf-8
class TopicSuggestExpert
  include Mongoid::Document
  
  field :topic_id
  field :expert_ids
end
