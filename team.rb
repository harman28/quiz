require_relative 'question'

class Team

  attr_reader :strength

  @@upper_strength = 100
  @@lower_strength = 0

  def initialize lower_strength = 0, upper_strength = 100
    @strength = random_strength(lower_strength, upper_strength)

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

  private

  ##
  # You know the answer if your strength is higher than the question difficulty
  def knows? question
  	@strength >= question.difficulty
  end

  ##
  # You pounce if question is within your guessing range,
  # which is set to within 10% of the difficulty of the question
  def pounces? question
  	@strength >= (question.difficulty - guess_range)
  end

  ##
  # Probability of guessing right is the same as your strength
  # Assumption: Knowledgeable quizzers are good quessers, and vice versa
  def guesses?
  	strength >= random_strength(@@lower_strength, @@upper_strength)
  end

  def random_strength lower_strength, upper_strength
    lower_strength + rand((upper_strength + 1) - lower_strength)
  end

  def guess_range
  	(@@upper_strength - @@lower_strength)/10
  end
end