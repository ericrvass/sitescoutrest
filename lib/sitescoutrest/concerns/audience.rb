module Sitescoutrest
  module Concerns
    module Audience

      def get_audiences(options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        params = options[:params] || {}
        path = "/advertisers/#{advertiser_id}/audiences "
        result = get(path, params, oauth_token)
        return result
      end
      
      def create_audience(audience_data, options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        path = "/advertisers/#{advertiser_id}/audiences "
        content_type = 'application/json'
        result = data_post(path, content_type, audience_data, oauth_token)
        return result
      end
      
      def get_audience_tracking_link(audience_id, link_type, options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        params = options[:params] || {"type" => link_type}
        path = "/advertisers/#{advertiser_id}/audiences/#{audience_id}/tag"
        result = get(path, params, oauth_token)
        return result
      end
      
    end
  end
end