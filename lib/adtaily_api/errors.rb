class AdTailyAPI
  class Error < StandardError; end

  # Unknown server response
  class UnknownResponse < Error; end

  # Invalid request server response
  class InvalidRequest< Error; end

  # Campaign invalid
  class CampaignNotValid< Error; end

end