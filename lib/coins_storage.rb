class CoinsStorage

  COIN_TYPES = {
    0.25 => '25c',
    0.5  => '50c',
    1    => '$1',
    2    => '$2',
    5    => '$5'
  }

  DEFAULT_STOCK = [
    0.25, 0.25,
    0.5, 0.5, 0.5,
    1, 1, 1, 1,
    5, 5
  ]

  class InvalidCoinError < StandardError; end


  class << self
    def init(coins = DEFAULT_STOCK)
      @coins = coins
      @deposit = []
    end

    def coins
      @coins || []
    end

    def deposit! coin
      unless COIN_TYPES.has_value?(coin)
        raise InvalidCoinError, 'Wrong coin!'
        return
      end

      @deposit << COIN_TYPES.key(coin)
    end

    def deposit
      @deposit || []
    end

    def deposit_amount
      @deposit.reduce(0, :+)
    end

    def consume_deposit!
      @coins = @coins + @deposit
    end

    def finalize!
      @deposit = []
      @change = []
    end

    def return_change price
      @change = []
      deposit_amount = @deposit.reduce(:+)
      return @change if deposit == price

      extra = deposit_amount - price

      @coins.sort.reverse.each do |coin|
        next if coin > price
        next if @change.reduce(0, :+) + coin > extra
        @change << coin
      end

      @change
    end

    def return_deposit
      puts "Here's your coins back: #{@deposit.join(', ')}"
      @deposit = []
    end

    def print_available
      COIN_TYPES.each do |k, v|
        puts "#{v} - #{k}"
      end
    end
  end
end

