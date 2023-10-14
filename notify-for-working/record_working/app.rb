# frozen_string_literal: true

require 'uri'
require 'json'
require 'logger'
require 'slack-ruby-client'
require 'rack'
require 'aws-sdk-dynamodb'

def logger
  @logger ||= Logger.new($stdout, level: Logger::Severity::INFO)
end

def verify_request(event)
  env = {
    'rack.input' => StringIO.new(event['body']),
    'HTTP_X_SLACK_REQUEST_TIMESTAMP' => event.dig('headers', 'X-Slack-Request-Timestamp'),
    'HTTP_X_SLACK_SIGNATURE' => event.dig('headers', 'X-Slack-Signature')
  }
  req = Rack::Request.new(env)
  slack_request = Slack::Events::Request.new(req)
  slack_request.verify!
end

def save_working(params)
  client = Aws::DynamoDB::Client.new
  resp = client.put_item(
    item: { slack_id: params['user_id'], working: params['text'] == 'start' },
    table_name: ENV.fetch('TABLE_NAME')
  )
  logger.debug(resp)
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  verify_request(event)

  params = URI.decode_www_form(event['body']).to_h
  logger.debug(params)

  save_working(params)
  { statusCode: 200, body: nil }
rescue StandardError => e
  logger.fatal(e.full_message)
  { statusCode: 200, body: e.message }
end
