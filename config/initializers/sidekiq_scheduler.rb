if defined?(Sidekiq) && Sidekiq.server?
  schedule_file = "config/sidekiq.yml"

  if File.exist?(schedule_file)
    Sidekiq::Scheduler.dynamic = true
    Sidekiq.schedule = YAML.load_file(schedule_file)[:schedule]
    Sidekiq::Scheduler.reload_schedule!
  end
end
