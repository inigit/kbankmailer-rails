require 'faraday'
require 'json'
require 'mail/custom_exception'

module Mail
  class HttpClient
    attr_accessor :partner_id, :partner_secret, :partner_host, :partner_path

    DEFAULTS = {
        :partner_id => 'partner_id',
        :partner_secret => 'partner_secret',
        :request_timeout => 5
    }

    def initialize(partner_id, partner_secret, partner_host, partner_path, options = {})
      @partner_id = partner_id
      @partner_secret = partner_secret
      @partner_host = partner_host
      @partner_path = partner_path
    end

    def deliver(message = {})

      emails = message.to.join(",")

      data =  {
          "partner_id": self.partner_id.to_s,
          "partner_secret": self.partner_secret.to_s,
          "email": emails,
          "topic": message.subject,
          "message": message.body.encoded
      }
      Faraday.new(self.partner_host.to_s, request: { timeout: DEFAULTS[:request_timeout] }) do |conn|
        conn.request :retry, max: 2, interval: 1,
                     interval_randomness: 0.5, backoff_factor: 2,
                     exceptions: [Mail::CustomException, 'Timeout::Error']
        #conn.response :detailed_logger, Rails.logger
        conn.adapter Faraday.default_adapter
        conn.headers['Content-Type'] = 'application/json'

        response = conn.post do |req|
          req.url self.partner_path.to_s
          req.body = data.to_json
        end

        Rails.logger.info message: "Send Email Request",
                          email: message.to,
                          topic: emails,
                          body: message.body.encoded
        raise Mail::CustomException if response.status == 502 || response.status == 501
      end
    end
  end
end
