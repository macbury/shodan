# This class is used for analizing what devices are in range of humidifier. If there is none then humidifier should not work
class Device < ActiveRecord::Base
  validates :uid, presence: true

  after_create :ping!

  scope :in_range, -> { where('next_timeout >= ?', Time.now) }

  # Update last ping
  def ping!
    self.next_timeout = 30.minutes.from_now
    puts "[Device] Next ping in #{self.next_timeout}"
    self.save
  end
end
