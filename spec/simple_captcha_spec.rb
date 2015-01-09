require 'spec_helper'
#simple captcha module test cases

describe SimpleCaptcha do
  describe "word count captcha#" do
    before(:all) do
      @captcha = SimpleCaptcha::Captcha.new(SimpleCaptcha::WordCount.new)  
    end

    let(:text) {SimpleCaptcha::DataSource.from_file}
    let(:captcha_data) {@captcha.generate(text)}
    
    #test the generated captcha data
    context "generate captcha data" do
       it "generate captcha data returns text,exclude and token " do
          expect(captcha_data).to  have_key(:text)
          expect(captcha_data).to  have_key(:exclude)
          expect(captcha_data).to  have_key(:token)
       end
    end
    
    context "validate captcha with correct answer" do
       let(:word_count){count_words(captcha_data[:text], captcha_data[:exclude]||[])}
       let(:captcha_answer){ captcha_data.merge({:word_count=> word_count}) }
       
       it "returns true with correct captcha answer" do
           expect(@captcha.validate(captcha_answer)).to eql(true)
       end
    end
    
    #testing captcha answer is invalid
    #no answer given
    context "invalid validate captcha with no answer" do
       let(:captcha_answer){} 
       it "returns false with correct captcha answer" do
           expect(@captcha.validate(captcha_answer)).to eql(false)
       end
    end
    
    #testing captcha answer is invalid
    #the token is fake or invalid
    context "invalid validate captcha with incorrect token answer" do
       let(:word_count){count_words(captcha_data[:text], captcha_data[:exclude]||[])}
       let(:captcha_answer){        
           {:word_count => word_count,
            :exclude => captcha_data[:exclude]||[],
            :token => "DFFFFDA8/D9AKDFSFD9J3LDFSD" #fake token
           }
         } 
       it "returns false with incorrect captcha answer(wrong token)" do
           expect(@captcha.validate(captcha_answer)).to eql(false)
       end
    end
  end
end

