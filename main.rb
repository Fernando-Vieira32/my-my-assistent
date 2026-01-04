# frozen_string_literal: true

require_relative 'chat_core'
require_relative 'services/precesse_response'

class Main
  def self.call(...) = new(...).call

  def initialize(model: 'resource_manager_1.0', host: 'http://localhost:11434')
    @chat_core = ChatCore.new(model: model, host: host)
    @history = []
  end

  def call
    puts "Digite 'sair' ou 'exit' para encerrar\n\n"
    chat_loop
    puts 'Até logo!'
  end

  attr_reader :chat_core, :history

  private

  def chat_loop
    loop do
      input = read_user_input
      break if exit_command?(input)
      next if input.strip.empty?

      process_message(input)
    end
  end

  def read_user_input
    print 'Você: '
    gets.chomp
  end

  def exit_command?(input)
    %w[sair exit].include?(input.downcase)
  end

  def process_message(input)
    raw_response = get_ai_response(input)
    processed_response = process_ai_response(raw_response)
    display_response(processed_response)
    save_conversation(input, processed_response)
  end

  def get_ai_response(input)
    chat_core.call(input, history:)
  end

  def process_ai_response(response)
    Services::PrecesseResponse.call(response)
  end

  def display_response(response)
    print 'my-assistent: '
    puts response
    puts "\n"
  end

  def save_conversation(input, response)
    add_to_history('user', input)
    add_to_history('assistant', response)
  end

  def add_to_history(role, content)
    @history << { role: role, content: content }
  end
end

Main.call if __FILE__ == $PROGRAM_NAME
