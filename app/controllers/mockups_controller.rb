class MockupsController < ApplicationController
  def habits
    @habits = [
      "Rise early",
      "Work out",
      "Read",
      "Work"
    ]
  end
end
