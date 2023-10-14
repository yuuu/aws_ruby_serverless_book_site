# frozen_string_literal: true

require 'json'
require 'logger'
require 'slack-ruby-client'

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN', nil)
end

def logger
  @logger ||= Logger.new($stdout, level: Logger::Severity::DEBUG)
end

def create_text(event)
  click_type_name = event.dig('payloads', 'clickTypeName')
  battery_level = event.dig('payloads', 'batteryLevel')

  text = case click_type_name
         when 'SINGLE'
           '在庫が減っているようです'
         when 'DOUBLE'
           '在庫がなくなりました'
         end
  text += "\nボタンの電池を交換してください" if battery_level <= 0.25
  text
end

def post_message(text)
  client = Slack::Web::Client.new
  client.chat_postMessage(
    channel: ENV.fetch('SLACK_CHANNEL', ''),
    text:,
    as_user: true
  )
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  post_message(create_text(event))
rescue StandardError => e
  logger.fatal(e.full_message)
end
