module Mail
  class Kbankmailer

    attr_accessor :settings

    def initialize(values)
      self.settings = { :partner_id => ENV['KBANKMAILER_PARTNER_ID']}.merge(values)
      self.settings = { :partner_secret => ENV['KBANKMAILER_PARTNER_SECRET']}.merge(values)
      self.settings = { :partner_host => ENV['KBANKMAILER_PARTNER_URL']}.merge(values)
    end

    def deliver!(mail)
      settings = self.settings.dup
      partner_id = settings.delete(:partner_id) || settings.delete(:partner_id)
      partner_secret = settings.delete(:partner_secret) || settings.delete(:partner_secret)
      partner_host = settings.delete(:partner_host) || settings.delete(:partner_host)
      client = ::Kbankmailer::HttpClient.new(partner_id, partner_secret, partner_host, settings)
      response = client.deliver(mail)

      if settings[:return_response]
        response
      else
        self
      end
    end

  end
end