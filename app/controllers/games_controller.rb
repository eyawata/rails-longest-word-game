require "open-uri"

class GamesController < ApplicationController
  def new
    letter = ('a'..'z').to_a
    @letters = Array.new(10) { letter.sample.upcase }
  end

  def check_letters(letters, word_arr)
    sorted_first = letters.sort
    sorted_second = word_arr.sort

    sorted_second.each do |letter|
      index = sorted_first.index(letter)
      return false if index.nil?
      sorted_first.delete_at(index)
    end
    true
  end

  def score
    @letters_arr = params[:letters].split(" ")
    @word_arr = params[:word].upcase.split("")
    # The word can’t be built out of the original grid ❌
    if @word_arr.all? { |letter| @letters_arr.include?(letter) }
      @score = "#{params[:word]} was built from array!!!"
      result = URI.open("https://dictionary.lewagon.com/#{params[:word]}").read
      result = JSON.parse(result)
      if result["found"] == true && check_letters(@letters_arr, @word_arr)
        @score = "#{params[:word]} is from the array and is a valid word!!!"
      else
        @score = "#{params[:word]} is from the array and is NOT a valid word!!!"
      end
    else
      @score = "`#{params[:word]}` was not built from array!!!"
    end
    # The word is valid according to the grid, but is not a valid English word ❌
    # The word is valid according to the grid and is an English word ✅
  end
end
