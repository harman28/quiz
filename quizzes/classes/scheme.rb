class Scheme

  INFINITE_BOUNCE = 'INFINITE_BOUNCE'
  INFINITE_POUNCE = 'INFINITE_POUNCE'

  SHIFTING_BOUNCE = 'SHIFTING_BOUNCE'
  SHIFTING_POUNCE = 'SHIFTING_POUNCE'

  WRITTEN         = 'WRITTEN'

  INFINITE = [
    INFINITE_BOUNCE,
    INFINITE_POUNCE
  ]

  SHIFTING = [
    SHIFTING_BOUNCE,
    SHIFTING_POUNCE
  ]

  POUNCE = [
    INFINITE_POUNCE,
    SHIFTING_POUNCE
  ]

  def self.is_infinite? scheme
    INFINITE.include? scheme
  end

  def self.is_shifting? scheme
    SHIFTING.include? scheme
  end

  def self.is_pounce? scheme
    POUNCE.include? scheme
  end

  def self.is_written? scheme
    WRITTEN == scheme
  end
end