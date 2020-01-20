defmodule Twitter_Server do
  use GenServer
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :server )
  end
  def init(state) do
  #  :ets.new(:usertable, [:set, :public, :named_table])
  #  :ets.new(:tweettable, [:set, :public, :named_table])
  #  :ets.new(:following, [:set, :public, :named_table])
  #  :ets.new(:followers, [:set, :public, :named_table])
     Service_Provider.tables()
     IO.puts("tables created")
     {:ok, state}
end 
 #def registration({:register, username}, pid) do
  # Service_Provider.user_register(pid, username)
#   {:reply, :registered, state}
 #end
def handle_call({:register, username, _pid}, from, state) do
  Service_Provider.user_register(username, from)
  IO.puts("user registered" <> username)
  {:reply, :registered, state}
end
def handle_call({:user_deletion, user_id}, _from, state) do
  Service_Provider.user_remove(user_id)
  IO.puts("user removed" <> user_id)
  {:reply, :deleted, state}
end
def handle_call({:login, userID}, _from, state) do
#  cID=Service_Provider.getID(userID)
  Service_Provider.user_log(userID)
  IO.puts("user logged " <> userID)
  {:reply, :loggedIn, state}
end
def handle_call({:followers, followerslist, user_id}, _from, state) do
     followerslisticle = Service_Provider.followers_to_user( followerslist, user_id)
       IO.puts("subbbss...")
  {:reply, {:follow, followerslisticle}, state}
end
def handle_cast({:usertweet, {user_id, tweettext}}, state) do
  IO.puts(" entered tweets.....")
  Service_Provider.tweet_writing(tweettext, user_id)

  Service_Provider.get_user_subcribers(user_id) |> Enum.each(fn subscribers ->
    pid = Service_Provider.getId(subscribers)
    if Service_Provider.is_user_logged(subscribers) == true do
      #GenServer.cast(pid, {:tweetsent, user_id, tweettext})
      IO.puts("sending tweets.....")
      send pid, {:tweetsub, user_id, tweettext}
    end
  end)
  
  {_tweet, mentions} = DosProject4.get_mention_info(tweettext)
  Enum.each(mentions, fn user_mention ->
    pid = Service_Provider.getId(user_mention)
    if Service_Provider.is_user_logged(user_mention) == true do
      GenServer.cast(pid, {:mentionsent, user_id, tweettext})
    end
  end)
    IO.puts("tweets")
  {:noreply, state}
  
end
def handle_call({:getmentions, user_id}, _from, state) do
  
  tweets = Service_Provider.mentioned_tweets(user_id)

  {:reply, tweets, state}
end
def handle_call({:gethashtags, hashtag, user}, _from, state) do
  tweets = Service_Provider.hashtagged_tweets(hashtag)

  {:reply, tweets, state}
end
def handle_call({:logout, userID}, _from, state) do
    IO.puts("user out")
  Service_Provider.user_log_off(userID)
  {:reply, :loggedOut, state}
end

end