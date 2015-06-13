require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "208de6b72385fa80f78ae220bd9ebb31c7ea2cf34742f142706480ef514de305"

  url_format "/media/:job/:name"

  if Rails.env.test? || Rails.env.development?
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
  else
  	datastore :s3,
      bucket_name: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['S3_KEY'],
      secret_access_key: ENV['S3_SECRET'],
      url_scheme: 'http',
      url_host: 'bootcamp6-olenderhub.s3.amazonaws.com',
      region: 'us-west-2'
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end

