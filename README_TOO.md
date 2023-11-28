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
3. Declare Active Storage services 
3. a. in config/storage.yml
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
3. b. or just config/cloudinary.yml

 (or cloudinary.yml)
```
    cloud_name: <%= ENV["cloudinary_cloud"] %>
    api_key: <%= ENV["cloudinary_key"] %>
    api_secret: <%= ENV["cloudinary_secret"] %>
```  
3. c. config/environments/development.rb, production.rb, test.rb
```
  	config.active_storage.service = :cloudinary #  :amazon
```
3. d. store env vars (demo using dotenv for dev and env vars at Render)

4. Active Storage declare one or many (array) attached file/s. There is no column defined on the model side (no migration), Active Storage takes care of the mapping between your records and the attachment. IF we wanted a model reference to AS, then CarrierWave with Cloudinary.

  4. a. Add to your model file, such at Post.rb or User.rb, several possibilities: 
``` 
  # one image @ AWS:
  has_one_attached :image, service: :amazon 
  
  # array of simultaneoulsy uploaded images @ AWS:
  has_many_attached :images, service: :amazon
  
  # one image @ Cloudinary:
  has_one_attached :ava, service: :cloudinary
```  
 If you don't have a User model already, as in Devise, 
   generate model User image:attachment
 
 4. b. update controller to allow
  1) non-devise models
```
  private
    def user_params
      params.require(:user).permit(:email_address, :password, :image, images[])
    end
```  
  2) or in the case of Devise, use application controller:
```	
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) {
          |u| u.permit(:email, :password, :password_confirmation, :token, :avatar)}

      devise_parameter_sanitizer.permit(:account_update) { 
        |u| u.permit(:email, :password, :password_confirmation, :current_password, :avatar)}
    end
```  	
5. UI
   5. a. add to file_field/s to your edit (new, update) form:
```
  <div>
    <%= form.file_field :image  %><br>
  </div>
  <diV>
    <%= form.file_field :images, multiple: true  %><br>
  </div>
 ```
   5. b. add to your view, existence methods vary by source, url helpers vary by source:
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
7. Download from ui
```
   rails_blob_path(user.avatar, disposition: "attachment")
```
Non-cloudinary:
```
<%= link_to '🔽', 
    rails_blob_path(img, disposition: "attachment") %>
```