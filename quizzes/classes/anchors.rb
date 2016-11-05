require_relative 'scheme'

class Anchors
  attr_reader :start
  attr_reader :direct

  def initialize number_of_teams = 6, flip = false, config
    @start  = Anchor.new number_of_teams, flip

    @direct = Anchor.new number_of_teams, flip

    @config = config

    @teams  = *(1..number_of_teams)
  end

  ##
  # Call this when passing a question
  def pass!
    @direct.next!
  end

  ##
  # Call this when moving to next question
  def next_question!
    if @config[:infinite]
      @direct.next!

      @start = @direct.clone
    elsif @config[:shifting]
      @start.next!

      @direct = @start.clone
    end
  end

  ##
  # Have n passes been made, where n is number of teams?
  # Make sure you check this after at least one pass
  def pass_complete?
    @direct.pointer == @start.pointer
  end
end

class Anchor
  attr_reader :pointer

  def initialize number_of_teams, flip
    @pointer = 1

    @flip = flip

    @teams = *(1..number_of_teams)
  end

  def next!
    unless @flip
      @pointer += 1
      @pointer = 1 if @pointer > @teams.size
    else
      @pointer -= 1
      @pointer = @teams.size if @pointer < 1
    end
  end
end