require 'bundler'
Bundler.require

USER = 'Audy'
DOB = Time.new(1985, 12, 11)
DOD = DOB.to_i + (77 * 365 * 24 * 60 * 60)

module Magnus
  class Voice
    class << self
      def speak string
        ESpeak::Speech.new(string).speak
      end
    end
  end

  class MorningRitual
    class << self
      def run!
        sentences.each do |sentence|
          Voice.speak sentence
        end
      end

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
        "cloudy"
      end

      def sentences
        [
          "good morning #{USER}",
          "Welcome to day number #{days_alive}",
          "You have #{days_left} days remaining",
          "Therefore, you have completed #{percent_life_remaining} percent of your life",
          "Today is going to be #{weather}",
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
