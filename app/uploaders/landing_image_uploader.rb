class LandingImageUploader < BaseUploader

  include CarrierWave::MiniMagick

  version :very_small do
    process resize_to_fill: [46, 64]
    end

  version :small do
    process resize_to_fill: [100, 139]
  end

  version :medium do
    process resize_to_fill: [170, 236]
  end

end
