require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "Should have a positive price" do
    product = products(:one)
    product.price = -1
    assert_not product.valid?
  end

  test "should filter products by title" do
    assert_equal 2, Product.filter_by_title('tv').count
  end

  test 'should filter products by title and sort them' do
    assert_equal [products(:another_tv), products(:one)], Product.filter_by_title('tv').sort
  end

  test 'should filter products by price and sort them' do
    assert_equal [products(:two), products(:one)], Product.above_or_equal_to_price(200).sort
  end
end
