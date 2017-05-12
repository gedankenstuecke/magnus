require 'bundler'
Bundler.require

Dotenv.load

USER = 'Audy'
DOB = Time.new(1985, 12, 11)
DOD = DOB.to_i + (77 * 365 * 24 * 60 * 60)

DARKSKY = ENV.fetch('DARKSKY')
POSTAL_CODE = ENV.fetch('POSTAL_CODE')

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
          Voice.speak sentence
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
        Weather.
          lookup_by_location('San Francisco, CA', Weather::Units::FAHRENHEIT).
          condition.
          text
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
