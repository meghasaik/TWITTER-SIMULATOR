defmodule Twitter_Client_Test do
  use ExUnit.Case
  test "Register User test" do
    Twitter_Server.start_link()
    user = "@user1"
    #start a client
    {_, pid} = Twitter_Client.start_link(user)
    #register the client
    GenServer.call(pid, :register)
    # Use Server backend API to check if user is registered
    assert Service_Provider.getId(user) == pid
  end
  test "user deletion test" do
    Twitter_Server.start_link()
    user = "@user1"
    #start a client
    {_, pid} = Twitter_Client.start_link(user)
    #register the client
    GenServer.call(pid, :register)
    # Use Server backend API to check if user is registered
    assert Service_Provider.getId(user) == pid
    # Delete the user
    GenServer.call(pid, :user_deletion)
    # Use Server backend API to check if user is deleted
    assert Service_Provider.getId(user) == []
  end
  test "User login test" do
    Twitter_Server.start_link()
    user = "@user1"
    #start a client
    {_, pid} = Twitter_Client.start_link(user)
    #register the client
    GenServer.call(pid, :register)
    #login the user
    GenServer.call(pid, :login)
    # Use Server backend API to check if user is logged in
    assert Service_Provider.is_user_logged(user) == true
  end
  test "User logout test" do
    Twitter_Server.start_link()
    user = "@user1"
    #start a client
    {_, pid} = Twitter_Client.start_link(user)
    #register the client
    GenServer.call(pid, :register)
    #login the user
    GenServer.call(pid, :login)
    # Use Server backend API to check if user is logged in
      assert Service_Provider.is_user_logged(user) == true
    #logout the user
    GenServer.call(pid, :logout)
    # Use Server backend API to check if user is logged out
    assert Service_Provider.is_user_logged(user) == false
  end
  test "Tweet sent test" do
    Twitter_Server.start_link()
    user = "@user1"
    #start a client
    {_, pid} = Twitter_Client.start_link(user)
    #register the client
    GenServer.call(pid, :register)
    #login the user
    GenServer.call(pid, :login)
    #send tweet from user
    tweet = "Helllo @user2 #dos"
    GenServer.cast(pid, {:usertweet, tweet})
    :timer.sleep(500) 
    assert Service_Provider.get_usertweet(user) == [tweet]
  end
  
  test "user subcribers test" do
    Twitter_Server.start_link()
    user1 = "@user1"
    user2 = "@user2"
    users = [user1, user2]
    clients = Enum.map(users, fn user ->
      pid = Twitter_Client.start_link(user) |> elem(1)
      GenServer.call(pid, :register)
      {user, pid}
     end)
     Enum.each(clients, fn {_user, pid} ->
       GenServer.call(pid, :login)
     end)
    {_, pid1} = Enum.at(clients,0)
    {_, pid2} = Enum.at(clients,1)
    GenServer.call(pid1, {:followers, [user2]})
    # Use Server backend API to check if subscribe is successful
    assert Service_Provider.followers_to_user(user2) == [user1]
    assert Service_Provider.get_user_subcribers(user1) == [user2]
  end

  test "Query Mentions test" do
    Twitter_Server.start_link()
    user1 = "@user1"
    user2 = "@user2"
    users = [user1, user2]
    clients = Enum.map(users, fn user ->
      pid = Twitter_Client.start_link(user) |> elem(1)
      GenServer.call(pid, :register)
      {user, pid}
     end)
     Enum.each(clients, fn {_user, pid} ->
       GenServer.call(pid, :login)
     end)
    {_, pid1} = Enum.at(clients,0)
    {_, pid2} = Enum.at(clients,1)
    #user 1 subscribes to user 2 and user 3
    GenServer.call(pid1, {:followers, [user2]})
    #send tweet from user 2
    tweet1 = "Hello @sere #dos"
    tweet2 = "Go gators #ring"
    GenServer.cast(pid2, {:usertweet, tweet1})
    :timer.sleep(500) #wait for some time as tweet is async call
    # Query tweets from client
    tweets = GenServer.call(pid1, :getmentions)
    assert tweets == [tweet1]
  end


end