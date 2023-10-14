# frozen_string_literal: true

require 'json'
require 'test/unit'
require 'mocha/test_unit'
require 'httparty'
require 'slack-ruby-client'

require_relative '../../world_clock/app'

class WorldClockTest < Test::Unit::TestCase
  def event
    JSON.parse(
      {
        body: 'token=FkIWuGD8SuTzKS6xn89OTwex&team_id=T05S1J6RS5P&team_domain=w1694307074-837281626&channel_id' \
              '=C05SBUTDQLQ&channel_name=ruby%E3%81%A7%E3%81%AF%E3%81%98%E3%82%81%E3%82%8B%E3%82%B5%E3%83%BC%E' \
              '3%83%90%E3%83%BC%E3%83%AC%E3%82%B9%E5%85%A5%E9%96%80&user_id=U05RRCMK6CU&user_name=webservice&c' \
              'ommand=%2Fworld-clock&text=2023-10-04+05%3A56%2C+PDT&api_app_id=A05UKM386AK&is_enterprise_insta' \
              'll=false&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT05S1J6RS5P%2F5993041993426%2F' \
              'LaweDovBhgWxWIyc1vzSrjHY&trigger_id=6016036297728.5885618876193.f19502e0049a02afe1c3dadeddab3002',
        resource: '/{proxy+}',
        path: '/world_clock',
        httpMethod: 'POST',
        isBase64Encoded: true,
        queryStringParameters: {
          foo: 'bar'
        },
        pathParameters: {
          proxy: '/world_clock'
        },
        stageVariables: {
          baz: 'qux'
        },
        headers: {
          'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Encoding' => 'gzip, deflate, sdch',
          'Accept-Language' => 'en-US,en;q=0.8',
          'Cache-Control' => 'max-age=0',
          'CloudFront-Forwarded-Proto' => 'https',
          'CloudFront-Is-Desktop-Viewer' => 'true',
          'CloudFront-Is-Mobile-Viewer' => 'false',
          'CloudFront-Is-SmartTV-Viewer' => 'false',
          'CloudFront-Is-Tablet-Viewer' => 'false',
          'CloudFront-Viewer-Country' => 'US',
          'Host' => '1234567890.execute-api.us-east-1.amazonaws.com',
          'Upgrade-Insecure-Requests' => '1',
          'User-Agent' => 'Custom User Agent String',
          'Via' => '1.1 08f323deadbeefa7af34d5feb414ce27.cloudfront.net (CloudFront)',
          'X-Amz-Cf-Id' => 'cDehVQoZnx43VYQb9j2-nvCh-9z396Uhbp027Y2JvkCPNLmGJHqlaA==',
          'X-Forwarded-For' => '127.0.0.1, 127.0.0.2',
          'X-Forwarded-Port' => '443',
          'X-Forwarded-Proto' => 'https',
          'X-Slack-Request-Timestamp' => '1696454019',
          'X-Slack-Signature' => 'v0=f2a8765889cd02f30b0c5e463dd268dc4706fe512d011e99c60d2878c8993e31'
        },
        requestContext: {
          accountId: '123456789012',
          resourceId: '123456',
          stage: 'prod',
          requestId: 'c6af9ac6-7b61-11e6-9a41-93e8deadbeef',
          requestTime: '09/Apr/2015:12:34:56 +0000',
          requestTimeEpoch: 1_428_582_896_000,
          identity: {
            cognitoIdentityPoolId: 'null',
            accountId: 'null',
            cognitoIdentityId: 'null',
            caller: 'null',
            accessKey: 'null',
            sourceIp: '127.0.0.1',
            cognitoAuthenticationType: 'null',
            cognitoAuthenticationProvider: 'null',
            userArn: 'null',
            userAgent: 'Custom User Agent String',
            user: 'null'
          },
          path: '/prod/path/to/resource',
          resourcePath: '/{proxy+}',
          httpMethod: 'POST',
          apiId: '1234567890',
          protocol: 'HTTP/1.1'
        }
      }.to_json
    )
  end

  def expected_result
    { body: '2023-10-03T04:56:00-07:00', statusCode: 200 }
  end

  def test_lambda_handler
    Slack::Events::Config.signing_secret = '9e99c83fd73669710169413c989f9eca'
    Slack::Events::Config.signature_expires_in = 60 * 60 * 24 * 365 * 100

    assert_equal(lambda_handler(event:, context: {}), expected_result)
  end
end
