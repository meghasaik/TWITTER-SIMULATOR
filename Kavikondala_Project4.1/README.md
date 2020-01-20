# DosProject4

								COP5615 Fall 2019
       								TWITTER SIMULATOR

Team Member:
MEGHA SAI KAVIKONDALA UFID: 4754-3974


Architecture:
The TWITTER SIMULATOR WILL HAVE: SIMULATE, SERVER, CLIENT, SERVICE.
1)SIMULATE- This will take the arguements from the user and it will initialise the SERVER and CLIENT component. Here, it will initialise the various componenets of the Twitter Engine.
2)SERVER- This will take the various calls from the client regarding the functionalities and it will initialise the SERVICE component.
3)CLIENT- This will call the server component for the functionalities.
4)SERVICE- This will initialise the tables and will retrieve and put the values into the table. 
What’s working:
1.) Register the user
2.) Delete the user
3.) Login the user
4.) Logout the user
5.) Subscribers to the user 
6.) Send tweets to followers having mentions and hashtags
7.) Getting the tweets having the mentions
8.) Put all the tweets, hashtags and mentions in tables 

What's working partially:
1.) Getting the tweets with hashtags
What's not implemented:
1.) Retweeting



How to run:
mix run --no-halt proj4_1.exs numofusers numoftweets


The workflow (This is sequential):
1.) The simulator process (Simualator_Assign.ex) starts the server process first, then it create the clients.
2.) Clients are registered with the server and logged in.
3.) The clients are given subscribers randomly.
4.) After subscribing, each client sends a predetermined number of tweets(numoftweets given from the command line). Tweets are sent asynchronously. Simulator waits for 1 sec for tweets to be received.
5.) Each client queries tweets in syncronous way. (All types of query request - mentions, hashtags, subscribed tweets are right now done in syncronous.)
6.) Each client queries tweets in which they are mentioned(syncronous).
7.) Each client queries tweets with a certain hashtag(syncronous).
8.) logoff users
9.) delete users



Test cases(17 total):
There are two files with test cases:
1.) service_test.exs - 
This file contains test cases to test the backend and ETS table operations.  
     a.) table creation test - to check if tables are getting created
     b.) extract mention test - to extract mentions from tweets
     c.) extract hashtag test - to extract hashtags from tweets
     d.) registration of user test - to check if user has been added in usertable table
     e.) login user test - to check whether user is present in users_logged_in table
     f.) logoff user test- to check whether user is absent in users_logged_in table
     g.) write tweet test - to check if tweets are saved in the tweet table
     h.) subscribe tweets test - to check if subscribers are stored in the table for each user
     i.) tweets with mentions test - to fetch mentioned tweets from the mention table
     j.) tweets with hashtags test - to fetch tweets with a certain hashtag from hashtags table
2.) client_test.exs -
This file contains test cases to test the client. In these tests, requests are sent from the client and the results are compared with backend functions
    a.) Register User - register a client and check backend if the user has been added
    b.) Delete User - send request from client to delete user and check backend if user has been deleted
    c.) Login User - to check whether client is getting logged in
    d.) Logout User - to check whether client has been logged out
    e.) Send Tweet - to check if a client tweet has been sent and stored
    f.) Subscribe to User - to check if ac client has been subscribed to other users
    g.) Query Mentions - to check if a query for current user’s mentions gives the correct results.
    
    