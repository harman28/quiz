require_relative 'classes/team'
require_relative 'classes/question'
require_relative 'classes/points'
require_relative 'classes/scheme'
require_relative 'classes/anchors'
require_relative 'classes/fairness'

class Quiz

  attr_reader :teams
  attr_reader :scores

  ##
  # Setting to default, Quiz class is essentially abstract
  @@scheme = Scheme::INFINITE_BOUNCE
  @@pounce = false
  @@config = Hash.new

  def initialize number_of_teams = 6
    set_class_variables

    @teams = []
    @run = false

    number_of_teams.times do |team_number|
      team =  Team.new team_number+1

      @teams << team
    end
  end

  def run questions_per_round = 12, number_of_rounds = 1, verbose = false
    return @scores if !@scores.nil?

    init_scores

    @verbose = verbose

    number_of_rounds.times do |round|
      flip = flip? round

      anchors = Anchors.new @teams.size, flip, @@config

      run_round questions_per_round, anchors
    end

    @run = true

    @scores
  end

  def fairness
    @fairness ||= calculate_fairness
  end

  protected

  def set_class_variables
    @@pounce   = Scheme.is_pounce? @@scheme

    @@config[:infinite] = Scheme.is_infinite? @@scheme
    @@config[:shifting] = Scheme.is_shifting? @@scheme
    @@config[:written]  = Scheme.is_written? @@scheme
  end

  private

  def run_round questions_per_round, anchors
    questions_per_round.times do |question_number|
      question = next_question question_number+1

      run_question question, anchors

      anchors.next_question!
    end
  end

  def run_question question, anchors
    puts "Q#{question.to_s @verbose}, direct to team #{anchors.direct.pointer}"
    question_log = {:pounced => [], :scored => [], :passed => []}

    question_log[:pounced] = handle_pounce question, anchors

    max_attempts = @teams.size - question_log[:pounced].size

    # Everybody pounced!
    if max_attempts.zero?
      return
    end

    got      = false
    attempts = 0
    team     = nil

    loop do
      team = @teams[anchors.direct.pointer-1]

      if question_log[:pounced].include? team.id
        anchors.pass!
        next
      end

      if team.knows? question
        got = true
        break
      end
      question_log[:passed] << team.id
      puts "Q#{question.id} passed by T#{team.to_s @verbose}"
      attempts += 1
      break if attempts >= max_attempts

      anchors.pass!
    end

    if got
      plus team
      question_log[:scored] << team.id
      puts "Q#{question.id} scored by T#{team.to_s @verbose}"
    else
      puts "Q#{question.id} unanswered"
    end

  end

  def handle_pounce question, anchors
    pounced = []

    return pounced if not @@pounce

    @teams.each do |team|
      # Don't pounce on your own question
      next if direct? team, anchors

      if team.pounces? question, @@config[:written]
        pounced << team.id
        if team.knows? question or team.guesses?
          plus team
          puts "Q#{question.id} guessed by T#{team.to_s @verbose}"
        else
          minus team if not @@config[:written]
          puts "Q#{question.id} screwed by T#{team.to_s @verbose}"
        end
      end
    end

    pounced
  end

  ##
  # From the team strengths and their scores, judge fairness
  # Can't be boolean because fairness threshold could be anything
  def calculate_fairness
    strengths = @teams.map(&:strength)
    scores = @scores.values

    FairnessCheck.pearson_product_moment_correlation_coefficient strengths, scores
  end

  def init_scores
    @scores = Hash.new

    @teams.each do |team|
      @scores[team] = 0;
    end
  end

  def flip? round
    round % 2 == 1
  end

  def next_question question_number
    Question.new question_number
  end

  def plus team
    @scores[team] += Points::PLUS
  end


  def minus team
    @scores[team] += Points::MINUS
  end

  def direct? team, anchors
    @teams[anchors.direct.pointer-1] == team and not @@config[:written]
  end
end