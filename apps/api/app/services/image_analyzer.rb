require "open3"

class ImageAnalyzer
  def initialize(blob_or_file)
    @blob = blob_or_file
  end

  def call
    data = { metadata: {}, labels: [], ocr_text: nil }

    with_file do |file|
      image = MiniMagick::Image.open(file.path)
      data[:metadata] = build_metadata(image)
      data[:labels] = guess_labels(image)
      data[:ocr_text] = extract_text(file.path)
    end

    data
  end

  private

  attr_reader :blob

  def with_file
    if blob.respond_to?(:open)
      blob.open { |file| yield(file) }
    else
      yield(blob)
    end
  end

  def build_metadata(image)
    exif = image.exif || {}
    {
      width: image.width,
      height: image.height,
      camera: exif["Model"],
      lens: exif["LensModel"],
      taken_at: parse_datetime(exif["DateTimeOriginal"]),
      iso: exif["ISOSpeedRatings"],
      exposure: exif["ExposureTime"]
    }.compact
  end

  def parse_datetime(value)
    return if value.blank?

    Time.zone.strptime(value, "%Y:%m:%d %H:%M:%S")
  rescue ArgumentError
    nil
  end

  def guess_labels(image)
    labels = []
    labels << "portrait" if image.height > image.width
    labels << "landscape" if image.width >= image.height
    brightness = normalized_brightness(image)
    labels << "bright" if brightness > 0.65
    labels << "lowlight" if brightness < 0.35
    labels.uniq
  end

  def normalized_brightness(image)
    MiniMagick::Tool::Convert.new do |convert|
      convert << image.path
      convert.colorspace "HSL"
      convert.channel "g"
      convert.separate
      convert.format "%[fx:mean]"
      convert << "info:"
    end.to_f
  rescue MiniMagick::Error
    0.5
  end

  def extract_text(path)
    stdout, _stderr, status = Open3.capture3("tesseract", path, "stdout", "-l", "jpn+eng")
    return stdout.strip if status.success?

    nil
  rescue Errno::ENOENT
    Rails.logger.info("[ImageAnalyzer] tesseract not found; skipping OCR and continuing without text")
    nil
  end
end
