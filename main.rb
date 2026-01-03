# frozen_string_literal: true

require_relative 'chat_core'

class Main
  def self.call(...) = new(...).call

  def initialize(model: 'qwen2.5:7b', host: 'http://localhost:11434')
    @chat_core = ChatCore.new(model: model, host: host)
    @history = []
  end

  def call
    puts "Digite 'sair' ou 'exit' para encerrar\n\n"
    chat_loop
    show_goodbye
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
    response = get_ai_response(input)
    display_response(response)
    save_conversation(input, response)
  end

  def get_ai_response(input)
    chat_core.call(input, history:)
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
