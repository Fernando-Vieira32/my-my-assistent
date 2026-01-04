# frozen_string_literal: true

require_relative '../../services/precesse_response'

RSpec.describe Services::PrecesseResponse do
  describe '.call' do
    subject(:call) { described_class.call(response) }

    context 'when response has no placeholders' do
      let(:response) { 'This is a response without placeholders.' }

      it { expect(call).to eq(response) }
    end

    context 'when response has single placeholder' do
      context 'with date placeholder' do
        let(:response) { 'Today is {{Services::DateTimeInfo.date}}.' }

        it {
          expect(call).to eq("Today is #{Date.today.strftime('%d/%m/%Y')}.")
        }
      end

      context 'with time placeholder' do
        let(:response) { 'Now it is {{Services::DateTimeInfo.time}}.' }

        it { expect(call).to eq("Now it is #{Time.now.strftime('%H:%M:%S')}.") }
      end
    end

    context 'when response has multiple placeholders' do
      let(:response) do
        'Today is {{Services::DateTimeInfo.date}} and now it is {{Services::DateTimeInfo.time}}.'
      end
      let(:expected) do
        date = Date.today.strftime('%d/%m/%Y')
        time = Time.now.strftime('%H:%M:%S')
        "Today is #{date} and now it is #{time}."
      end

      it { expect(call).to eq(expected) }
    end

    context 'when placeholder execution fails' do
      let(:response) { 'Result: {{Services::NonExistent.method}}.' }

      it { expect(call).to eq('Result: [Erro ao executar: Services::NonExistent.method].') }
    end

    context 'when response has only opening brackets' do
      let(:response) { 'Text with {{ but not closed.' }

      it { expect(call).to eq(response) }
    end

    context 'when response has only closing brackets' do
      let(:response) { 'Text with }} but not opened.' }

      it { expect(call).to eq(response) }
    end
  end
end
