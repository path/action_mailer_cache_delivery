require File.dirname(__FILE__) + '/spec_helper'

require 'action_mailer'

ActionMailer::Base.send(:include, ActionMailerCacheDelivery)
ActionMailer::Base.template_root = File.dirname(__FILE__) + '/mail_templates'

class OurMailer < ActionMailer::Base 
  def testmail
  end
end

describe "ActionMailerCacheDelivery" do 
  
  before do 
    ActionMailer::Base.delivery_method = :test # Just in case....
    @mail = OurMailer.create_testmail
  end
  
  it "should create class method cached_deliveries when included" do 
    ActionMailer::Base.should respond_to(:cached_deliveries)
  end
  
  it "should deliver mail to our cache when delivery_method is set to :cache" do 
    ActionMailer::Base.delivery_method = :cache
    OurMailer.any_instance.expects(:perform_delivery_cache).with(@mail)
    OurMailer.deliver(@mail)
  end
  
  it "should not deliver mail to our cache when delivery_method is not set to :cache" do 
    ActionMailer::Base.delivery_method = :test
    OurMailer.any_instance.expects(:perform_delivery_cache).never
    OurMailer.deliver(@mail)
  end
end
