class SampleUploader < CarrierWave::Uploader::Base
  storage Rails.env.production? ? :fog : :file

  def store_dir
    "carrierwave/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    %w[jpg jpeg png gif webp heic heif]
  end
end
