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

  def call(prompt)
    request_body = {
      model: @model,
      prompt: prompt,
      stream: false
    }

    response = RestClient.post(
      @url,
      request_body.to_json,
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

  attr_reader :model, :host, :url
end
