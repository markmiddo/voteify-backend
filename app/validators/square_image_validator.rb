require 'mini_magick'

class SquareImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, image)
    unless is_square_image?(image.file)
        record.errors.add attribute, (options[:message] || 'Image is not square')
    end
  end

  private

  def is_square_image?(file)
    width, height = MiniMagick::Image.open(take_image_path(file))[:dimensions]
    width === height
  end

  def take_image_path(file)
    file.path
  end
end