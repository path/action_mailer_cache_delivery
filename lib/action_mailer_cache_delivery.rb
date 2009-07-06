module ActionMailerCacheDelivery 
  DELIVERIES_CACHE_PATH =
    File.join(RAILS_ROOT,'tmp','cache','action_mailer_cache_deliveries.cache')

  def self.included(base) 
    base.extend(ClassMethods)
  end
  
  def perform_delivery_cache(mail)
    deliveries << mail
    File.open(DELIVERIES_CACHE_PATH,'w') do |f|
      Marshal.dump(deliveries, f)
    end
  end
  
  module ClassMethods 
    def cached_deliveries
      return [] unless File.exists?(DELIVERIES_CACHE_PATH) 
      
      File.open(DELIVERIES_CACHE_PATH,'r') do |f|
        Marshal.load(f)
      end
        
    end
    
    def clear_cache
      ActionMailer::Base.deliveries = []
      File.delete(DELIVERIES_CACHE_PATH) if File.exists?(DELIVERIES_CACHE_PATH)
    end
  end
end
