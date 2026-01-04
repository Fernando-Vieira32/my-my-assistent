# frozen_string_literal: true

require_relative '../../services/date_time_info'

RSpec.describe Services::DateTimeInfo do
  describe '.date' do
    it do
      result = described_class.date
      expect(result).to match(%r{\d{2}/\d{2}/\d{4}})
    end
  end

  describe '.time' do
    it do
      result = described_class.time
      expect(result).to match(/\d{2}:\d{2}:\d{2}/)
    end
  end
end
