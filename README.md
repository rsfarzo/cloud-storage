
# Active Storage

- Uses AWS S3 for `User.avatar Post.image Post.images[]`
  - no migrations necessary
- Uses Cloudinary & Carrierwave for `Post.avatar`

```
rails active_storage:install
rails db:migrate
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

```
rails generate uploader Avatar
rails generate migration add_avatar_to_posts avatar:string
rails db:migrate
```
Mount the uploader to the user model:
```
mount_uploader :imagelib, AvatarUploader
```

```
gem "dotenv-rails"
```

## Template that includes devise, BS5
- The following are how features and config were applied.

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
     * Not required *



- Ruby version: `3.2.2`
- Rails version: `7.0.4.3`
