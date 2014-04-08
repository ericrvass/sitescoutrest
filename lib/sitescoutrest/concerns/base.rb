module Sitescoutrest
  class AuthorizationFailedError < StandardError; end
  
  module Concerns
    module Base
      def authenticate(options = {})
        client_id = self.client_id || options[:client_id]
        client_secret = self.client_secret || options[:client_secret]
        result = auth_post(client_id, client_secret)
        self.oauth_token = result["access_token"]     
        return self.oauth_token
      end

      def check_result(result)
        if !result['errorCode'].blank? && (result['errorCode'].eql?("AE00002") || result['errorCode'].eql?("AE00001"))
          raise AuthorizationFailedError
        end
      end

      def get(path, params, oauth_token)
        tries = 2
        begin
          request = Net::HTTP::Get.new(params.blank? ? path : "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')))
          request['Authorization'] = api_header(oauth_token)
          request['Accept'] = 'application/json'
          response = http_connection.request(request)
          result = JSON.parse(response.body)
          check_result(result)
          return result
        rescue AuthorizationFailedError
          tries -= 1
          if tries > 0
            oauth_token = authenticate
            retry
          end
        rescue Exception => e 
          puts 'Error In GET: ' + e.message 
        end 
      end
    
      def get_text(path, params, oauth_token)
        tries = 2
        begin
          request = Net::HTTP::Get.new(params.blank? ? path : "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')))
          request['Authorization'] = api_header(oauth_token)
          request['Accept'] = 'text/html'
          response = http_connection.request(request)
          result = response.body
          #TODO: response not json
          #check_result(result)
          return result
        rescue AuthorizationFailedError
          tries -= 1
          if tries > 0
            oauth_token = authenticate
            retry
          end
        rescue Exception => e 
          puts 'Error In GET: ' + e.message 
        end 
      end

      def data_post(path, content_type, json_data, oauth_token)
        tries = 2
        begin
          request = Net::HTTP::Post.new(path, initheader = {'Content-Type' => content_type})
          request['Authorization'] = api_header(oauth_token)
          request['Accept'] = 'application/json'
          request.body = json_data
          response = http_connection.request(request)
          result = JSON.parse(response.body)
          check_result(result)
          return result
        rescue AuthorizationFailedError
          tries -= 1
          if tries > 0
            oauth_token = authenticate
            retry
          end
        rescue Exception => e 
          puts 'Error In Data POST: ' + e.message 
        end 
      end

      def auth_post(client_id, client_secret)
        begin
          path = "/oauth/token"
          request = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
          request['Authorization'] = auth_header(client_id, client_secret)
          request.set_form_data({"grant_type" => "client_credentials"})
          response = http_connection.request(request)
          result = JSON.parse(response.body)
          return result
        rescue Exception => e 
          puts 'Error Authenticating: ' + e.message 
        end 
      end

      def file_post(path, content_type, file, oauth_token)
        begin
          request = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>content_type})
          request['Authorization'] = api_header(oauth_token)
          request['Accept'] = 'application/json'
          request.body = file
          response = http_connection.request(request)
          result = JSON.parse(response.body)
          check_result(result)
          return result
        rescue AuthorizationFailedError
          tries -= 1
          if tries > 0
            oauth_token = authenticate
            retry
          end
        rescue Exception => e 
          puts 'Error In File POST: ' + e.message 
        end 
      end

      def http_connection(options = {})
        uri = URI.parse("https://#{self.host || options[:host]}")
        connection = Net::HTTP.new(uri.host, uri.port)
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
        return connection
      end

      def auth_header(client_id, client_secret)
        credential = "#{client_id}:#{client_secret}"
        "Basic #{Base64.encode64(credential)}".delete("\n")
      end

      def api_header(oauth_token)
        "Bearer #{oauth_token}"
      end  
    end
  end
end