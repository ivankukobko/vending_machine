require "test_helper"
require 'coins_storage'

class CoinsStorageTest < Minitest::Test
  def setup
    @instance = CoinsStorage
    @instance.init
  end

  def test_that_it_is_singleton
    refute @instance.instance_of? CoinsStorage
  end

  def test_deposit_valid_coin
    @instance.deposit! '50c'
    assert_equal @instance.deposit, [0.5]
  end

  def test_deposit_invalid_coin
    assert_raises CoinsStorage::InvalidCoinError do
      @instance.deposit! '49c'
    end
    assert_equal @instance.deposit, []
  end
end
