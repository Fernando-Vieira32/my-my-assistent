# frozen_string_literal: true

require_relative 'date_time_info'
module Services
  class PrecesseResponse
    def self.call(...) = new(...).call

    def initialize(response)
      @response = response
    end

    def call
      return response unless response.include?('{{') && response.include?('}}')

      process_placeholders
    end

    private

    attr_reader :response

    def process_placeholders
      processed = response.dup
      placeholders = response.scan(/\{\{(.+?)\}\}/)

      placeholders.each do |placeholder|
        method_call = placeholder.first.strip
        result = execute_method(method_call)
        processed.gsub!("{{#{placeholder.first}}}", result.to_s)
      end

      processed
    end

    def execute_method(method_call)
      eval(method_call)
    rescue StandardError
      "[Erro ao executar: #{method_call}]"
    end
  end
end
