Apipie.configure do |config|
  config.app_name                = "TodoApi"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.default_version         = "v1"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end

class FileValidator < Apipie::Validator::BaseValidator
  def validate(value)
    ActionDispatch::Http::UploadedFile === value
  end

  def self.build(param_description, argument, options, block)
    self.new param_description if argument == File
  end

  def description
    "Must be a valid file"
  end
end
