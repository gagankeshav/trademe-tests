$LOAD_PATH.unshift File.expand_path('../../', __FILE__)

require 'helpers'

@driver = Selenium::WebDriver.for :chrome
@driver.manage.window.maximize

trademe_webpage = 'https://www.tmsandbox.co.nz/'
@driver.get(trademe_webpage)

Selenium::WebDriver::Wait.new(timeout: 10)

@home_page = HomePageObjects.new(@driver)
@home_page.select_category('motors_category')
motors_list = @home_page.get_lists_in_categories('motors_cat_list')

puts "Used cars are: #{motors_list['Used cars']}"

assert_not_include motors_list['Used cars'], "Cars for sale(0)", "Used Cars for sale are 0"

@home_page.open_category('used_cars_category')
car_makes = @home_page.get_car_makes

assert_include car_makes, "Kia(0)", "Kia was not found"

@home_page.perform_search('Audi')
@home_page.open_search_result
key_details = @home_page.get_key_details

assert_include key_details, "Number plate", "Number plate was not found"
assert_include key_details, "Kilometres", "Kilometers was not found"
assert_include key_details, "Body", "Body was not found"
assert_include key_details, "Fuel type", "Fuel type was not found"
assert_include key_details, "Engine size", "Engine size was not found"
assert_include key_details, "Transmission", "Transmission was not found"
assert_include key_details, "History", "History was not found"
assert_include key_details, "Registration expires", "Registration expires was not found"
assert_include key_details, "WoF expires", "WoF was not found"
