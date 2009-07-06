#require File.join(File.dirname(__FILE__), 'lib', 'action_mailer_cache_delivery')
require 'action_mailer_cache_delivery'

ActionMailer::Base.class_eval do
  include ActionMailerCacheDelivery
end