defmodule Service_Provider_Test do
  use ExUnit.Case
  doctest Service_Provider
  
  test "table creation test" do
    Service_Provider.tables()

    assert :ets.whereis(:usertable) != :undefined
    assert :ets.whereis(:subscribers) != :undefined
    assert :ets.whereis(:tweet) != :undefined
    assert :ets.whereis(:hashtag) != :undefined
    assert :ets.whereis(:mention) != :undefined
    assert :ets.whereis(:subscribed_to) != :undefined
    assert :ets.whereis(:users_logged_in) != :undefined
  end

  test "registration of user test" do
    Service_Provider.tables()
    user = "@user1"
    Service_Provider.user_register(user, self())
    assert Service_Provider.getId(user) == self()
  end
  test "login user test" do
    user = "@user1"
    Service_Provider.user_register(user, self())
    assert Service_Provider.is_user_logged(user) == true
  end
  test "logoff user test" do
    user = "@user1"
    Twitter_Server.init(user)
    assert Service_Provider.is_user_logged(user) == true
    Service_Provider.user_remove(user)
    assert Service_Provider.is_user_logged(user) == false
  end
  test "write tweet test" do
    user = "@user1"
      Twitter_Server.init(user)
    tweet1 = "This is tweet #DOS @user2"
  Service_Provider.tweet_writing(tweet1, user)
    assert Service_Provider.get_usertweet(user) == [tweet1]
  end
  test "subscribe tweets test" do
    user = "@user1"
      Service_Provider.user_register(user, self())
    following = ["@user2"]
    Service_Provider.user_register("@user2", self())
    Service_Provider.followers_to_user(following, user)
    assert Service_Provider.get_user_subcribers(user) == following
  end
  test "tweets with mentions test" do
    user = "@user1"
      Twitter_Server.init(user)
    Service_Provider.user_register("@user2", self())
    following = ["@user3"]
    Service_Provider.followers_to_user(following, user)
    tweet1 = "hellooo #GOGATORS @user1"
    Service_Provider.tweet_writing(tweet1, user)
    tweets = Service_Provider.mentioned_tweets(user)
    assert  tweets == [tweet1,user]

  end

  test "tweets with hashtags test" do
    user = "@user1"
      Twitter_Server.init(user)
      Service_Provider.user_register("@user2", self())
      Service_Provider.user_register("@user3", self())
    tweet1 = "Hope #ggo #Dos @user1"
    tweet2 = "Hellloooo #GOGATORS"
    Service_Provider.tweet_writing(tweet1, "@user3")
    Service_Provider.tweet_writing(tweet2, "@user4")
    assert Service_Provider.hashtagged_tweets("#Dos") == [tweet1, tweet2]

  end
  test "extract mention test" do
    tweet = "Hello @ratchet @dexter @zero"
    {_, mentions} = DosProject4.get_mention_info(tweet)
    assert mentions == ["@ratchet", "@zero", "@dexter" ]
  end
  test "extract hashtag test" do
    tweet = "Hello #trends #sarileru #dos"
    {_, hash} = DosProject4.get_hashtag_info(tweet)
    assert hash == ["#trends", "#sarileru", "#dos" ]
  end

  end
