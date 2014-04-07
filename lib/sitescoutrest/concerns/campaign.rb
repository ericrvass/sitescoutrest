module Sitescoutrest
  module Concerns
    module Campaign

      def get_campaigns(options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        params = options[:params] || {}
        path = "/advertisers/#{advertiser_id}/campaigns"
        result = get(path, params, oauth_token)
        return result
      end
      
      def create_campaign(campaign_data, options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        path = "/advertisers/#{advertiser_id}/campaigns"
        content_type = 'application/json'
        result = data_post(path, content_type, campaign_data, oauth_token)
        return result
      end
      
    end
  end
end