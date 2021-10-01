module Mixin::Firmable
  extend ActiveSupport::Concern
  included do

    def self.mixin
      "this should be a beautifully mixed in!"
    end

  end
end