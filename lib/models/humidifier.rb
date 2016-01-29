class Humidifier < ActiveRecord::Base
  STATE_CHECK_ENV    = 'check_env'
  STATE_SLEEP        = 'sleep'
  STATE_RUNNING      = 'running'
  STATE_OUT_OF_WATER = 'out_of_water'
  STATE_WEEKEND      = 'weekend'

  def tick!
    run(state)
    save
  end

  def next_tick_seconds_left
    if next_tick_at && !can_next_tick?
      next_tick_at.to_i - Time.now.to_i
    else
      0
    end
  end

  def refill!
    self.shot_left = self.max_shots
    change_state(STATE_CHECK_ENV)
    save
  end

  def weekend!
    change_state(STATE_WEEKEND)
    save
  end

  def check_env!
    change_state(STATE_CHECK_ENV)
    save
  end

  def log(msg)
    puts "[#{self.class} - #{Time.now}] #{msg}"
  end

  def change_state(target_state)
    if self.state
      self.on_exit(self.state)
    end
    self.state = target_state
    self.on_enter(target_state)
  end

  def send_start_command!
    send_command(start_command)
  end

  def send_stop_command!
    send_command(stop_command)
  end

  def send_command(command_id)
    query = Cocaine::CommandLine.new('sudo codesend', command_id.to_s)
    log "Running: #{query.command}"
    log query.run
  end

  def can_next_tick?
    next_tick_at <= Time.now
  end

  # triggered on enter state
  def on_enter(state)
    log "Enter: #{self.state}"
    if state == STATE_SLEEP
      self.next_tick_at = sleep_duration.minutes.from_now
    elsif state == STATE_RUNNING
      self.shot_left    -= 1
      self.next_tick_at = shot_duration.minutes.from_now
      send_start_command!
    end
  end

  # runned on each tick
  def run(state)
    log "Run #{state}"
    if state == STATE_CHECK_ENV
      start_if_measurment_allows
    elsif state == STATE_SLEEP && can_next_tick?
      change_state(STATE_CHECK_ENV)
    elsif state == STATE_RUNNING && can_next_tick?
      change_state(STATE_CHECK_ENV)
    end
  end

  # triggered on exit state
  def on_exit(state)
    log "Exit #{state}"
    if state == STATE_RUNNING
      send_stop_command!
    end
  end

  # Starts Humidifier if there are shoots left, otherwise go to sleep or set status out of water
  def start_if_measurment_allows
    if shot_left == 0
      change_state(STATE_OUT_OF_WATER)
    elsif current_measurment = Measurement.last
      if current_measurment.humidity < min_humidity
        change_state(STATE_RUNNING)
      else
        change_state(STATE_SLEEP)
      end
    else
      change_state(STATE_SLEEP)
    end
  end
end
