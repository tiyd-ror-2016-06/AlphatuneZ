class Time
  def week_number
    self.strftime("%U").to_i
  end

  def convert_to_US_civilian_time(created_at)
    time = created_at
    twelve_hour_clock_time = '%m-%d-%Y %I:%M:%S %p'
    time.strftime(twelve_hour_clock_time)
  end
end
