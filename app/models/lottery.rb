class Lottery < ActiveRecord::Base

  has_many :attachments, as: :parent, dependent: :destroy, autosave: true, class_name: 'Attachment'

  def attachments=(attrs)
    attachments.build(attrs['image']) if attrs['image']['file'].present?
  end

  def default_image
    attachments.order(created_at: :desc).for('default_image')
  end

  def default_image_file=(file)
    attachments.build(file: file, role: 'default_image')
  end

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
