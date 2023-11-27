# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  avatar     :string
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Post < ApplicationRecord
  # one image @ AWS:
  has_one_attached :image, service: :amazon 
  # array of simultaneoulsy uploaded images @ AWS:
  has_many_attached :images, service: :amazon
  # one image @ Cloudinary:
  has_one_attached :ava, service: :cloudinary
  # Cloudinary with CarrierWave, stored in this model metadata as string:
  mount_uploader :avatar, AvatarUploader 
end
