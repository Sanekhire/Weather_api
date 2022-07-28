# frozen_string_literal: true

class EmptyDataError < StandardError
  def initialize(msg = 'Empty data! Check the correctness of the city name.')
    super
  end
end
