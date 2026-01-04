# frozen_string_literal: true

require_relative 'date_time_info'

module Services
  class ResourceRequest
    def self.call(...) = new(...).call

    def initialize(response)
      @response = response
    end

    def call
      return { has_request: false, response: response } unless request?

      { has_request: true, resource_data: extract_resource_data }
    end

    private

    attr_reader :response

    def request?
      response.include?('[[REQUEST:') && response.include?(']]')
    end

    def extract_resource_data
      requests = response.scan(/\[\[REQUEST:(.+?)\]\]/)
      requests.map do |request|
        method_call = request.first.strip
        { method_call: method_call, result: execute_method(method_call) }
      end
    end

    def execute_method(method_call)
      eval(method_call)
    rescue StandardError => e
      "[Erro ao executar: #{method_call} - #{e.message}]"
    end
  end
end
