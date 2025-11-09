CarrierWave.configure do |config|
  if Rails.env.production? || ENV["USE_OBJECT_STORAGE"] == "true"
    config.storage = :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV.fetch("MINIO_ACCESS_KEY", ""),
      aws_secret_access_key: ENV.fetch("MINIO_SECRET_KEY", ""),
      region: ENV.fetch("AWS_REGION", "ap-northeast-1"),
      host: ENV.fetch("MINIO_HOST", "minio"),
      endpoint: ENV.fetch("MINIO_ENDPOINT", "http://minio:9000"),
      path_style: true
    }
    config.fog_directory = ENV.fetch("MINIO_BUCKET", "aidia-uploads")
  else
    config.storage = :file
    config.enable_processing = !Rails.env.test?
    config.root = Rails.root.join("storage", "carrierwave")
  end
end
