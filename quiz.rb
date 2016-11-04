require_relative 'team'
require_relative 'question'
require_relative 'points'
require_relative 'scheme'
require_relative 'anchors'
require_relative 'fairness'

class Quiz

  attr_reader :teams
  attr_reader :scores

  def initialize number_of_teams = 6, pounce = false
    @teams = []
    @scores = Hash.new
    @pounce = pounce
    @run = false

    number_of_teams.times do |team_number|
      team =  Team.new team_number+1

      @teams << team
      @scores[team] = 0;
    end
  end

  ##
  # Populates hash of team scores
  def run questions_per_round = 12, number_of_rounds = 1
    return if @run
    @run = true
  end

  def plus team
    @scores[team] += Points::PLUS
  end


  def minus team
    @scores[team] += Points::MINUS
  end

  def direct? team, anchors
    @teams[anchors.direct.pointer] == team
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