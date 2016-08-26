class Lottery < Campaign


  scope :active,->{
    where(status: 'active')
  }

  def check_next_periods
    if periods >= max_periods
      self.status = 'inactive'
      return
    end
    self.participants += 1
    if participants >= max_participants
      self.generate_hit
      self.periods += 1
      self.participants = 0
    end
    save
  end

  def generate_hit
    LotteryRecord.generate_hit(periods,max_participants,self)
  end

end
