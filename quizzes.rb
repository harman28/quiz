require_relative 'app/quiz'

class InfiniteBounce < Quiz

  @@scheme = Scheme::INFINITE_BOUNCE

  def initialize number_of_teams = 6
    super number_of_teams, false
  end
end

class InfinitePounce < Quiz

  @@scheme = Scheme::INFINITE_POUNCE

  def initialize number_of_teams = 6
    super number_of_teams, true
  end
end

class RollingBounce < Quiz

  @@scheme = Scheme::ROLLING_BOUNCE

  def initialize number_of_teams = 6
    super number_of_teams, false
  end
end

class RollingPounce < Quiz

  @@scheme = Scheme::ROLLING_POUNCE

  def initialize number_of_teams = 6
    super number_of_teams, true
  end
end

