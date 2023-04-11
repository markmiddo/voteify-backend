require 'mini_magick'

class BasicSharingImageDrawer
  TITLE_FONT_SIZE = '32'
  TRACK_LIST_FONT_SIZE = '14'
  REGISTERED_FONTS = {
      roboto_light:   "#{Rails.root}/public/fonts/Roboto-Light.ttf",
      roboto_bold:    "#{Rails.root}/public/fonts/Roboto-Bold.ttf",
      roboto_regular: "#{Rails.root}/public/fonts/Roboto-Regular.ttf",
  }

  SUB_TITLE= 'I voted for'
  TITLE = "Voteify #{Date.today.year}"
  TRACK_NAME_MAX_LENGTH = 40
  TRACK_LINE_SPACING_INTERVAL = 25
  TRACK_FONT_NAME = REGISTERED_FONTS[:roboto_regular]


  def initialize(basic_image, text_color, track_list)
    @basic_image = basic_image
    @text_color = text_color
    @event_track_list = track_list
  end

  def make_image
    image = MiniMagick::Image.open(get_image_path)
    image = draw_tracks image
    image
  end

  def draw_tracks image
    bottom_track_position_value = calculate_bottom_track_position(image)
    left_track_position_value = calculate_left_track_position(image)
    font_size = calculate_font_size(image)
    track_interval = calculate_line_spacing_size(image)

    image.combine_options do |c|
      c.font self.class::TRACK_FONT_NAME
      c.pointsize font_size
      top_track_position = image.height - bottom_track_position_value
      track_names = take_track_names(@event_track_list)
      track_names.reverse.each do |track_name|
        safe_track_name = escape_single_quote(track_name)
        c.draw "text #{left_track_position_value},#{top_track_position} '#{safe_track_name}'"
        c.fill @text_color
        top_track_position -= track_interval
      end
    end
  end

  def take_track_names(track_list)
    track_list.map.with_index(1) do |event_track, index|
      track_name = event_track.track.track_name.truncate(self.class::TRACK_NAME_MAX_LENGTH)
      "#{index}. #{track_name}"
    end
  end

  private

  def get_image_path
    @basic_image.path
  end

  def track_percentage_position
    { left: 10, bottom: 10 }
  end

  def calculate_bottom_track_position(image)
    track_position = track_percentage_position
    percent_from_number(image.height, track_position[:bottom])
  end

  def calculate_left_track_position(image)
    track_position = track_percentage_position
    percent_from_number(image.width, track_position[:left])
  end

  def calculate_font_size(image)
    self.class::TRACK_LIST_FONT_SIZE
  end

  def calculate_line_spacing_size(image)
    self.class::TRACK_LINE_SPACING_INTERVAL
  end

  def percent_from_number(number, percent_value)
    number.to_f * percent_value.to_f / 100.0
  end

  def escape_single_quote(str)
    str.gsub("'", "\\\\'")
  end
end
