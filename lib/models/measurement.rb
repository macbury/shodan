class Measurement < ActiveRecord::Base
  validates :temperature, presence: true
  validates :humidity, presence: true

  scope :group_by_hours,   -> { group('strftime("%d-%m-%Y %H:00",created_at)') }
  scope :group_by_days,   -> { group('strftime("%d-%m-%Y",created_at)') }
  scope :last_24_hours, -> { where('created_at >= :from_time', from_time: 1.day.ago) }
  scope :last_week, -> { where('created_at >= :from_time', from_time: 30.days.ago) }
  scope :last_30_days, -> { where('created_at >= :from_time', from_time: 30.days.ago) }

  def self.average_temperature_and_humidity_by_days(from_day)
    temperatures       = Measurement.group_by_days.where('created_at >= :from_time', from_time: from_day).average(:temperature).inject({}) do |hash, daily_number|
      hash[Date.parse(daily_number[0])] = daily_number[1]
      hash
    end

    humidities         = Measurement.group_by_days.where('created_at >= :from_time', from_time: from_day).average(:humidity).inject({}) do |hash, daily_number|
      hash[Date.parse(daily_number[0])] = daily_number[1]
      hash
    end

    (from_day.to_date..Date.current).inject([]) do |array, day|
      array << { date: day, temperature: temperatures[day] || 0.0, humidity: humidities[day] || 0.0 }
    end
  end

  def self.average_temperature_and_humidity_by_hour(from_hour)
    temperatures       = Measurement.group_by_hours.where('created_at >= :from_time', from_time: from_hour.at_beginning_of_hour).average(:temperature).inject({}) do |hash, daily_number|
      hash[Time.parse(daily_number[0])] = daily_number[1]
      hash
    end

    humidities         = Measurement.group_by_hours.where('created_at >= :from_time', from_time: from_hour.at_beginning_of_hour).average(:humidity).inject({}) do |hash, daily_number|
      hash[Time.parse(daily_number[0])] = daily_number[1]
      hash
    end

    (from_hour.at_beginning_of_hour.to_i..Time.now.to_i).step(3600).inject([]) do |array, hour|
      hour = Time.at(hour).at_beginning_of_hour
      array << { date: hour, temperature: temperatures[hour] || 0.0, humidity: humidities[hour] || 0.0 }
    end
  end
end
