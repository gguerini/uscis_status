require 'uscis_status/version'
require 'mechanize'
require 'nokogiri'

module USCISStatus

  class USCISWebScraping
    CURRENT_CASE = "Your Current Case Status for"

    def self.check(application_numbers)
      # Check if the parameter is an Array, otherwise create one
      applications = application_numbers.kind_of?(Array) ? application_numbers : application_numbers.split

      statuses = []

      applications.each do |number|
        next if number.nil? or number.empty?

        mechanize = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE}
        page = mechanize.post("https://egov.uscis.gov/cris/Dashboard/CaseStatus.do", { "appReceiptNum" => number })

        # Look for possible errors with this application number
        error = page.search('.//div[@class="errorContainer"]/ul')
        if !error.empty?
          statuses << {number: number, type: 'NONE', status: error.text.strip, description: '', general_description: '', complete: ''}
          next
        end

        # Get the application type and description (eg. Form I130...)
        application_type = capitalize_words(page.search('.//div[@id="caseStatus"]/h3').text.gsub(CURRENT_CASE, ""))

        # Get current application block
        current_application = page.search('.//div[@class="caseStatusInfo"]')

        # Verify if it's in the final step a.k.a 'Complete'
        steps = page.search('.//table[@id="buckets"]/tr/td')
        complete = steps[steps.count - 1]["class"] == "current" ? "true" : "false"

        # Get the Status
        status = current_application.search('.//h4').text.strip

        # Get the Description
        description = current_application.search('.//p[@class="caseStatus"]').text.strip

        # Get the General Description for the Application
        general_description = current_application.search('.//div[@id="bucketDesc"]').text.strip

        statuses << {number: number, type: application_type, status: status, description: description, general_description: general_description, complete: complete}

      end

      return statuses

    end

    private

    def self.capitalize_words(sentence)
      sentence.strip.split(' ').map{ |word| word.capitalize }.join(' ')
    end

  end

  def self.check(application_numbers)

    return USCISWebScraping.check(application_numbers)

  end

end
