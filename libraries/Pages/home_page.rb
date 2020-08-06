class HomePageObjects

  def initialize(driver)
    @driver = driver
  end

  # UI Elements in the format of how and what as expected by Selenium
  ELEMENTS = {'motors_category' => [:id, 'SearchTabs1_MotorsLink'],
              'motors_cat_list' => [:xpath, "//*[@class='motors-landing-list']/li"],
              'used_cars_category' => [:xpath, "//*[contains(@href,'/motors/used-cars') and text() = 'Cars for sale']"],
              'car_makes' => [:id, 'makes'],
              'search_results' => [:class, 'tmm-search-card-list-view'],
              'search_bar' => [:id, 'searchString'],
              'search_button' => [:class, 'icon-search-large'],
              'save_search_button' => [:class, 'tmicon-heart-add'],
              'listing_title' => [:id, 'ListingDateBox_TitleText'],
              'key_details' => [:id, 'AttributesDisplay_attributesSection'],
              'key_labels' => [:class, 'key-details-attribute-label'],
              'key_values' => [:class, 'key-details-attribute-value']}

  def select_category(category_name)
    wait_for_element(category_name)
    find_element(category_name).click
  end

  def get_lists_in_categories(sub_category_name)
    wait_for_element(sub_category_name)
    str = []
    find_elements(sub_category_name).each do |ele|
      str.push(ele.text.split(/\n/))
    end
    hsh = {}
    str.each do |list|
      hsh[list.shift] = list
    end
    hsh
  end

  def open_category(category_name)
    wait_for_element(category_name)
    find_element(category_name).click
  end

  def get_car_makes
    wait_for_element('car_makes')
    car_makes = []
    find_element('car_makes').text.split(/(?<=\)\s)/).each do |make|
      car_makes.push(make.gsub(/\n/, '').gsub(/\) /, ')'))
    end
    car_makes
  end

  def perform_search(query)
    wait_for_element('search_bar')
    find_element('search_bar').send_keys query
    wait_for_element('search_button')
    find_element('search_button').click
    wait_for_element('save_search_button')
  end

  def open_search_result
    wait_for_element('search_results')
    find_element('search_results').click
    wait_for_element('listing_title')
  end

  def get_key_details
    wait_for_element('key_labels')
    labels = []
    find_elements('key_labels').each do |label|
      labels.push(label.text)
    end

    wait_for_element('key_values')
    values = []
    find_elements('key_values').each do |value|
      values.push(value.text)
    end

    labels.zip(values).to_h
  end

  def wait_for_element(element)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { find_element(element) }
  end

  def find_element(element)
    @driver.find_element(ELEMENTS[element][0], ELEMENTS[element][1])
  end

  def find_elements(element)
    @driver.find_elements(ELEMENTS[element][0], ELEMENTS[element][1])
  end
end