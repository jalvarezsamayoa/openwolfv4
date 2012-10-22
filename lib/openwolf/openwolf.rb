#openwolf.rb

module Openwolf

  def logger
    Rails.logger if defined?(Rails)
  end
end

require 'openwolf/laip/actividad'