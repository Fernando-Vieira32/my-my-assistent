# frozen_string_literal: true

require_relative '../../services/date_time_info'

RSpec.describe Services::DateTimeInfo do
  describe '.date' do
    subject(:date) { described_class.date }

    it { expect(date).to eq(Date.today.strftime('%d/%m/%Y')) }
  end

  describe '.time' do
    subject(:time) { described_class.time }

    it { expect(time).to eq(Time.now.strftime('%H:%M:%S')) }
  end
end
