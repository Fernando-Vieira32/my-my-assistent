# frozen_string_literal: true

require_relative 'chat_core'

class Main
  def self.call(...) = new(...).call

  def initialize(model: 'qwen2.5:7b', host: 'http://localhost:11434')
    @chat_core = ChatCore.new(model: model, host: host)
  end

  def call
    puts "=== Chat com Ollama (#{@chat_core.model}) ==="
    puts "Digite 'sair' ou 'exit' para encerrar\n\n"

    loop do
      print 'Você: '
      input = gets.chomp

      break if %w[sair exit].include?(input.downcase)

      next if input.strip.empty?

      print 'IA: '
      response = @chat_core.call(input)
      puts response
      puts "\n"
    end

    puts 'Até logo!'
  end
end

if __FILE__ == $PROGRAM_NAME
  Main.call
end
