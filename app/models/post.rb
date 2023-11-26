# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Post < ApplicationRecord

    has_one_attached :image
    has_many_attached :images
end
