require_relative '../quizzes/written'
require_relative '../quizzes/infinite_bounce'
require_relative '../quizzes/infinite_pounce'

times = [ARGV[0].to_i, 1].max

ib_fairness_total = 0
ip_fairness_total = 0
w_fairness_total = 0

times.times do
  ib = InfiniteBounce.new
  ip = InfinitePounce.new
  w  = Written.new

  ib.run
  ib_fairness_total += ib.fairness

  ip.run
  ip_fairness_total += ip.fairness

  w.run
  w_fairness_total += w.fairness
end

puts "InfiniteBounce Fairness: #{ib_fairness_total/times}"
puts "InfinitePounce Fairness: #{ip_fairness_total/times}"
puts "Written Fairness: #{w_fairness_total/times}"