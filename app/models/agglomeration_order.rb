class AgglomerationOrder < CampaignOrder

  before_update :check

  def check
    if amount_paid > 0 && amount_paid_changed?
      campaign.becomes(Agglomeration).unactive?
      if campaign.participants == 1
          AgglomerationRecord.create(user: user,campaign: campaign)
      end
    end
  end
end
