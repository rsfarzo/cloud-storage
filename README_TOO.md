References
- [Dev.to fast and easy](https://dev.to/nilomiranda/setting-up-image-upload-with-cloudinary-rails-and-active-storage-3941)
- [Rubyonrails.org details](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Cloudinary and Rails](https://cloudinary.com/documentation/ruby_rails_quickstart)
- show AWS screenshots
- show Cloudinary screenshots

1. Gemfile:
```
gem "cloudinary" # for cloudinary
gem "image_processing", ">= 1.2"  # optional
gem "aws-sdk-s3" # for amazon
gem "carrierwave", '~> 3.0'  # optional
```

2. Setup (creates 3 tables)
```
bin/rails active_storage:install
bin/rails db:migrate
```
3. Set Active Storage services 
- Configuration parameters for cloudinary have several options suchs as in a `config/cloudinary.yml``
  - in config/storage.yml
```
amazon:
   service: S3
   access_key_id: <%= ENV["AWS_ACCESS_KEY_ID"] %>
   secret_access_key: <%= ENV["AWS_SECRET_ACCESS_KEY"] %>
   region: <%= ENV["AWS_REGION"] %>
   bucket: <%= ENV["S3_BUCKET"] %>

cloudinary:
    service: Cloudinary
    cloud_name: <%= ENV["cloudinary_cloud"] %>
    api_key: <%= ENV["cloudinary_key"] %>
    api_secret: <%= ENV["cloudinary_secret"] %>
```    
- specify default storage service in `config/environments/development.rb`, `production.rb`, `test.rb`:
```
  	config.active_storage.service = :cloudinary #  :amazon
```
- Create `config/initializer/cloudinary.rb`:
```
Cloudinary.config do |config|
  config.cloud_name = ENV['cloudinary_cloud']
  config.api_key = ENV['cloudinary_key']
  config.api_secret = ENV['cloudinary_secret']
  config.secure = true
end
Cloudinary.config_from_url(ENV['CLOUDINARY_URL'])
pp "Initializer: cloudinary #{Cloudinary.config.cloud_name}"
```

- store env vars (demo using dotenv for dev and env vars at Render)
```
gem "dotenv-rails", groups: [:development, :test]
```

4. Create Active Storage associations to one or many attached file/s . Multi-file uploads refence an array of AS objects. There is no column defined on the model side (no migration). Active Storage takes care of the mapping between your records and the attachment. If we wanted an AR reference to AS, then use CarrierWave with Cloudinary.

  - Add to your model file, such at `Post.rb` or `User.rb`. If you don't have a User model already, as in Devise:  `generate model User image:attachment`. 
``` 
  # one image @ AWS:
  has_one_attached :image, service: :amazon 
  
  # array of simultaneoulsy uploaded images @ AWS:
  has_many_attached :images, service: :amazon
  
  # one image @ Cloudinary:
  has_one_attached :ava, service: :cloudinary
```  
 
  - update controller to allow
  - non-devise models
```
  private
    def user_params
      params.require(:user).permit(:email_address, :password, :image, images[])
    end
```  
  - or in the case of Devise, use application controller:
```	
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) {
          |u| u.permit(:email, :password, :password_confirmation, :token, :avatar)}

      devise_parameter_sanitizer.permit(:account_update) { 
        |u| u.permit(:email, :password, :password_confirmation, :current_password, :avatar)}
    end
```  	
5. UI
  - add to file_field/s to your edit (new, update) form:
```
  <div>
    <%= form.file_field :image  %><br>
  </div>
  <diV>
    <%= form.file_field :images, multiple: true  %><br>
  </div>
 ```
  - add to your view, existence methods vary by source, url helpers vary by source:
 ```  	
      <% if post.image.attached? %>Amazon one:
        <%= image_tag url_for(post.image), :height=>100 %>
      <% end %>

      <% if !post.images.nil? 
        post.images.each { |img| %><br>Amazon n:<br>
          <%= image_tag url_for(img), :height=>100 %>
        <% } %>
      <% end %>
      
      <% if !post.avatar.file.nil? %> <br>CL uploader:
          <%= cl_image_tag post.avatar, :width=>150, :crop=>"fill" %>
      <% end %>
      
      <% if post.ava.persisted? %><br> Cl not uploader:
        <%= cl_image_tag post.ava.key, :width=>150 %>
      <% end %>
```
6. Removing files, define a route to purge the record:
```
  user.avatar.purge
```
7. Download from ui for non-cloudinary images:
```
<%= link_to '🔽', 
    rails_blob_path(img, disposition: "attachment") %>
```