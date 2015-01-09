require "./spec/spec_helper"
require "json"
require "./lib/simple_captcha"

#app routes test cases
describe 'The Word Counting App' do 
   
   def app
     Sinatra::Application
   end
   
   #test the requested captcha test
   describe "#get actions" do     
    context "request captcha  from server" do
       it "returns 200 and has the right keys" do
        get '/'
        expect(last_response).to be_ok
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response).to have_key("text")
        expect(parsed_response).to have_key("exclude")
        expect(parsed_response).to have_key("token")
       end
    end
   end
  
   #performs the post request actions to the server
   describe "Post actions" do
      #invalid data being posted to the server
      context "#posting invalid data" do
        #load text from file
        let(:text) {SimpleCaptcha::DataSource.from_file}
        #fake or false token 
        let(:invalid_token){ "23242dkKSDFSDFSDF+kdfsffd"} 
        #invalid param data to be posted
        let(:params){
           {:word_count => count_words(text), 
            :text => text,
            :token=> invalid_token
            }
        }
        
        it "returns 400 response from post without any params" do
           post "/validate"
           expect(last_response.status).to eql(400)
        end

        it "returns 400 response from post request with invalid param values" do
          post "/validate", :data => params
          expect(last_response.status).to  eql(400)
        end
      end
      
      context "#posting valid data" do
        #simple approach to get captcha data from  a "get" request
        before(:each) do
          get '/'
        end
        #parsed json data of the response from the "get" request 
        let(:captcha_data){JSON.parse(last_response.body)}
        #correct data to be posted to the server on "post" request
        let(:params){ 
            captcha_data.merge({:word_count=> count_words(captcha_data["text"], captcha_data["exclude"]||[] )}) 
        } 
        
        it "returns 200 response from valid post param values" do
          post "/validate", :data => params
          expect(last_response.status).to  eql(200)
        end
      end
   end
end