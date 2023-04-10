class FileUploader < BaseUploader

  def extension_whitelist
    %w(csv)
  end
end
