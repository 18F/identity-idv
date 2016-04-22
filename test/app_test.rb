ENV['RACK_ENV'] = 'test'

require_relative '../app/app'
require 'test/unit'
require 'rack/test'
# require 'json'

class FakeIdVTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    FakeIdV
  end

  def test_it_says_hello_usa
    get '/'
    assert last_response.ok?
    assert_equal 'Hello, USA!', last_response.body
  end

  def test_it_shows_user
    get '/user/1'
    assert last_response.ok?
    assert_equal '{"status":"REGISTERED"}', last_response.body
  end

  def test_it_shows_quiz_status
    get '/user/1/quiz-status'
    assert last_response.ok?
    assert_equal '{"quizStatus":"NOT_STARTED"}', last_response.body

    #TODO: add test for 'USER NOT REGISTERED' exception
  end

  def test_it_sends_questions
    get '/user/1/question'
    assert last_response.ok?
    response = JSON.parse last_response.body
    assert response.has_key? 'question'
    assert_equal %w(questionId text answers helpMessage helpImageUrl),
                 response['question'].keys

    #TODO: add tests for exceptions
  end

  def test_it_registers_a_user
    post '/user/1/', '{"regNumber": "A092206983", "regPin": "jlk8893"}'
    assert_equal 201, last_response.status
    assert_equal '{"status":"REGISTERED"}', last_response.body
  end

  def test_it_accepts_answer
    post '/user/1/question',
         '{"questionId":"eaef8225-0eed-4cde-817b-f1850302b7bc","key":1}'
    assert last_response.ok?
    assert_equal '{"quizStatus":"STARTED"}', last_response.body

    post '/user/1/question/',
         '{"questionId":"eaef8225-0eed-4cde-817b-f1850302b7bc","key":3}'
    assert last_response.ok?
    assert_equal '{"quizStatus":"FAILED"}', last_response.body

    post '/user/1/question/',
         '{"questionId":"eaef8225-0eed-4cde-817b-f1850302b7bc","key":5}'
    assert last_response.ok?
    assert_equal '{"quizStatus":"PASSED"}', last_response.body
  end
end
