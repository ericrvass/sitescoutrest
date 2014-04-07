module Sitescoutrest
  module Concerns
    module Creative
      
      def upload_asset(file, content_type, options = {})
        oauth_token = self.oauth_token || options[:oauth_token]
        advertiser_id = self.advertiser_id || options[:advertiser_id]
        path = "/advertisers/#{advertiser_id}/creatives/assets"
        result = file_post(path, content_type, file, oauth_token)
        return result
      end
      
    end
  end
end