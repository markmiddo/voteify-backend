class AvatarUploader < BaseUploader
  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fill: [30, 30]
  end

  version :medium do
    process resize_to_fill: [170, 170]
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
