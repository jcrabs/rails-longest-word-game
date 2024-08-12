require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    def generate_grid(grid_size)
      # generate random grid of letters
      Array.new(grid_size).map { ("A".."Z").to_a.sample }
    end
    @letters = generate_grid(10)
  end

  def score

    @answer = params[:answer].upcase
    @letters = params[:letters]

    def get_word_info(word)
      url = "https://dictionary.lewagon.com/#{word}"
      word_info_serialized = URI.open(url).read
      JSON.parse(word_info_serialized)
    end

    def en_word?(word)
      get_word_info(word)["found"]
    end

    def word_in_grid?(word, grid)
      word = word.upcase
      word.chars.all? { |letter| (grid.count(letter) >= word.count(letter)) }
    end

    def create_message(attempt, grid)
      if word_in_grid?(attempt, grid)
        if en_word?(attempt)
          @message = :congrats
        else
          @message = :not_valid
        end
      else
        @message = :not_built
      end
    end

    create_message(@answer, @letters)

  end
end
