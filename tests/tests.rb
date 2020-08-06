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

assertion_counter = 0
if motors_list['Used cars'].any?{|s| s.include?('Cars for sale(0)')} == true
  puts "#{assertion_counter+=1}. Cars for sale are 0".red
else
  puts "#{assertion_counter+=1}. Cars for sale are non zero, i.e. #{motors_list['Used cars'][0]}".green
end

@home_page.open_category('used_cars_category')
car_makes = @home_page.get_car_makes

if car_makes.any?{|s| s.include?('Kia')} == true
  puts "#{assertion_counter+=1}. Kia make exists".green
else
  puts "#{assertion_counter+=1}. Kia does not exist in the list: #{car_makes}".red
end

@home_page.perform_search('Audi')
@home_page.open_search_result
key_details = @home_page.get_key_details

details = ["Number plate", "Kilometres", "Body", "Fuel type", "Engine size", "Transmission", "History", "Registration expires","WoF expires"]
details.each do |key|
  if key_details.keys.include?(key) == true
    puts "#{assertion_counter+=1}. #{key} exists".green
  else
    puts "#{assertion_counter+=1}. #{key} does not exist in the list: #{key_details}".red
  end
end
