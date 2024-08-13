class GamesController < ApplicationController
  
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # @letters = Array.new(10) { (('a'..'z').to_a + ('A'..'Z').to_a).sample }
    # puts @letters.inspect
  end

  def score
    # Etat grille et mot proposé
    grid = params[:grid]
    word = params[:word]

    # Vérifier si le mot match avec les lettres de la grille
    if grid.nil? || word.nil?
      @result = "Missing word"
    elsif !valid_word_from_grid?(word, grid)
      @result = "Sorry but #{word} can't be built out of #{grid}"
    elsif !english_word?(word)
      @result = "Sorry but #{word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{word} is a valid English word!"
    end
    # Un lien retour vers une nouvelle partie
    @new_game_link = new_path
  end

  private

  def valid_word_from_grid?(word, grid)
    return false if word.nil? || grid.nil?

    word_chars = word.upcase.chars
    grid_chars = grid.upcase.chars
    word_chars.all? { |char| word_chars.count(char) <= grid_chars.count(char) }
  end

  def english_word?(word)
    response = Net::HTTP.get_response(URI("https://dictionary.lewagon.com/autocomplete/:stem"))
    response.is_a?(Net::HTTPSuccess)
  end
end
