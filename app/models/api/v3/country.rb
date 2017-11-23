module Api
  module V3
    class Country < BaseModel
      has_one :country_property
      has_many :contexts

      delegate :latitude, to: :country_property
      delegate :longitude, to: :country_property
      delegate :zoom, to: :country_property
    end
  end
end
