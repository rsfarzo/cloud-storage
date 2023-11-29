
[Link to Presentation](https://docs.google.com/presentation/d/1yXV2cLLL3RMyuqaR0l5MeesUTAWZv1x6/edit?usp=sharing&ouid=102117242305186913702&rtpof=true&sd=true)



- listing `representable?` etc
- purging

# Credentials
- [rails way](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails)
- [and note production use here](https://web-crunch.com/posts/the-complete-guide-to-ruby-on-rails-encrypted-credentials)
- `dotenv-rails` gem

# Active Storage

- Uses AWS S3 for `User.avatar`, `Post.image`, and `Post.images[]`
- Uses Cloudinary for `Post.ava`
- Uses Cloudinary & Carrierwave for `Post.avatar`
  - a bit more complicated, but allows for your own Active Record integration

Gems:
```
gem "dotenv-rails", groups: [:development, :test]
gem "aws-sdk-s3"
gem "carrierwave", '~> 3.0'
gem "cloudinary"
```
Terminal:
```
rails active_storage:install
rails db:migrate
```
# 1. AWS S3
[Set up S3](https://dev.to/nickmendez/how-to-configure-active-storage-with-amazon-aws-s3-cloud-storage-h)

- using `.env`, so add to `.gitignore`
```
S3_BUCKET=bbbbbbbbbbb
AWS_SECRET_KEY=oO+B16ZzfEi
AWS_ACCESS_KEY_ID=AAAAAAAAAAAAAA
AWS_REGION=us-9
AWS_SDK_CONFIG_OPT_OUT=true
cloudinary_cloud=00000000000
cloudinary_key=00000000000000000
cloudinary_secret=00000000000000000000000
CLOUDINARY_URL=cloudinary://5544487:3333333333333333333333
```
- In `config/storage.yml`:
```
amazon:
   service: S3
   access_key_id: <%= ENV["AWS_ACCESS_KEY_ID"] %>
   secret_access_key: <%= ENV["AWS_SECRET_ACCESS_KEY"] %>
   region: <%= ENV["AWS_REGION"] %>
   bucket: <%= ENV["S3_BUCKET"] %>
```
### User avatar with s3:
- In `user.rb` model: `has_one_attached :avatar, service: :amazon`
- In `application_controller.rb` configure_permitted_parameters to permit: ` :avatar`
- In `new.html.erb: 
```
  <%= f.label :avatar %>
  <%= f.file_field :avatar %>
```
- `user#edit.html.erb`
```
<% if @user.avatar.persisted? %>
  <%= image_tag(url_for(@user.avatar), style:"height:100px") %>
<% end %>
```
### Post image and images[] with S3, and avatar with cloudinary:
- `post.rb` model
```
    has_one_attached :image
    has_many_attached :images
    mount_uploader :avatar, AvatarUploader
```
- post#edit.html.erb:
```
  <div>
    <%= form.file_field :image  %><br>
  </div>
  <diV>
    <%= form.file_field :images, multiple: true  %><br>
  </div>
  <div>
    <%= form.label :avatar %>
    <%= form.file_field :avatar %>
  </div>
  ```
- In `config/storage.yml`:
  config.active_storage.service = :amazon # irrelvant if specified in model? :cloudinary


- [Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Avatar example honeybadger](https://www.honeybadger.io/blog/rails-app-aws-s3/)
- [AWS config](https://github.com/aws/aws-sdk-ruby#configuration)
- [Ruby on rails doc](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Validations, Enc](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails)
- [Validations](https://github.com/igorkasyanchuk/active_storage_validations)
- [Multi files](https://medium.com/@jedwardmook/uploading-multiple-files-using-rails-active-storage-and-react-219f07b5ac25)
- [Multiple storage services](https://discuss.rubyonrails.org/t/activestorage-with-multiple-storage-services-and-multiple-environments-issue/82497)

# 2. Cloudinary
- ref. [Super simple](https://dev.to/nilomiranda/setting-up-image-upload-with-cloudinary-rails-and-active-storage-3941)
- In `config/storage.yml` 
```
cloudinary:
    service: Cloudinary
    cloud_name: <%= ENV["cloudinary_cloud"] %>
    api_key: <%= ENV["cloudinary_key"] %>
    api_secret: <%= ENV["cloudinary_secret"] %>
    secure: true
    cdn_subdomain: true
    #folder: optional anyfoldername
```

- or (I do not do this) `config/cloudinary.yml`:
```
production:
    cloud_name: <%= ENV["cloudinary_cloud"] %>
    api_key: <%= ENV["cloudinary_key"] %>
    api_secret: <%= ENV["cloudinary_secret"] %>
    secure: true
    cdn_subdomain: true
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
- I skip this: `activestorage.js` in your application's JavaScript bundle:
```
//= require activestorage
```

- In `config/environments/development.rb` and `production.rb` (although I believe this is a default service and can be superceded at the model)
```
config.active_storage.service = :cloudinary
```
- In the model `Post.rb`, be sure to use the service attribute to disambiguate multiple ones
```
  # one image @ Cloudinary:
  has_one_attached :ava, service: :cloudinary
```

# 3. Carrierwave, Active Record, Cloudinary
Carrierwave adds a field to your Active Record models.  Active Storage will still use its own models.

- [Carierwave](https://github.com/carrierwaveuploader/carrierwave)
- [Carrierwave and Cloudinary](https://cloudinary.com/documentation/rails_carrierwave)
- [Tutorial Cloudinary](https://training.cloudinary.com/courses/introduction-for-api-users-and-ruby-developers)
- [Github cloudinary](https://github.com/cloudinary-training/cld-intro-ruby)
- [Carrierwave gist](https://gist.github.com/Hinsei/346eebe1175e49296b13a5f1e28850a6)


- `config/storage.yml`
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
    secure: true
    cdn_subdomain: true
```
- Generater an uploaded, modify Posts to include a string for the image
```
rails generate uploader Avatar
rails generate migration add_avatar_to_posts avatar:string
rails db:migrate
```
- In `app/uploaders/avatar_uploaded`, comment out everything except:
```
class AvatarUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
```
- Edit form:
```
  <div>
    <%= form.label :ava %>
    <%= form.file_field :ava, direct_upload: true %>
  </div>
```

## `post.rb` model
2 amazon, 1 cloudinary, and 1 cloudinary-carrierwave uploader
```
class Post < ApplicationRecord
 
  ...

  # Cloudinary with CarrierWave, stored in this model metadata as string:
  mount_uploader :avatar, AvatarUploader 
end
```

```
      <% if !post.avatar.nil? %> <br>CL uploader:
          <%= cl_image_tag post.avatar, :width=>150, :crop=>"fill" %>
      <% end %>
      
      <% if post.ava.persisted? %><br> Cl not uploader:
        <%= cl_image_tag post.ava.key, :width=>150 %>
      <% end %>
  ```

# 4. services combo example:

- `post.rb`
```
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
```

- `views/posts/_post.html` Cloudinary has its own helpers.
```
  <div class="card-body">
    <div id="<%= dom_id post %>">
      <% if post.image.persisted? %>Amazon one:
        <%= image_tag url_for(post.image), :height=>100 %>
      <% end %>

      <% if !post.images.nil? 
        post.images.each { |img| %><br>Amazon n:<br>
          <%= image_tag url_for(img), :height=>100 %>
        <% } %>
      <% end %>

      <% if !post.avatar.nil? %> <br>CL uploader:
          <%= cl_image_tag post.avatar, :width=>150, :crop=>"fill" %>
      <% end %>
      
      <% if post.ava.persisted? %><br> Cl not uploader:
        <%= cl_image_tag post.ava.key, :width=>150 %>
      <% end %>
    </div>
  </div>
  ```
