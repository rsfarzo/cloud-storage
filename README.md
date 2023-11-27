
# Active Storage

- Uses AWS S3 for `User.avatar Post.image Post.images[]`
  - no migrations necessary
- Uses Cloudinary & Carrierwave for `Post.avatar`

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
## AWS S3
- using .env, so add to .gitignore
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
  <div class="field">
    <%= form.label :avatar %>
    <%= form.file_field :avatar %>
  </div>
  ```



- [Overview](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Avatar example honeybadger](https://www.honeybadger.io/blog/rails-app-aws-s3/)
- [AWS config](https://github.com/aws/aws-sdk-ruby#configuration)
- [Ruby on rails doc](https://edgeguides.rubyonrails.org/active_storage_overview.html)
- [Validations, Enc](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails)
- [Validations](https://github.com/igorkasyanchuk/active_storage_validations)
- [Multi files](https://medium.com/@jedwardmook/uploading-multiple-files-using-rails-active-storage-and-react-219f07b5ac25)
- [Multiple storage services](https://discuss.rubyonrails.org/t/activestorage-with-multiple-storage-services-and-multiple-environments-issue/82497)

### Carrierwave, Cloudinary
- [Carierwave](https://github.com/carrierwaveuploader/carrierwave)
- [Carrierwave and Cloudinary](https://cloudinary.com/documentation/rails_carrierwave)
- [Tutorial Cloudinary](https://training.cloudinary.com/courses/introduction-for-api-users-and-ruby-developers)
- [Github cloudinary](https://github.com/cloudinary-training/cld-intro-ruby)
- [Carrierwave gist](https://gist.github.com/Hinsei/346eebe1175e49296b13a5f1e28850a6)

Continuing with example:

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
- Mount the uploader to the posts model:
```
mount_uploader :imagelib, AvatarUploader
```

## `post.rb` model
2 amazon and 1 cloudinary through uploader
```
    has_one_attached :image, service: :amazon
    has_many_attached :images, service: :amazon
    mount_uploader :avatar, AvatarUploader
```

## Postgres for prod env
- change database.yml 
- `rails db:create`
- `rails s`  instead of  `bin/dev`

## bootstrap 5 & JS
[ref](https://www.linkedin.com/pulse/rails-7-bootstrap-52-importmap-md-habibur-rahman-habib)

## devise
- [github](https://github.com/heartcombo/devise#getting-started)
- [rails girls](https://guides.railsgirls.com/devise)
```
rails generate devise:install

<%= link_to "Sign out", destroy_user_session_path, data: { "turbo-method": :delete }, class: "nav-link" %>`

rails generate devise:views
  config/initializers/devise.rb`=>`config.scoped_views = true
```
[adding extra fields](https://gist.github.com/withoutwax/46a05861aa4750384df971b641170407)
```
rails generate migration add_token_to_users token:string
```
Depending on your application's configuration some manual setup may be required:

  1. Ensure you have defined default url options in your environments files. Here
     is an example of default_url_options appropriate for a development environment
     in `config/environments/development.rb`:
```
       config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
     In production, `:host` should be set to the actual host of your application.

     * Required for all applications. *

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:
```
       root to: "home#index"
```    
     * Not required for API-only Applications *

  3. Ensure you have flash messages in app/views/layouts/application.html.erb.
     For example:
```
       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>
```
     * Not required for API-only Applications *

  4. You can copy Devise views (for customization) to your app by running:
```
       rails g devise:views
```       



- Ruby version: `3.2.2`
- Rails version: `7.0.4.3`
