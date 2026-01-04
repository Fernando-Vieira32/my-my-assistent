# frozen_string_literal: true

require 'date'
require 'time'

module Services
  module DateTimeInfo
    def self.date
      Date.today.strftime('%d/%m/%Y')
    end

    def self.time
      Time.now.strftime('%H:%M:%S')
    end
  end
end
