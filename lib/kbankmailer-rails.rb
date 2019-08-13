require 'active_support/rescuable'
require 'action_mailer'

module KbankmailerRails
  module ActionMailerExtensions
    def metadata
      @_message.metadata
    end

    def metadata=(val)
      @_message.metadata=(val)
    end
  end

  def self.install
    ActionMailer::Base.add_delivery_method :kbankmailer, Mail::Kbankmailer
    ActionMailer::Base.send(:include, ActionMailerExtensions)
  end
end

if defined?(Rails)
  require 'kbankmailer-rails/railtie'
else
  KbankmailerRails.install
end
