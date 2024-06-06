class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  def full_address
    [street, city, state, country].compact.join(', ')
  end

  private

  def address_changed?
    changed = street_changed? || city_changed? || state_changed? || country_changed?
    changed
  end
end

