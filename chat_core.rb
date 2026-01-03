# frozen_string_literal: true

require 'rest-client'
require 'json'

class ChatCore
  def self.call(prompt, model: 'qwen2.5:7b', host: 'http://localhost:11434')
    new(model: model, host: host).call(prompt)
  end

  def initialize(model: 'qwen2.5:7b', host: 'http://localhost:11434')
    @model = model
    @host = host
    @url = "#{@host}/api/generate"
  end

  def call(prompt, history: [])
    full_prompt = build_prompt_with_history(prompt, history)

    response = RestClient.post(
      url,
      request_body(full_prompt).to_json,
      content_type: :json,
      accept: :json
    )

    result = JSON.parse(response.body)
    result['response']
  rescue RestClient::ExceptionWithResponse => e
    "Erro: #{e.response.code} - #{e.response.body}"
  rescue StandardError => e
    "Erro na conexão: #{e.message}"
  end

  private

  attr_reader :model, :host, :url

  def request_body(full_prompt)
    {
      model:,
      prompt: full_prompt,
      stream: false
    }
  end

  def build_prompt_with_history(current_prompt, history)
    return current_prompt if history.empty?

    context = history.map do |msg|
      "#{msg[:role]}: #{msg[:content]}"
    end.join("\n")

    "#{context}\nuser: #{current_prompt}\nassistant:"
  end
end
