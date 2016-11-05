require_relative 'question'

class Team

  attr_reader :strength
  attr_reader :id

  @@upper_strength = 100
  @@lower_strength = 0

  def initialize id = nil, lower_strength = 0, upper_strength = 100
    @strength = random_strength(lower_strength, upper_strength)

    @id = id

    @@lower_strength = lower_strength
    @@upper_strength = upper_strength
  end

  ##
  # 2 ways of getting a question right
  # 1) You know the answer
  # 2) It's a pounce round, you pounce, and you guess right
  def gets? question, pounce = false
    knows? question or (pounce and pounces? question and guesses?)
  end

  ##
  # You pounce if question is within your guessing range,
  # which is set to within 10% of the difficulty of the question
  #
  # Force flag is used to simulate written rounds, where everyone pounces
  def pounces? question, force = false
    @strength >= (question.difficulty - guess_range) or force
  end

  ##
  # Probability of guessing right is the same as your strength
  # Assumption: Knowledgeable quizzers are good quessers, and vice versa
  def guesses?
    strength >= random_strength(@@lower_strength, @@upper_strength)
  end

  ##
  # You know the answer if your strength is higher than the question difficulty
  def knows? question
    @strength >= question.difficulty
  end

  def to_s verbose = false
    string = id.to_s
    string += ", strength: #{strength}" if verbose
    string
  end

  private

  def random_strength lower_strength, upper_strength
    lower_strength + rand*(upper_strength - lower_strength)
  end

  def guess_range
    (@@upper_strength - @@lower_strength)/10
  end
end