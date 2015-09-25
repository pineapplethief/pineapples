CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp')
  config.cache_dir = 'carrierwave'

  if Rails.env.production?
    config.storage = :aws
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7

    config.aws_attributes = {
      expires: 1.week.from_now.httpdate,
      cache_control: 'max-age=604800'
    }

    config.aws_credentials = {
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }

    config.aws_bucket = ENV.fetch('AWS_BUCKET')
  end

end
