Recaptcha.configure do |config|
  if Rails.env.production?
    config.site_key   = ENV['RECAPTCHA_PUBLIC_KEY']
    config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  elsif Rails.env.development?
    config.site_key   = Rails.application.credentials[Rails.env.to_sym][:RECAPTCHA_SITE_KEY]
    config.secret_key = Rails.application.credentials[Rails.env.to_sym][:RECAPTCHA_SECRET_KEY]
  else
    config.site_key = 'somesecretsitekey'
    config.secret_key = 'somesecretsecretkey'
  end
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
