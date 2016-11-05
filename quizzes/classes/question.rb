class Question

  attr_reader :difficulty
  attr_reader :id

  @@upper_difficulty = 100
  @@lower_difficulty = 0

  def initialize id = nil, lower_difficulty = 0, upper_difficulty = 100
    @difficulty = random_difficulty(lower_difficulty, upper_difficulty+1)

    @id = id

    @@lower_difficulty = lower_difficulty
    @@upper_difficulty = upper_difficulty
  end

  def to_s verbose = false
    string = id.to_s
    string += ", difficulty: #{difficulty}" if verbose
    string
  end

  private

  def random_difficulty lower_difficulty, upper_difficulty
    lower_difficulty + rand*(upper_difficulty - lower_difficulty)
  end
end