# RailsSettings Model
class Setting < RailsSettings::Base
  source Rails.root.join("config/settings.yml")
  namespace Rails.env
end
