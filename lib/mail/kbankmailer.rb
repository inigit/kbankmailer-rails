require 'mail/http_client'

module Mail
  class Kbankmailer

    attr_accessor :settings

    def initialize(values)
      self.settings = { :partner_id => ENV['KBANKMAILER_PARTNER_ID']}.merge(values)
      self.settings = { :partner_secret => ENV['KBANKMAILER_PARTNER_SECRET']}.merge(values)
      self.settings = { :partner_host => ENV['KBANKMAILER_PARTNER_HOST']}.merge(values)
      self.settings = { :partner_path => ENV['KBANKMAILER_PARTNER_PATH']}.merge(values)
    end

    def deliver!(mail)
      settings = self.settings.dup
      partner_id = settings.delete(:partner_id)
      partner_secret = settings.delete(:partner_secret)
      partner_host = settings.delete(:partner_host)
      partner_path = settings.delete(:partner_path)
      client = Mail::HttpClient.new(partner_id, partner_secret, partner_host, partner_path, settings)
      response = client.deliver(mail)

      if settings[:return_response]
        response
      else
        self
      end
    end

  end
end