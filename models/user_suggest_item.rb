# coding: utf-8
require 'benchmark'
class UserSuggestItem
  include Mongoid::Document

  field :suggested_experts
  field :suggested_users
  field :suggested_topics
  field :user_id
end
