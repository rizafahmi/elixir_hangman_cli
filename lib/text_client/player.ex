defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, Summary, State}
  
  def play(%State{ tally: %{ game_state: :won } }) do
    exit_with_message("You WON!")
  end
  
  def play(game = %State{ tally: %{ game_state: :lost } }) do
    exit_with_message("Sorry, you lost. The word was: #{Enum.join(game.game_service.letters, "")}")
  end
  
  def play(game = %State{ tally: %{ game_state: :good_guess } }) do
    continue_with_message(game, "Good guess!")
  end
  
  def play(game = %State{ tally: %{ game_state: :bad_guess } }) do
    continue_with_message(game, "Sorry, it isn't right.")
  end
  
  def play(game = %State{ tally: %{ game_state: :already_used } }) do
    continue_with_message(game, "You already used that letter")
  end

  def play(game) do
    continue(game)
  end


  defp continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end
  
  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end
  
  
  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
