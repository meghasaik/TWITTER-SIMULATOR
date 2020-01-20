defmodule DosProject4 do
  @moduledoc """
  Documentation for DosProject4.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DosProject4.hello()
      :world

  """
  def get_mention_info(tweet_string) do
    mention = Regex.scan(~r/@[a-z0-9A-Z_]*/, tweet_string) |> List.flatten
    
    {tweet_string, mention}
  end
  def get_hashtag_info(tweet_string) do
    hashtag = Regex.scan(~r/#[a-z0-9A-Z_]*/, tweet_string) |> List.flatten
    
    {tweet_string , hashtag}
  end
  @text 
  [ "Sword&Shield is awesome", "DOS is great", "Kamehamehaa!!!", "Borderlands3", "Crypto" ]
  @hash [ 
    "#pokemon", "#dos", "#bitcoin", "#uf", "#india" 
    ]
  def getting_tweet(user) do
  #  tweet = Enum.take(@text, 3) |> Enum.take_random(1)
    tweet= ["Tweeting"]
    #hashtag = Enum.take(@hash, 5) |> Enum.take_random(1)
    hashtag = Enum.take_random(@hash, 1) 
    mention = Enum.take_random(user, 1)
    tweet_text = tweet ++ hashtag ++ mention
    Enum.reduce(tweet_text, fn(x, acc) -> acc <> " " <> x end) <> "."
 end
 def reduce_query_mentioned(tweets) do
   if tweets != [] do
     Enum.reduce( tweets , fn(x, acc) -> acc <> "\n" <> x end) <> "\n"
   else
     ""
   end
 end
 def reduce_query_hashtags(tweets) do
   if tweets != [] do
     Enum.reduce( tweets , fn(x, acc) -> acc <> "\n" <> x end) <> "\n"
   else
     ""
   end
 end
end
