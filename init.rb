require 'redmine'

Redmine::Plugin.register :redmine_version_calendar do
  name 'Version Calendar'
  author 'Lucas Panjer'
  description 'A global version calendar and roadmap'
  version '0.0.1'

  menu :top_menu, :version_calendar, { :controller => 'version_calendar', :action => 'index' }, :caption => 'Versions'
end
