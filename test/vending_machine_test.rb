require "test_helper"
require 'vending_machine'

class VendingMachineTest < Minitest::Test
  def setup
    @vending_machine = VendingMachine.new
  end
  def test_that_it_initializes
    assert @vending_machine.instance_of? VendingMachine
  end

  def test_deposit_valid_coin
    @vending_machine.insert_coin '50c'
    assert_equal @vending_machine.current_deposit, [0.5]
  end

  def test_deposit_invalid_coin
    @vending_machine.insert_coin '49c'
    assert_equal @vending_machine.current_deposit, []
  end

  def test_successful_purchase_product
    @vending_machine.products = ['Cola']
    @vending_machine.insert_coin '50c'
    @vending_machine.insert_coin '25c'
    @vending_machine.insert_coin '25c'
    assert_equal @vending_machine.current_deposit, [0.5, 0.25, 0.25]
    @vending_machine.purchase('Cola')
    assert_equal @vending_machine.current_deposit, []
    assert_equal @vending_machine.products, []
  end

  def test_out_of_stock
    @vending_machine.products = []
    @vending_machine.insert_coin '50c'
    @vending_machine.insert_coin '25c'
    @vending_machine.insert_coin '25c'
    assert_equal @vending_machine.current_deposit, [0.5, 0.25, 0.25]
    @vending_machine.purchase('Cola')
    assert_equal @vending_machine.current_deposit, []
    assert_equal @vending_machine.products, []
  end

  def test_not_enough_deposit
    @vending_machine.products = ['Cola']
    @vending_machine.insert_coin '50c'
    assert_equal @vending_machine.current_deposit, [0.5]
    @vending_machine.purchase('Cola')
    assert_equal @vending_machine.current_deposit, [0.5]
    assert_equal @vending_machine.products, ['Cola']
  end

  def test_successful_purchase_with_change
    @vending_machine.products = ['Chocolate']
    @vending_machine.insert_coin '$5'
    assert_equal @vending_machine.current_deposit, [5]
    result = @vending_machine.purchase('Chocolate')
    assert_equal @vending_machine.current_deposit, []
    assert_equal @vending_machine.products, []
    assert_equal result[:change], [1, 1, 1, 0.25]
  end
end


