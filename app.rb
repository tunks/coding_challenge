require 'sinatra'
require 'json'
require "sinatra/reloader" if development?
require "./lib/simple_captcha"

#route GET action method  to get the captcha
#response include the captcha text, excluded words and an authentication token
get '/' do
  begin
      #different captcha class types could be switched  (strategy pattern)
      #Another alternative approach could be to used  
      #SimpleCaptcha::Captcha.new(SimpleCaptcha::WordCount.new)
      captcha = SimpleCaptcha::Captcha.new(SimpleCaptcha.get_captcha(:word_count))
      #different captacha data could be retrieve from the DataSource class
      #captacha data is loaded from file
      data = captcha.generate(SimpleCaptcha::DataSource.from_file)
      erb :"get.json", locals: data
  rescue Exception => e
      halt 400, "Invalid request!"
  end
end


#route POST action method  to get the captcha
#validates the word count
post "/validate" do
  begin
    #Another alternative approach could be to used  
    #SimpleCaptcha::Captcha.new(SimpleCaptcha::WordCount.new)
    captcha = SimpleCaptcha::Captcha.new(SimpleCaptcha.get_captcha(:word_count))
    valid = captcha.validate(params[:data])
  rescue
     valid = false
  end
  #response with status 400 with if validation is unsuccessful
  halt 400, 'Invalid!' unless valid
  #response with status 200 once validated successfully
  "Ok, successful!"
end