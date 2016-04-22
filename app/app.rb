require 'sinatra/base'
require 'json'

class FakeIdvaas < Sinatra::Application
  get '/' do
    'Hello, USA!'
  end

  get '/user/:user_uuid/question/?' do
    help_image_url = 'http://localhost:8080/idvaas/help-image/' +
      '22619919-2adb-5825-1cf4-06e1d4a9e11b.jpg'
    {
      question: {
        questionId: '6c354be7-6d0f-46ab-8407-96624a362f17',
        text: 'Which of the following cities have you lived in?',
        answers: [
          {
            key: 1,
            text: 'METROPOLIS'
          },
          {
            key: 2,
            text: 'GOTHAM'
          },
          {
            key: 3,
            text: 'GONDOR <-- FAILS TEST'
          },
          {
            key: 4,
            text: 'HOGSMEADE'
          },
          {
            key: 5,
            text: 'NONE OF THE ABOVE <-- PASSES TEST'
          }
        ],
        helpMessage: 'This is the help message',
        helpImageUrl: help_image_url }
    }.to_json
  end

  get '/user/:user_uuid/?' do
    json_response 200, { status: 'REGISTERED' }.to_json
  end

  post '/user/:user_uuid/?' do
    json_response 201, { status: 'REGISTERED' }.to_json
  end

  post '/user/:user_uuid/question/?' do
    request.body.rewind

    key = JSON.parse(request.body.read)['key']

    json_response 200, { quizStatus: quiz_status(key) }.to_json
  end

  get '/user/:user_uuid/quiz-status/?' do
    json_response 200, { quizStatus: 'NOT_STARTED' }.to_json
  end

  private

  def json_response(response_code, payload)
    content_type :json
    status response_code
    payload
  end

  def quiz_status(key)
    key_to_result.fetch(key)
  end

  def key_to_result
    {
      1 => 'STARTED',
      2 => 'NOT_ENOUGH_QUESTIONS',
      3 => 'FAILED',
      4 => 'NOT_STARTED',
      5 => 'PASSED'
    }
  end

  run! if app_file == $0
end
