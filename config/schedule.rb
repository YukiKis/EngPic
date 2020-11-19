# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = Rails.env.to_sym
set :envirnment, rails_env
set :output, "log/cron.log"

set :environment, :production
every 1.day, :at => "9:00 pm" do
# every 1.minute do
  begin
    runner "Batch::SendNotifyEmail.send_notify_mail"
  rescue => e
    Rails.logger.error("Aborted rails runner")
    raise e
  end
end

set :environment, :production
every :month, :at => "9:00 pm" do
# every 2.minute do
  begin
    runner "Batch::SendMonthlyEmail.send_monthly_mail"
  rescue => e
    Rails.logger.error("Aborted rails runner")
    raise e
  end
end

# Learn more: http://github.com/javan/whenever
