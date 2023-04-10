class ImageUploader < BaseUploader
  def extension_whitelist
    %w(jpg jpeg png)
  end
end
