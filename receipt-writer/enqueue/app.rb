# frozen_string_literal: true

require 'uri'
require 'json'
require 'logger'
require 'slack-ruby-client'
require 'aws-sdk-sqs'
require 'rack'

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

def send_file_to_queue(client, file, channel)
  client.send_message(
    queue_url: ENV.fetch('QUEUE_NAME', nil),
    message_body: {
      file: {
        id: file['id'], name: file['name'], timestamp: file['timestamp'],
        url_private_download: file['url_private_download']
      }, channel:
    }.to_json
  )
end

def send_files_to_queue(body)
  client = Aws::SQS::Client.new

  logger.info(body)

  body.dig('event', 'files')&.each do |file|
    next if file['filetype'] != 'xlsx'

    send_file_to_queue(client, file, body.dig('event', 'channel'))
  end
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  verify_request(event)

  body = JSON.parse(event['body'])
  return { statusCode: 200, body: { challenge: body['challenge'] }.to_json } if body['challenge']

  send_files_to_queue(body)

  { statusCode: 200, body: nil }
rescue StandardError => e
  logger.fatal(e.full_message)
  { statusCode: 200, body: e.message }
end
