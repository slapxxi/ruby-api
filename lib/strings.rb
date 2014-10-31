require 'benchmark/ips'

Benchmark.ips do |job|
  # job.report('symbol') { :symbol }
  # job.report('single') { 'single' }
  # job.report('double') { "double" }
  # job.report('double & interpolation') { "double #{100}" }

  job.report('array of symbols') { %i{one two three} }
  job.report('array of single') { %w{one two three} }
  job.report('array of double') { %W{one two three} }
end
