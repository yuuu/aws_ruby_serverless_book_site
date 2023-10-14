# frozen_string_literal: true

require 'uri'
require 'logger'
require 'slack-ruby-client'
require 'aws-sdk-s3'
require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'faraday'

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_API_TOKEN', nil)
end

def logger
  @logger ||= Logger.new($stdout, level: Logger::Severity::INFO)
end

def download_from_s3(s3_event)
  bucket = s3_event.dig('bucket', 'name')
  key = URI.decode_www_form_component(s3_event.dig('object', 'key'))

  client = Aws::S3::Client.new
  object = client.get_object(bucket:, key:)
  tagging = client.get_object_tagging(bucket:, key:)

  [key, object, tagging]
end

def post_to_slack(channel, workbook, filename)
  client = Slack::Web::Client.new

  client.files_upload(
    channels: channel,
    file: Faraday::UploadIO.new(workbook.stream, workbook.content_type),
    filename:,
    initial_comment: '完了しました',
    as_user: true
  )
end

def write_workbook(body)
  workbook = RubyXL::Parser.parse_buffer(body)
  worksheet = workbook['受領証']
  [3, 16].each do |row|
    cell = worksheet[row][5]
    cell.change_contents(Time.now.strftime('%Y年%m月%d日'), cell.formula)
  end
  workbook
end

def channel(tagging)
  tagging.tag_set.find { |tag| tag.key == 'channel' }.value
end

def filename(key)
  key.split('/').last
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  event['Records']&.each do |record|
    key, object, tagging = download_from_s3(record['s3'])
    post_to_slack(channel(tagging), write_workbook(object.body), filename(key))
  end
end
