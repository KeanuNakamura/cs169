class WordGuesserGame
   # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  def guess(letter)
    if letter.nil? or letter == '' or !letter.match?(/\A[a-zA-Z]\z/)
      raise ArgumentError
    end
    letter = letter.downcase
    if @word.include?(letter) and !@guesses.include?(letter)
      @guesses << letter
    elsif !@word.include?(letter) and !@wrong_guesses.include?(letter)
      @wrong_guesses << letter
    else
      false
    end
  end

  def word_with_guesses()
    res = ""
    @word.each_char do |char|
      if guesses.include?(char)
       res << char
      else
       res << '-'
      end
    end
    res
  end

  def check_win_or_lose()
    if @wrong_guesses.length >= 7
      return :lose
    end
    @word.each_char do |char|
      if !guesses.include?(char)
        return :play
      end
    end
    return :win
  end

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
