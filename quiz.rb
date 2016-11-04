require_relative 'team'
require_relative 'question'
require_relative 'points'
require_relative 'scheme'
require_relative 'anchors'
require_relative 'fairness'

class Quiz

  attr_reader :teams
  attr_reader :scores

  def initialize number_of_teams, pounce
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

  def run questions_per_round = 12, number_of_rounds = 1
    return if @run

    number_of_rounds.times do |round|
      flip = flip? round

      anchors = Anchors.new @teams.size, flip

      run_round questions_per_round, anchors
    end

    @run = true

    @scores
  end

  ##
  # From the team strengths and their scores, judge fairness
  # Can't be boolean because fairness threshold could be anything
  def fairness
    strengths = @teams.map(&:strength)
    scores = @scores.values

    FairnessCheck.pearson_product_moment_correlation_coefficient strengths, scores
  end

  private

  def run_round questions_per_round, anchors
    questions_per_round.times do |question_number|
      question = next_question

      run_question question, anchors, question_number+1

      anchors.next_question!
    end
  end

  def run_question question, anchors, question_number
    puts "Q#{question_number}, difficulty: #{question.difficulty}"
    question_log = {:pounced => [], :scored => [], :passed => []}

    question_log[:pounced] = handle_pounce question, anchors, question_number

    max_attempts = @teams.size - question_log[:pounced].size

    # Everybody pounced!
    if max_attempts.zero?
      print_question_status question, question_log
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

      if team.gets? question, @pounce
        got = true
        break
      end
      question_log[:passed] << team.id
      puts "Q#{question_number} passed by T#{team.id}, strength: #{team.strength}"
      attempts += 1
      break if attempts >= max_attempts

      anchors.pass!
    end

    if got
      plus team
      question_log[:scored] << team.id
      puts "Q#{question_number} scored by T#{team.id}, strength: #{team.strength}"
    else
      puts "Q#{question_number} unanswered"
    end

    print_question_status question, question_log
  end

  def handle_pounce question, anchors, question_number
    pounced = []

    return pounced if not @pounce

    @teams.each do |team|
      # Don't pounce on your own question
      next if direct? team, anchors

      if team.pounces? question, @pounce
        pounced << team.id
        if team.gets? question, @pounce
          plus team
          puts "Q#{question_number} guessed by T#{team.id}, strength: #{team.strength}"
        else
          minus team
          puts "Q#{question_number} screwed by T#{team.id}, strength: #{team.strength}"
        end
      end
    end

    pounced
  end

  def print_question_status question, question_log
    return
    p question_log
  end

  def flip? round
    round % 2 == 1
  end

  def next_question
    Question.new
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
end