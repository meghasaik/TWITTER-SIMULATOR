defmodule Twitter_Client do
use GenServer
  def start_link(userID) do
    GenServer.start_link(__MODULE__, userID)
  end
  def init(userID) do
  #  registration(userID)
  
  {:ok, userID}
  
  end
  def handle_call(:register, _from, user_id) do
    reply = GenServer.call(:server, {:register, user_id, self()})
  #  IO.inspect("Registered user " <> user_id)
    {:reply, reply, user_id}
  end
  def handle_call(:user_deletion, _from, user_id) do
    reply = GenServer.call(:server, {:user_deletion, user_id})
  #  IO.inspect("Deleted user " <> user_id)
    {:reply, reply, user_id}
  end
  def handle_call(:login, _from, user_id) do
    reply = GenServer.call(:server, {:login, user_id})
  #  IO.inspect("user logged in- " <> user_id)
    {:reply, reply, user_id}
  end
  def handle_call(:logout, _from, user_id) do
    reply = GenServer.call(:server, {:logout, user_id})
  #  IO.inpect("user logged out- " <> user_id)
    {:reply, reply, user_id}
  end
  def handle_call({:followers, followerslist}, _from, user_id) do
    #{:followers, followerslist} = GenServer.call(:server, {:followers, user_id, users_to_subscribe})
    {:follow, followerslisticle} = GenServer.call(:server, {:followers, followerslist, user_id})
    
    IO.inspect([user_id <> "user followers"] ++ followerslisticle)
    #IO.inspect([user_id <> " subscribed to users "] ++ users_subscribed)
    {:reply, followerslisticle, user_id}
  end
  def handle_cast({:usertweet, tweettext}, user_id) do
    GenServer.cast(:server, {:usertweet, {user_id, tweettext}})
    {:noreply, user_id}
  end

  def handle_call(:getmentions, _from, user_id) do
    tweets = GenServer.call(:server, {:getmentions, user_id})
    
    IO.puts("The mentions of #{user_id}: " <> DosProject4.reduce_query_mentioned(tweets))
    #IO.puts("Querying mentions of #{user_id}:\n" <>
    #        Utils.query_mentions_prettify(tweets))
    {:reply, tweets, user_id}
  end
  
  def handle_call({:gethashtags, hashtag}, _from, user_id) do
    tweet = GenServer.call(:server, {:gethashtags, hashtag, user_id})
      IO.puts("The #{user_id} for hashtag #{hashtag}: " <> DosProject4.reduce_query_hashtags(tweet))
    #CounterService.update_counter(:incrementQueryHashtagsCount)
    #IO.puts("#{user_id} querying hashtag #{hashtag}:\n" <>
    #        Utils.query_hashtags_prettify(tweets))
    {:reply, tweet, user_id}
  end
  
  
  def handle_cast({:tweetsent, from, tweettext}, user_id) do
    IO.puts(user_id <> "> tweet from " <> from <> " \"" <> tweettext <> "\"")
  #  CounterService.update_counter(:incrementReceivedTweetsCount)
    {:noreply, user_id}
  end

  def handle_cast({:mentionsent, from, tweettext}, user_id) do
    IO.puts(user_id <> ">  mention from " <> from <> " \"" <> tweettext <> "\"")
    {:noreply, user_id}
  end
#def registration(userID) do
#  GenServer.call({:server}, {:register, userID})
#  {:reply, userID}
#end




end