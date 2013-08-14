# coding: utf-8
class Client
  include Mongoid::Document
  belongs_to :user
  field :uri                                       # client identifier (internal)
  field :name                                      # client name
end
