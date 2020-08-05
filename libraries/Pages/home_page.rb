class HomePageObjects

  def initialize(driver)
    @driver = driver
  end

  @@elements = {'motors_category' => [:id, 'SearchTabs1_MotorsLink'],
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
    how, what = @@elements[category_name][0], @@elements[category_name][1]
    @driver.find_element(how, what).click
  end

  def get_lists_in_categories(sub_category_name)
    wait_for_element(sub_category_name)
    how, what = @@elements[sub_category_name][0], @@elements[sub_category_name][1]
    str = []
    @driver.find_elements(how, what).each do |ele|
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
    how, what = @@elements[category_name][0], @@elements[category_name][1]
    @driver.find_element(how, what).click
  end

  def get_car_makes
    wait_for_element('car_makes')
    how, what = @@elements['car_makes'][0], @@elements['car_makes'][1]
    car_makes = []
    @driver.find_element(how, what).text.split(/(?<=\)\s)/).each do |make|
      car_makes.push(make.gsub(/\n/, '').gsub(/\) /, ')'))
    end
    car_makes
  end

  def perform_search(query)
    wait_for_element('search_bar')
    how, what = @@elements['search_bar'][0], @@elements['search_bar'][1]
    @driver.find_element(how, what).send_keys query
    wait_for_element('search_button')
    how, what = @@elements['search_button'][0], @@elements['search_button'][1]
    @driver.find_element(how, what).click
    wait_for_element('save_search_button')
  end

  def open_search_result
    wait_for_element('search_results')
    how, what = @@elements['search_results'][0], @@elements['search_results'][1]
    @driver.find_element(how, what).click
    wait_for_element('listing_title')
  end

  def get_key_details
    wait_for_element('key_labels')
    how, what = @@elements['key_labels'][0], @@elements['key_labels'][1]
    labels = []
    @driver.find_elements(how, what).each do |label|
      labels.push(label.text)
    end

    wait_for_element('key_values')
    how, what = @@elements['key_values'][0], @@elements['key_values'][1]
    values = []
    @driver.find_elements(how, what).each do |value|
      values.push(value.text)
    end

    labels.zip(values).to_h
  end

  def wait_for_element(element)
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    how, what = @@elements[element][0], @@elements[element][1]
    wait.until { @driver.find_element(how, what) }
  end
end