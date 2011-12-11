Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'GEMKYg2mc8HL4YbL6dbhGQ', 'tdwfvrxHQCy7KSR1scXHvrbBavBtVeFcR2WWEXAJw'
  provider :facebook, '172907689472610','24c455d09d59ce69afa3a82cb0a4c3b1'
end

