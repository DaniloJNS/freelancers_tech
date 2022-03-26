redis_yml = YAML.load(File.open(Rails.root.join('config/redis.yml'))).symbolize_keys[Rails.env.to_sym]

$redis_config = redis_yml.transform_values { |value| ERB.new(value).result }

$redis = Redis.new($redis_config)
