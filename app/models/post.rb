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

    has_one_attached :image, service: :amazon
    has_many_attached :images, service: :amazon
    mount_uploader :avatar, AvatarUploader
    has_one_attached :ava, service: :cloudinary
end
