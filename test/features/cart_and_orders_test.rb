require './test/test_helper'
require_relative '../helpers/restaurant_helper'

class CanMakeAnOrderTest < Capybara::Rails::TestCase

  def setup
    Restaurant.destroy_all
  end

  test "a user can create an cart" do
    restaurant = create_valid_restaurant(:name => "Boyoh's")
    item = Item.create(title: 'Steak!',
                       description: 'Mouthwatering slab',
                       price: '1',
                       restaurant_id: restaurant.id)

    visit restaurant_path(restaurant)

    within "#item_#{item.id}" do
      click_on "Add to Cart"
    end
    within("#current_order") do
      assert_content page, "Mouthwatering slab"
    end
  end

  test "a user can create a cart from the homepage" do
    restaurant = create_valid_restaurant(:name => "Boyoh's")
    item = Item.create(title: 'Steak!',
                       description: 'Mouthwatering slab',
                       price: '1',
                       restaurant_id: restaurant.id)

    visit root_path
    first(:link, "Show").click

    within "#item_#{item.id}" do
      click_on "Add to Cart"
    end
  end

  test "can add multiple items to cart without logging in" do
    restaurant = create_valid_restaurant(:name => "Boyo")
    item1 = Item.create(title: 'Steak Burrito', description: 'Mouthwatering slab',
                        price: '1',
                        restaurant_id: restaurant.id)
    item2 = Item.create(title: 'Breakfast Burrito', description: 'Yummy',
                        price: '1',
                        restaurant_id: restaurant.id)

    visit root_path
    first(:link, "Show").click

    within "#item_#{item1.id}" do
      click_on "Add to Cart"
    end

    within "#item_#{item2.id}" do
      click_on "Add to Cart"
    end

    within("#current_order") do
      assert_content page, "Breakfast Burrito"
      assert_content page, "Steak Burrito"
    end
  end

  test "can add multiple instances of same item to a cart" do
    restaurant = create_valid_restaurant(:name => "Biggy")
    item1 = Item.create(title: 'Steak Burritos', description: 'Mouthwatering slab',
                        price: '1',
                        restaurant_id: restaurant.id)
    item2 = Item.create(title: 'Breakfast Burrito', description: 'Yummy', price: '1')

    visit root_path
    first(:link, "Show").click

    within "#item_#{item1.id}" do
      click_on "Add to Cart"
    end

    within "#item_#{item1.id}" do
      click_on "Add to Cart"
    end

    within("#current_order") do
      assert_content page, "2"
    end
  end

end
