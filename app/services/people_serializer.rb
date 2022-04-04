require 'date'

class PeopleSerializer
  ATTRIBUTE_NAMES = %i[first_name city birthdate]
  SEPARATOR = ', '
  BIRTHDATE_FORMAT = '%-m/%-d/%Y'

  def self.perform(people_attributes:, sort_by:)
    new(people_attributes:, sort_by:).perform
  end

  def initialize(people_attributes:, sort_by:)
    @people_attributes = people_attributes
    @sort_attribute_name = sort_by
  end

  def perform
    sorted_people_attributes.map do |person_attributes|
      attribute_values = ATTRIBUTE_NAMES.map do |attribute_name|
        format_attribute_value(
          attribute_name,
          person_attributes[attribute_name],
        )
      end

      attribute_values.join(SEPARATOR)
    end
  end

  private

  attr_reader :people_attributes, :sort_attribute_name

  def sorted_people_attributes
    @sorted_people_attributes ||= people_attributes.sort_by { |attrs| attrs[sort_attribute_name] }
  end

  def format_attribute_value(attribute_name, original_value)
    formatter_method_name = :"format_#{attribute_name}"

    if respond_to?(formatter_method_name, true)
      send(formatter_method_name, original_value)
    else
      original_value
    end
  end

  def format_birthdate(original_value)
    Date.parse(original_value).strftime(BIRTHDATE_FORMAT)
  end
end
