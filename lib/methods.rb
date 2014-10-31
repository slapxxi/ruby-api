require 'benchmark/ips'

def lookup(value)
  value.object_id
  value.__id__
  value.object_id
end

def lazy_lookup(value)
  id = value.object_id
  id
  id
end

def hash_access(h)
  h[:name]
  h[:name]
  h[:name]
end

def lazy_hash_access(h)
  name = h[:name]
  name
  name
end

Benchmark.ips do |job|
  job.report('lookup') { lookup('string') }
  job.report('lazy lookup') { lazy_lookup('string') }

  # job.report('hash access') { hash_access(name: 'slava') }
  # job.report('lazy hash access') { lazy_hash_access(name: 'slava') }
end
