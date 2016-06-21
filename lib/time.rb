class Time

  def week_number
    self.strftime("%U").to_i
  end

end
