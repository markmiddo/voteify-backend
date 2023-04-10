class BaseUploader < CarrierWave::Uploader::Base


  storage :file

  def store_dir
    "uploads/#{Rails.env.test? ? 'test/' : ''}user/#{mounted_as}/#{model.id}"
  end

  def base_resize(width, height)
    manipulate! do |img|
      img.resize "#{width}x#{height}!"
      img
    end
  end
end
