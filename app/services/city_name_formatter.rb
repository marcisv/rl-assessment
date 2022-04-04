class CityNameFormatter
  ABBREVIATIONS_AND_NAMES = {
    'LA' => 'Los Angeles',
    'NYC' => 'New York City',
  }.freeze

  def self.perform(name)
    new(name).perform
  end

  def initialize(name)
    @name = name
  end

  def perform
    ABBREVIATIONS_AND_NAMES[name] || name
  end

  private

  attr_reader :name
end
