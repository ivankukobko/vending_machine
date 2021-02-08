require "test_helper"
require 'vending_machine'

class VendingMachineTest < Minitest::Test
  def setup
    @vending_machine = VendingMachine.new
  end
  def test_that_it_initializes
    assert @vending_machine.instance_of? VendingMachine
  end

  def test_successful_purchase_product
    ProdutsStorage.init ['Cola']
    @vending_machine.insert_coin '50c'
    @vending_machine.insert_coin '25c'
    @vending_machine.insert_coin '25c'
    assert_equal CoinsStorage.deposit, [0.5, 0.25, 0.25]
    @vending_machine.purchase('Cola')
    assert_equal CoinsStorage.deposit, []
    assert_equal ProdutsStorage.products, []
  end

  def test_out_of_stock
    ProdutsStorage.init ['Cola']
    @vending_machine.insert_coin '50c'
    @vending_machine.insert_coin '25c'
    @vending_machine.insert_coin '25c'
    assert_equal CoinsStorage.deposit, [0.5, 0.25, 0.25]
    @vending_machine.purchase('Cola')
    assert_equal CoinsStorage.deposit, []
    assert_equal ProdutsStorage.products, []
  end

  def test_not_enough_deposit
    ProdutsStorage.init ['Cola']
    @vending_machine.insert_coin '50c'
    assert_equal CoinsStorage.deposit, [0.5]
    @vending_machine.purchase('Cola')
    assert_equal CoinsStorage.deposit, [0.5]
    assert_equal ProdutsStorage.products, ['Cola']
  end

  def test_successful_purchase_with_change
    ProdutsStorage.init ['Chocolate']
    @vending_machine.insert_coin '$5'
    assert_equal CoinsStorage.deposit, [5]
    result = @vending_machine.purchase('Chocolate')
    assert_equal CoinsStorage.deposit, []
    assert_equal ProdutsStorage.products, []
    assert_equal result[:change], [1, 1, 1, 0.25]
  end
end


