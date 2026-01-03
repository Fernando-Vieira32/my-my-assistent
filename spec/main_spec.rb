# frozen_string_literal: true

require_relative '../main'

RSpec.describe Main do
  let(:main) { described_class.new }

  describe '#initialize' do
    it 'creates a ChatCore instance' do
      expect(main.chat_core).to be_a(ChatCore)
    end

    it 'initializes empty history' do
      expect(main.history).to eq([])
    end
  end

  describe '#add_to_history' do
    it 'adds messages to history' do
      main.send(:add_to_history, 'user', 'Olá')
      main.send(:add_to_history, 'assistant', 'Oi!')

      expect(main.history.size).to eq(2)
      expect(main.history.first).to eq({ role: 'user', content: 'Olá' })
      expect(main.history.last).to eq({ role: 'assistant', content: 'Oi!' })
    end
  end
end
