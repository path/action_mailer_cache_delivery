require File.dirname(__FILE__) + '/spec_helper'

require 'action_mailer'

ActionMailer::Base.send(:include, ActionMailerCacheDelivery)
ActionMailer::Base.template_root = File.dirname(__FILE__) + '/mail_templates'

class OurMailer < ActionMailer::Base 
  def testmail(rec = "user@domain.com")
    recipients rec
  end
end

describe "ActionMailerCacheDelivery" do 
  
  before do 
    ActionMailer::Base.delivery_method = :cache
    ActionMailer::Base.clear_cache
    @mail = OurMailer.create_testmail
  end
  
  it "should create class method cached_deliveries when included" do 
    ActionMailer::Base.should respond_to(:cached_deliveries)
  end
  
  it "should create class method cached_deliveries when included" do 
    ActionMailer::Base.should respond_to(:clear_cache)
  end
  
  it "should deliver mail to our cache when delivery_method is set to :cache" do 
    OurMailer.any_instance.expects(:perform_delivery_cache).with(@mail)
    OurMailer.deliver(@mail)
  end
  
  it "should not deliver mail to our cache when delivery_method is not set to :cache" do 
    ActionMailer::Base.delivery_method = :test
    OurMailer.any_instance.expects(:perform_delivery_cache).never
    OurMailer.deliver(@mail)
  end
  
  it "should append mail to the cache" do 
    ActionMailer::Base.clear_cache
    ActionMailer::Base.cached_deliveries.should be_empty
    OurMailer.deliver(@mail)
    ActionMailer::Base.cached_deliveries.size.should be(1)
    OurMailer.deliver(@mail)
    ActionMailer::Base.cached_deliveries.size.should be(2)
  end
  
  it "should be clearable" do 
    OurMailer.deliver(@mail)
    ActionMailer::Base.cached_deliveries.should_not be_empty
    ActionMailer::Base.deliveries.should_not be_empty
    
    ActionMailer::Base.clear_cache
    
    ActionMailer::Base.cached_deliveries.should be_empty
    ActionMailer::Base.deliveries.should be_empty
  end
end
