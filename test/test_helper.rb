ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def mock_auth
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '123545',
      person_id: '1',
      credentials: {
        token: 'token',
        expires_at: Time.now + 10000000
      },
      info: {
        first_name: 'first_name',
        last_name: 'last_name'
      }
    })
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def log_in
    visit '/login'
    fill_in(I18n.t(:email, scope: ['activerecord.session']).capitalize, :with => "test1@test.pl")
    fill_in(I18n.t(:password, scope: ['activerecord.session']).capitalize, :with => "test1")
    click_on(I18n.t(:Log_in, scope: ['activerecord.session']).capitalize)
  end

  teardown do
    Capybara.reset!
    Capybara.use_default_driver
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
