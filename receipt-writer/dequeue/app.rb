# frozen_string_literal: true

require 'uri'
require 'json'
require 'logger'
require 'httparty'
require 'aws-sdk-s3'

def logger
  @logger ||= Logger.new($stdout, level: Logger::Severity::INFO)
end

def download_file(file_url)
  response = HTTParty.get(
    file_url,
    headers: {
      'Authorization' => "Bearer #{ENV.fetch('SLACK_API_TOKEN')}"
    }
  )
  raise "Failed to download file: #{response.code} #{response.body}" if response.code != 200

  response.body
end

def upload_to_s3(file, body, channel)
  s3 = Aws::S3::Resource.new
  key = "#{Time.at(file['timestamp']).strftime('%Y/%m/%d/%H/%M/%S')}/#{file['id']}/#{file['name']}"
  obj = s3.bucket(ENV.fetch('BUCKET_NAME')).object(key)
  obj.put(body:, tagging: "channel=#{channel}")
end

def lambda_handler(event:, context:)
  logger.debug(event)
  logger.debug(context)

  event['Records']&.each do |record|
    body = JSON.parse(record['body'])
    file = body['file']
    upload_to_s3(file, download_file(file['url_private_download']), body['channel'])
  end
rescue StandardError => e
  logger.fatal(e.full_message)
end
