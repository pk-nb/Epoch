OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '600492169048-aik1d57ijkuhpk2grll471p4ejo1c1u2.apps.googleusercontent.com',
           'PkWPes5xNEyR9QE69YvF16IL', {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}
end