# USCIS Status Checker Gem

This gem makes it easy to check multiple application statuses from USCIS website, without visiting the USCIS website.

## Important

This is not the official way to check the status of a USCIS application and it's not endorsed by USCIS either.
It's just a scraper of the USCIS website and it may break at any time if the website is updated. If it should happen, feel free to report me or to [fix](#contributing) the problem.

## New on version 0.3.0

Now it checks if the Application is in the last status (step). If it's in the last status, the Application is complete.

## Live Example

Take a look at the 'Multiple USCIS Status Checker' website that uses this gem:

[http://uscisstatus.herokuapp.com](http://uscisstatus.herokuapp.com)

## Installation

Add this line to your application's Gemfile:

    gem 'uscis_status'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install uscis_status

## Usage

    require 'uscis_status'

    # Array with multiple application numbers
    app_numbers = %w(MSC0123456789 MSC9876543210 MSC0213547698)
    # Or single application number
    app_numbers = "MSC0123456789"

    statuses = USCISStatus.check(app_numbers)
    statuses.each do |s|
      puts "The status of your application number #{s[:number]} is: #{s[:status]}."
    end

    #The method 'check' returns an array with the following hash:
    {
                   :number => "MSC0123456789",
                     :type => "Form I485, Application To Register Permanent Residence Or To Adjust Status",
                   :status => "Acceptance",
              :description => "On March 20, 2013, your fingerprint fee was accepted and we have mailed...",
      :general_description => "During the acceptance step USCIS reviews newly received applications and...",
                 :complete => "false"
    }


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
