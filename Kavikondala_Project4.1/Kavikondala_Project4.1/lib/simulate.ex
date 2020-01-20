defmodule Simulator_Assign do
  use GenServer 
  def main(numofClients, numofTweets) do
  #  args = System.argv()
    #parameters1= args |> Enum.at(0)
    #parameters2= args |> Enum.at(1)
    #numofClients= String.to_integer(parameters1) 
    #numofTweets= String.to_integer(parameters2) 
    Twitter_Server.start_link()
    IO.puts("Started")
  #  Twitter_Client.start_link()
    user = Enum.map(1..numofClients, fn(pos) -> "@userno" <> to_string(pos)end)
      client = Enum.map(user, fn username ->
        pid = Twitter_Client.start_link(username) |> elem(1)
      GenServer.call(pid, :register)
      {username, pid}
    end)
    login_function(client)
    subscribe_toUsers(client, numofClients, user)
    random_tweet(client, numofTweets, user)
    
  #  retweeting(client)
    :timer.sleep(1000)
    search_mentions(client)
    search_hashtag(client)
    logoff_function(client)
end
  def login_function(client) do
    Enum.each(client, fn {_username, pid} ->
      GenServer.call(pid, :login)
    end)
end
def subscribe_toUsers(client, numofClients, user) do
  Enum.each(client, fn {users, pid} ->
    followerslist = Enum.take_random(user, Enum.random(1..numofClients))
  
    followerslist = Enum.filter(followerslist, fn follow-> follow != user end)
  
    GenServer.call(pid, {:followers, followerslist})
  end)

end
def random_tweet(client, numofTweets, user) do
  Enum.each(client, fn {_user, uid} ->
    Enum.each(1..numofTweets, fn _x ->
    GenServer.cast(uid, {:usertweet, DosProject4.getting_tweet(user)}) end)
  end)
end
#def retweeting(client) do

  
#end
def search_mentions(client) do
  Enum.each(client, fn {_user, pid} ->
    GenServer.call(pid, :getmentions)
  end)
end

def search_hashtag(client) do
  Enum.each(client, fn {_user, pid} ->
  #  tag = [ "#pokemon", "#dos", "#bitcoin", "#uf", "#india" ]
  #hashtag = Enum.take_random(tag, 1) |> Enum.at(0)
    hashtag = "#dos"
    GenServer.call(pid, {:gethashtags, hashtag})
  end)
end
def logoff_function(client) do
    Enum.each(client, fn {user, pid} ->
      GenServer.call(pid, :logoff)
      GenServer.call(pid, :user_deletion)
    end)
  end 
end
