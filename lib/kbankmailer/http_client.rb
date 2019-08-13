require 'faraday'
require 'json'

module Kbankmailer
  class HttpClient
    attr_accessor :partner_id, :partner_secret, :partner_host

    DEFAULTS = {
        :partner_id => 'partner_id',
        :partner_secret => 'partner_secret',
        :request_timeout => 5
    }

    def initialize(partner_id, partner_secret, partner_host, options = {})
      @partner_id = partner_id
      @partner_secret = partner_secret
      @partner_host = partner_host
      @http = build_http
    end

    def deliver(message_hash = {})
      data = Json.encode({
                             "email": message_hash[:to],
                             "topic": message_hash[:subject],
                             "message": message_hash[:html_part]

                         })
      Faraday.new(self.partner_host.to_s, request: { timeout: DEFAULTS[:request_timeout] }) do |conn|
        conn.request :retry, max: 2, interval: 1,
                     interval_randomness: 0.5, backoff_factor: 2,
                     exceptions: [CustomException, 'Timeout::Error']
        conn.response :logger
        conn.adapter Faraday.default_adapter
        conn.headers[DEFAULTS[:partner_id]] = self.partner_id.to_s
        conn.headers[DEFAULTS[:partner_secret]] =  self.partner_secret.to_s
        conn.headers['Content-Type'] = 'application/json'
        response = conn.post('/proxy_send_email', data)
        raise CustomException if response.status == 502
      end
    end

  end
end
