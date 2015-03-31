
if Rails.env.development?
   Gibbon::API.api_key = ENV["MAILCHIMP_API_KEY"]
end

if Rails.env.production?
   Gibbon::API.api_key = ENV["api_key"]
end

Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false
