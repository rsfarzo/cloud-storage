require 'cloudinary'

if Cloudinary.config.api_key.blank?
  require './config'
  pp "load"
end

puts 'My cloud name is:' + Cloudinary.config.cloud_name
