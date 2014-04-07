require "sitescoutrest/concerns/base"
require "sitescoutrest/concerns/campaign"

module Sitescoutrest
  # Interface for using the SiteScout REST API
  class Client
    include Sitescoutrest::Concerns::Base
    include Sitescoutrest::Concerns::Campaign
    
    # The OAuth client id
    attr_accessor :client_id
    # The OAuth client secret
    attr_accessor :client_secret
    # The OAuth access token
    attr_accessor :oauth_token
    # The Host
    attr_accessor :host
    # The Advertiser ID
    attr_accessor :advertiser_id
    
    def initialize(options = {})
      if options.is_a?(String)
        @options = YAML.load_file(options)
      else
        @options = options
      end
      @options.symbolize_keys!
      
      self.client_id = ENV['SITESCOUTREST_CLIENT_ID'] || @options[:client_id]
      self.client_secret = ENV['SITESCOUTREST_CLIENT_SECRET'] || @options[:client_secret]
      self.host = ENV['SITESCOUTREST_HOST'] || @options[:host] || "api.sitescout.com"
      self.advertiser_id = ENV['SITESCOUTREST_ADVERTISER_ID'] || @options[:advertiser_id]
    end
    
  end
end