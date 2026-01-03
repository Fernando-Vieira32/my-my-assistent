# frozen_string_literal: true

require_relative '../chat_core'
require 'webmock/rspec'

RSpec.describe ChatCore do
  let(:model) { 'qwen2.5:7b' }
  let(:host) { 'http://localhost:11434' }
  let(:chat_core) { described_class.new(model: model, host: host) }

  describe '#initialize' do
    it { expect(chat_core.model).to eq(model) }
    it { expect(chat_core.host).to eq(host) }
    it { expect(chat_core.url).to eq("#{host}/api/generate") }
  end

  describe '#call' do
    let(:prompt) { 'Olá, tudo bem?' }
    let(:response_body) do
      { 'response' => 'Olá! Estou bem, obrigado.' }.to_json
    end

    before do
      stub_request(:post, "#{host}/api/generate")
        .with(
          body: hash_including('prompt' => prompt),
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: response_body)
    end

    it 'returns the AI response' do
      result = chat_core.call(prompt)
      expect(result).to eq('Olá! Estou bem, obrigado.')
    end

    context 'with history' do
      let(:history) do
        [
          { role: 'user', content: 'Meu nome é Fernando' },
          { role: 'assistant', content: 'Olá Fernando!' }
        ]
      end

      before do
        stub_request(:post, "#{host}/api/generate")
          .with(
            body: hash_including('prompt' => /Fernando/),
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 200, body: response_body)
      end

      it 'includes history in the prompt' do
        result = chat_core.call(prompt, history: history)
        expect(result).to eq('Olá! Estou bem, obrigado.')
      end
    end

    context 'when request fails' do
      before do
        stub_request(:post, "#{host}/api/generate")
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'returns error message' do
        result = chat_core.call(prompt)
        expect(result).to include('Erro: 500')
      end
    end
  end

  describe '.call' do
    let(:prompt) { 'Teste' }
    let(:response_body) { { 'response' => 'Resposta' }.to_json }

    before do
      stub_request(:post, "#{host}/api/generate")
        .to_return(status: 200, body: response_body)
    end

    it 'creates instance and calls #call' do
      result = described_class.call(prompt, model: model, host: host)
      expect(result).to eq('Resposta')
    end
  end
end
