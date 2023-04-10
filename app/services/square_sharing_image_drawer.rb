require 'mini_magick'

class SquareSharingImageDrawer < BasicSharingImageDrawer
  TRACK_FONT_NAME = REGISTERED_FONTS[:roboto_bold]
  TRACK_NAME_MAX_LENGTH = 55

  private

  def track_percentage_position
    { left: 5, bottom: 15 }
  end

  def calculate_font_size(image)
    relative_font_size = 3.7
    percent_from_number(image.width, relative_font_size)
  end

  def calculate_line_spacing_size(image)
    relative_line_spacing_value = 1.4
    calculate_font_size(image) * relative_line_spacing_value
  end
end
