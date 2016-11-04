require_relative 'team'
require_relative 'question'
require_relative 'fairness'

class Quiz

  attr_reader :teams
  attr_reader :scores

  def initialize number_of_teams = 6
    @teams = []
    @scores = Hash.new

    number_of_teams.times do
      team =  Team.new

      @teams << team
      @scores[team] = 0;
    end
  end

  ##
  # Populates hash of team scores
  def run
  end

  ##
  # From the team strengths and their scores, judge fairness
  # Can't be boolean because fairness threshold could be anything
  def fairness
    strengths = @teams.map(&:strength)
    scores = @scores.values

    FairnessCheck.pearson_product_moment_correlation_coefficient strengths, scores
  end
end