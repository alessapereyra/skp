# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

module Kernel
 private
    def this_method_name
      caller[0] =~ /`([^']*)'/ and $1
    end
end


Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'mislav-will_paginate', :version => '~> 2.3.2', :lib => 'will_paginate', 
     :source => 'http://gems.github.com'

  config.gem 'barby'
  config.gem "prawn"
  config.gem 'flyerhzm-bullet', :lib => 'bullet', :source => 'http://gems.github.com'
  # config.gem "javan-whenever", :lib=>false, :source => "http://gems.github.com"
    
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_trunk_session',
    :secret      => '8d6525fe676b5c9f346f1b0ea50f20d225fa84b46830e7808c166fa170d8029d6d2601121646ab7aed0e89b3bd86a739a2209562f577c5b17033a80848c16907'
  }
  
  config.time_zone = "Lima"

  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"


  #ENV['RAILS_ASSET_ID'] = ''
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  #config.action_controller.session_store = :active_record_store
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  load(RAILS_ROOT + "/lib/numeric.rb")

end

#require 'will_paginate'


require "smtp_tls" 

ExceptionNotifier.exception_recipients = %w(alvaro.pereyra@srdperu.com)
  
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :enable_starttls_auto => true,  
  :port => 587,
  :domain => "skykidsperu.com",
  :authentication => :plain,
  :user_name => "control@skykidsperu.com",
  :password => "control"
}

=begin
ActionMailer::Base.server_settings = {
    :address        => 'mail.skykidsperu.com',
    :port           => 25,
    :authentication => :login,    # Don't change this one.
    :user_name      => "smtp_username",
    :password       => "smtp_password"
}
=end

ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"