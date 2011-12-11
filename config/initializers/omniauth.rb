Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'key', 'secret'
  provider :facebook, 'key', 'secret'
end

