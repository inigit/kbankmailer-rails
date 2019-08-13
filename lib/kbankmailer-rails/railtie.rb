module KbankmailerRails
  class Railtie < Rails::Railtie
    initializer 'kbankmailer-rails', :before => 'action_mailer.set_configs' do
      ActiveSupport.on_load :action_mailer do
        KbankmailerRails.install
      end
    end
  end
end
