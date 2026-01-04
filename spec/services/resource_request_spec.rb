# frozen_string_literal: true

require_relative '../../services/resource_request'

RSpec.describe Services::ResourceRequest do
  describe '.call' do
    subject(:call) { described_class.call(response) }

    context 'when response has no request' do
      let(:response) { 'This is a normal response.' }

      it { expect(call[:has_request]).to be false }
      it { expect(call[:response]).to eq(response) }
    end

    context 'when response has single request' do
      let(:response) { '[[REQUEST:Services::DateTimeInfo.date]]' }

      it { expect(call[:has_request]).to be true }
      it { expect(call[:resource_data]).to be_an(Array) }
      it { expect(call[:resource_data].first[:method_call]).to eq('Services::DateTimeInfo.date') }
      it { expect(call[:resource_data].first[:result]).to match(%r{\d{2}/\d{2}/\d{4}}) }
    end

    context 'when response has multiple requests' do
      let(:response) do
        '[[REQUEST:Services::DateTimeInfo.date]] [[REQUEST:Services::DateTimeInfo.time]]'
      end

      it { expect(call[:has_request]).to be true }
      it { expect(call[:resource_data].size).to eq(2) }
    end

    context 'when request execution fails' do
      let(:response) { '[[REQUEST:Services::NonExistent.method]]' }

      it { expect(call[:has_request]).to be true }
      it { expect(call[:resource_data].first[:result]).to include('[Erro ao executar:') }
    end

    context 'when response has only opening brackets' do
      let(:response) { 'Text with [[REQUEST: but not closed.' }

      it { expect(call[:has_request]).to be false }
    end
  end
end
