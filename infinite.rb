require_relative 'quiz'

class Infinite < Quiz

  @@scheme = Scheme::INFINITE_BOUNCE

  def run questions_per_round = 12, number_of_rounds = 1
    return if @run

    number_of_rounds.times do |round|
      flip = flip? round

      anchors = Anchors.new @teams.size, flip, @@scheme

      run_round questions_per_round, anchors
    end

    super
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
      # puts "Q#{question_number} passed by T#{team.id}, strength: #{team.strength}"
      attempts += 1
      break if attempts >= max_attempts

      anchors.pass!
    end

    if got
      plus team
      question_log[:scored] << team.id
      # puts "Q#{question_number} scored by T#{team.id}, strength: #{team.strength}"
    else
      # puts "Q#{question_number} unanswered"
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
          # puts "Q#{question_number} guessed by T#{team.id}, strength: #{team.strength}"
        else
          minus team
          # puts "Q#{question_number} screwed by T#{team.id}, strength: #{team.strength}"
        end
      end
    end

    pounced
  end

  def print_question_status question, question_log
    p question_log
  end

  def flip? round
    round % 2 == 1
  end

  def next_question
    Question.new
  end
end