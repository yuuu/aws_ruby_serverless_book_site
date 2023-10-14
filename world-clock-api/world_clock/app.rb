# frozen_string_literal: true

require 'uri'
require 'tzinfo'
require 'json'
require 'logger'
require 'slack-ruby-client'
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

def create_local_time(time_str, zone_abbreviation)
  time = Time.parse(time_str) - (9 * 60 * 60)

  zone = TZInfo::Timezone.all.find { _1.abbreviation == zone_abbreviation }
  raise "Timezone not found: #{zone_abbreviation}" if zone.nil?

  time.localtime(zone.observed_utc_offset).iso8601
rescue ArgumentError
  raise "Invalid time format: #{time_str}"
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  verify_request(event)

  params = URI.decode_www_form(event['body']).to_h
  body = create_local_time(*params['text'].split(',').map(&:strip))

  { statusCode: 200, body: }
rescue StandardError => e
  logger.fatal(e.full_message)
  { statusCode: 200, body: e.message }
end
