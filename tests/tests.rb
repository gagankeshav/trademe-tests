# Initial configuration
$LOAD_PATH.unshift File.expand_path('../../', __FILE__)
require 'helpers'

# Instantiating webdriver instance for Chrome browser
@driver = Selenium::WebDriver.for :chrome
@driver.manage.window.maximize

# Loading the configuration from config.yml file
@config = YAML.load_file(File.expand_path('../../config/config.yml', __FILE__))

# Opening the trademe sandbox website and instantiating the object for Trademe Home Page library
@driver.get(@config['trademe_sandbox_webaddress'])
@home_page = HomePageObjects.new(@driver)

# Counter to count the number of tests and label them in the output
test_counter = 0

#Tests begin here
#-----------------------------------------------------------------------------------------------------------------------#
# Test#1: Validate that Used Cars listing is not zero via UI
puts "#{test_counter+=1}. Validate that Used Cars listing is not zero via UI"
@home_page.select_category('motors_category')
motors_list = @home_page.get_lists_in_categories('motors_cat_list')
if motors_list['Used cars'].any?{|s| s.include?('Cars for sale(0)')}
  puts "  Cars for sale are 0".red
else
  puts "  Cars for sale are non zero, i.e. #{motors_list['Used cars'][0]}".green
end
#-----------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------#
# Test#2: Validate that Used Cars listing is not zero via API
puts "#{test_counter+=1}. Validate that Used Cars listing is not zero via API"
response = RestClient.get(@config['used_cars_api'],
                          headers={'Authorization' => "OAuth oauth_consumer_key=\"#{@config['oauth_consumer_key']}\", oauth_signature_method='PLAINTEXT', oauth_signature=\"#{@config['oauth_signature']}\""})
response_body = JSON.parse(response.body)
if response.code == 200 && response_body.fetch('TotalCount') == 0
  puts "  Cars for sale are 0".red
else
  puts "  Cars for sale are non zero, i.e. #{response_body.fetch('TotalCount')}".green
end
#-----------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------#
# Test#3: Validate that the make Kia exists in the Used Cars category via UI
puts "#{test_counter+=1}. Validate that the make Kia exists in the Used Cars category via UI"
@home_page.open_category('used_cars_category')
car_makes = @home_page.get_car_makes
if car_makes.any?{|s| s.include?('Kia')}
  puts "  Kia make exists".green
else
  puts "  Kia does not exist in the list: #{car_makes}".red
end
#-----------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------#
# Test#4: Validate that the make Kia exists in the Used Cars category via API
puts "#{test_counter+=1}. Validate that the make Kia exists in the Used Cars category via API"
response = RestClient.get(@config['used_car_categories_api'])
response_body = JSON.parse(response.body)
if response.code == 200
  puts "  Response code is expected: #{response.code}".green
  response_body.fetch('Subcategories').each_with_index do |category, index|
    if category.fetch('Name') == 'Kia'
      puts "  Kia exists as a make".green
      break
    elsif category.fetch('Name') != 'Kia' && index == response_body.fetch('Subcategories').length-1
      puts "  Kia does not exist as a make in: #{response_body.fetch('Subcategories')}".red
    end
  end
else
  puts "  Response code is not expected: #{response.code}".red
end
#-----------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------#
# Test#5: Validate that Number plate, Kilometres, Body, Fuel type, Engine size, Transmission, History, Registration expires,WoF expires exist in the key details via UI
puts "#{test_counter+=1}. Validate that Number plate, Kilometres, Body, Fuel type, Engine size, Transmission, History, Registration expires,WoF expires exist in the key details via UI"
@home_page.perform_search('Audi')
@home_page.open_search_result
key_details = @home_page.get_key_details
@config['ui_keys'].each do |key|
  if key_details.keys.include?(key)
    puts "  #{key} exists".green
  else
    puts "  #{key} does not exist in the list: #{key_details}".red
  end
end
#-----------------------------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------#
# Test#6: Validate that Number plate, Kilometres, Body, Fuel type, Engine size, Transmission, History, Registration expires, WoF expires exist in the key details via API
puts "#{test_counter+=1}. Validate that Number plate, Kilometres, Body, Fuel type, Engine size, Transmission, History, Registration expires, WoF expires exist in the key details via API"
response = RestClient.get(@config['used_cars_api'],
                          headers={'Authorization' => "OAuth oauth_consumer_key=\"#{@config['oauth_consumer_key']}\", oauth_signature_method='PLAINTEXT', oauth_signature=\"#{@config['oauth_signature']}\""})
response_body = JSON.parse(response.body)
@config['api_keys'].each do |key|
  if response_body.fetch('List')[0].keys.include?(key)
    puts "  #{key} exists".green
  else
    puts "  #{key} does not exist in the list: #{response_body}".red
  end
end
#-----------------------------------------------------------------------------------------------------------------------#