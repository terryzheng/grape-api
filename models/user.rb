#coding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :grid_fs
  
  def store_dir
    "/uploads/user/avatar/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    "/assets/avatar/#{version_name}.jpg"
  end

  version :small do
    process :resize_and_pad => [23,23,'rgba(255, 255, 255, 0.0)']
  end
  
  version :small38 do
    process :resize_and_pad => [38,38,'rgba(255, 255, 255, 0.0)']
  end
  
  version :mid do
    process :resize_and_pad => [50,50,'rgba(255, 255, 255, 0.0)']
  end
  
  version :normal do
    process :resize_and_pad => [100,100,'rgba(255, 255, 255, 0.0)']
  end
end

class User
  include Mongoid::Document
  #expert_type
  COMMON_USER=6
  EXPERT_USER=2
  ELITE_USER=3
  #user_type
  FROZEN_USER=4
  BAN_USER=5
  NORMAL_USER=1

  FIELDS=[:name,:slug,:email,:tagline,:bio,:avatar_filename,:website,:girl,:mail_be_followed,:mail_new_answer,:mail_invite_to_ask,:mail_ask_me]

  field :name
  field :slug
  field :email
  field :tagline
  field :bio
  mount_uploader :avatar, ::AvatarUploader
  field :avatar_filename
  field :website
  field :girl
  field :mail_be_followed
  field :mail_new_answer
  field :mail_invite_to_ask
  field :mail_ask_me
  field :expert_type
  field :followed_ask_ids
  field :followed_topic_ids
  field :following_ids
  field :follower_ids
  field :deleted
  scope :nondeleted, where(:deleted.nin=>[1,3])
  
  def as_json(opts={})
    {avatar:self.avatar,bio:self.bio,email:self.email,girl:self.girl,mail_ask_me:self.mail_ask_me,mail_be_followed:self.mail_be_followed,mail_invite_to_ask:self.mail_invite_to_ask,mail_new_answer:self.mail_new_answer,name:self.name,slug:self.slug,tagline:self.tagline,website:self.website}
  end
end
