module GrowlHelper
  include Appscript
  extend self
  
  def growl(title, message)
    return unless ::Application.new("GrowlHelperApp").running?
    app("GrowlHelperApp").register(:all_notifications => [title], :as_application => APP_NAME, :icon_of_application => "Pomodoro", :default_notifications => [title])
    app("GrowlHelperApp").notify(:title => title, :application_name => APP_NAME, :with_name => title, :description => message)
  end
end
