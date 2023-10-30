# frozen_string_literal: true

require 'json'
require 'logger'
require 'slack-ruby-client'

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN', nil)
end

def logger
  @logger ||= Logger.new($stdout, level: Logger::Severity::INFO)
end

def user_name(client, slack_id)
  resp = client.users_info(user: slack_id)
  profile = resp.user.profile
  profile.first_name.nil? ? profile.display_name : profile.first_name
end

def post_message(client, text)
  client.chat_postMessage(
    channel: ENV.fetch('SLACK_CHANNEL', ''),
    text:,
    as_user: true
  )
end

def notify_working(client, slack_id, working)
  message = "#{user_name(client, slack_id)} has #{working ? 'started' : 'finished'} working."
  logger.info(message)
  post_message(client, message)
end

def notify_working_each(records)
  client = Slack::Web::Client.new

  records.each do |record|
    case record['eventName']
    when 'INSERT', 'MODIFY'
      item = record.dig('dynamodb', 'NewImage')
      slack_id = item.dig('slack_id', 'S')
      working = item.dig('working', 'BOOL')
      notify_working(client, slack_id, working)
    end
  end
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)
  notify_working_each(event['Records'])
rescue StandardError => e
  logger.fatal(e.full_message)
end
