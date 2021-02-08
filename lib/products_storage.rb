class ProdutsStorage
  PRODUCT_PRICES = {
    'Cola'      => 1,
    'Chips'     => 0.5,
    'Chocolate' => 1.75
  }

  DEFAULT_STOCK = [ 'Cola', 'Cola', 'Cola',
                    'Chips', 'Chips',
                    'Chocolate' ]

  class << self
    def init(products = DEFAULT_STOCK)
      @products = products
    end

    def products
      @products || []
    end

    def valid? product
      PRODUCT_PRICES.keys.include? product
    end

    def available? product
      @products.include? product
    end

    def price product
      PRODUCT_PRICES.fetch(product)
    end

    def issue product
      @products.delete_at(@products.index(product)) if available?(product)
    end

    def print_available
      PRODUCT_PRICES.each do |k, v|
        puts "#{k} - $#{v}"
      end
    end
  end
end
