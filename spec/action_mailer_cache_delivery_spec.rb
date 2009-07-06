require File.dirname(__FILE__) + '/spec_helper'

class MixinReceiver 
  include ActionMailerCacheDelivery
end

describe "ActionMailerCacheDelivery" do 
  
  before do 
    @obj = MixinReceiver.new
  end
  
  it "should mixin perform_delivery_cache" do 
    @obj.should respond_to(:perform_delivery_cache)
  end
  
  it "should create class method cached_deliveries" do 
    MixinReceiver.should respond_to(:cached_deliveries)
  end
end
