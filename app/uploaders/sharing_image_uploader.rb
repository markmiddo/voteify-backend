class SharingImageUploader < BaseUploader

  include CarrierWave::MiniMagick

  process base_resize: [600, 315]
end
