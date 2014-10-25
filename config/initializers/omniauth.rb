OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_ID'],
           ENV['GOOGLE_SECRET'], {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'],
           {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  provider :twitter, ENV['TWITTER_ID'], ENV['TWITTER_SECRET'],
           {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}

  provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET'],
         {client_options: {ssl: {ca_file: Rails.root.join('cacert.pem').to_s}}}
end