module Billing::Info::Text
  extend ActiveSupport::Concern
  included do

    def self.text
      "this should be a beautiful poem extension!"
    end

  end
end