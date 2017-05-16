require 'bundler'
require 'open-uri'

Bundler.require

Dotenv.load

USER = ENV.fetch('NAME')
SPEAK= ENV.fetch('SPEAK')
TEMPERATURE = ENV.fetch('TEMPERATURE')

DOB = Time.new(1985, 01, 10)
DOD = DOB.to_i + (80 * 365 * 24 * 60 * 60)

module Magnus
  class Voice
    class << self
      def speak string
        ESpeak::Speech.new(string, voice: 'en-us').speak
      end
    end
  end

  class MorningRitual
    class << self
      def run!
        sentences.each_with_index do |sentence, i|
          puts "#{i}.) #{sentence}"
          if SPEAK == "TRUE"
            Voice.speak sentence
          end
        end
      end

      private

      def seconds_in_a_day
        24 * 60 * 60
      end

      def days_alive
        (Time.now - DOB).to_i / seconds_in_a_day
      end

      def days_left
        (DOD - Time.now.to_i) / seconds_in_a_day
      end

      def percent_life_remaining
        '%.2f' % (100 * days_alive / (days_alive + days_left).to_f)
      end

      def weather
        begin
          remote_ip = open('http://whatismyip.akamai.com').read
          location = GeoIP.new('GeoLiteCity.dat').city(remote_ip).to_hash[:city_name]
        rescue
          location = ENV.fetch('LOCATION')
        end

        if TEMPERATURE.downcase == "celsius"
          weather =  Weather.
            lookup_by_location(location, Weather::Units::CELSIUS)
          condition = "#{weather.condition.text} @ #{weather.condition.temp}°#{weather.units.temperature}"
        else
          weather = Weather.
            lookup_by_location(location, Weather::Units::FAHRENHEIT)
            condition = "#{weather.condition.text} @ #{weather.condition.temp}°#{weather.units.temperature}"
        end
      end

      def sentences
        [
          "Good morning #{USER}.",
          "Welcome to day #{days_alive}. You have #{days_left} days remaining.",
          "You have reached #{percent_life_remaining} percent of your expected life span.",
          "The weather today is going to be #{weather}.",
        ]
      end
    end
  end

  class Main
    def run!
      MorningRitual.run!
    end
  end
end

Magnus::Main.new.run!
