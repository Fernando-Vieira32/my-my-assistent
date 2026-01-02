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

    loop do
      print 'Você: '
      input = gets.chomp

      break if %w[sair exit].include?(input.downcase)

      next if input.strip.empty?

      print 'my-assistent: '
      response = chat_core.call(input, history: )
      puts response
      puts "\n"

      add_to_history('user', input)
      add_to_history('assistant', response)
    end

    puts 'Até logo!'
  end

  attr_reader :chat_core, :history

  private

  def add_to_history(role, content)
    @history << { role: role, content: content }
  end
end

if __FILE__ == $PROGRAM_NAME
  Main.call
end
