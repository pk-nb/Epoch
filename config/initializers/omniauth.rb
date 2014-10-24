OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '600492169048-aik1d57ijkuhpk2grll471p4ejo1c1u2.apps.googleusercontent.com',
           'PkWPes5xNEyR9QE69YvF16IL', {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  provider :facebook, '322861781229311', '87c324c74416c2a57b9fa770e92a6e8f',
           {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  provider :twitter, 'Z6ZnqELqIAds2p9RM9tsu0ADf', 'Epq7T8mJvvUpAMrqpAvZkx4aFdLWRqZRPVAl4r7WACyLvjog1X',
           {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  #provider :github, '4a1e7283b9233feae152', '85e795ea993cc64c2abea5f8ab77d1bce5cee5d3',
  #       {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}
  provider :github, '0277cf29d8fd96eadf2c', '65abf7f423dd201c935bc54b1e59b02d3ddbb177',
         {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}
end