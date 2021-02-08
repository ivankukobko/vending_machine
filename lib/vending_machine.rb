require './lib/products_storage'
require './lib/coins_storage'

class VendingMachine
  attr_accessor :change

  def initialize
    reset
  end

  def reset
    ProdutsStorage.init
    CoinsStorage.init
  end

  def insert_coin coin
    CoinsStorage.deposit! coin
    puts "Added: #{CoinsStorage::COIN_TYPES.key(coin)}"
    puts "Deposit: #{CoinsStorage.deposit_amount}"
  end

  def purchase product
    puts "Trying to purchase #{product}"
    raise 'Wrong product!' && return unless ProdutsStorage.valid?(product)
    raise 'Out of stock!' && return_deposit && return unless ProdutsStorage.valid?(product)
    raise 'Not enough deposit!' && return if CoinsStorage.deposit_amount < ProdutsStorage.price(product)

    CoinsStorage.consume_deposit!

    result = {
      product: ProdutsStorage.issue(product),
      change: CoinsStorage.return_change(ProdutsStorage.price(product))
    }

    CoinsStorage.finalize!

    puts "Here's your #{result[:product]}"
    puts "Here\'s your change: #{result[:change].join(', ')}" if result[:change].reduce(0, :+) > 0

    result
  end

  def products
    ProdutsStorage.products
  end
end
