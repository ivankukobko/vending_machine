class VendingMachine
  attr_accessor :coins, :products, :current_deposit, :change

  COIN_TYPES = {
    0.25 => '25c',
    0.5  => '50c',
    1    => '$1',
    2    => '$2',
    5    => '$5'
  }

  PRODUCT_PRICES = {
    'Cola'      => 1,
    'Chips'     => 0.5,
    'Chocolate' => 1.75
  }

  def initialize
    @products = [
      'Cola', 'Cola', 'Cola',
      'Chips', 'Chips',
      'Chocolate'
    ]

    @coins = [
      0.25, 0.25,
      0.5, 0.5, 0.5,
      1, 1, 1, 1,
      5, 5
    ]

    @current_deposit = []
    puts "\nWelcome!\nSelect product"
  end

  def insert_coin coin
    unless COIN_TYPES.has_value?(coin)
      puts('Wrong coin!')
      return
    end

    @current_deposit << COIN_TYPES.key(coin)
    puts "Added: #{COIN_TYPES.key(coin)}"
    puts "Deposit: #{@current_deposit.reduce(&:+)}"
  end

  def purchase product
    puts 'Wrong product!' && return unless PRODUCT_PRICES.keys.include? product
    puts 'Out of stock!' && return_deposit && return unless @products.include? product
    puts 'Not enough deposit!' && return if PRODUCT_PRICES[product] > @current_deposit.reduce(0, :+)

    update_coins

    result = {
      product: return_product(product),
      change: return_change(product)
    }

    finalize

    puts "Here's your #{result[:product]}"
    puts "Here\'s your change: #{result[:change].join(', ')}" if result[:change].reduce(0, :+) > 0

    result
  end

  def finalize
    @current_deposit = []
    @change = []
  end

  def return_change product
    @change = []
    price = PRODUCT_PRICES.fetch(product)
    deposit = @current_deposit.reduce(:+)
    return @change if deposit == price

    extra = deposit - price

    @coins.sort.reverse.each do |coin|
      next if coin > price
      next if @change.reduce(0, :+) + coin > extra
      @change << coin
    end

    @change
  end

  def update_coins
    @coins = @coins + @current_deposit
  end

  def return_deposit
    puts "Here's your coins back: #{@current_deposit.join(', ')}"
    @current_deposit = []
  end

  def return_product product
    @products.delete_at(@products.index(product))
  end
end
