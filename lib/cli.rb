require './lib/vending_machine'

class Cli
  COMMANDS = [
    'q',
    'r',
    'c',
    'p'
  ]

  def initialize
    @vending_machine = VendingMachine.new

    main_loop
  end

  def main_loop
    reset_screen
    loop do
      welcome_message
      @input = gets.chomp

      if is_command?(@input.downcase)
        case @input.downcase
        when 'q' then exit
        when 'r' then @vending_machine.reset
        when 'c' then expect_input(:insert_coin) { CoinsStorage.print_available }
        when 'p' then expect_input(:purchase) { ProdutsStorage.print_available }
        end
        # reset_screen
      end
    rescue StandardError => e
      puts e.message
    end
  end

  def welcome_message
    puts "\nWelcome!\n"
    puts "q - exit | r - reset | c - insert coin | p - purchase product"
    puts "Deposit: #{CoinsStorage.deposit_amount}"
    print '> '
  end

  def reset_screen
    system('clear') || system('cls')
  end

  def expect_input method
    yield if block_given?
    print '> '
    @vending_machine.send(method, gets.chomp)
  end

  def is_command? value
    COMMANDS.include?(value)
  end
end

Cli.new
