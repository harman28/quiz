class Question

  attr_reader :difficulty

  @@upper_difficulty = 100
  @@lower_difficulty = 0

  def initialize lower_difficulty = 0, upper_difficulty = 100
    @difficulty = random_difficulty(lower_difficulty, upper_difficulty+1)

    @@lower_difficulty = lower_difficulty
    @@upper_difficulty = upper_difficulty
  end

  private

  def random_difficulty lower_difficulty, upper_difficulty
    lower_difficulty + rand*(upper_difficulty - lower_difficulty)
  end
end