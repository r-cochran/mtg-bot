# mtg-bot

This project was built for a private slack group that has an active magic the gathering channel. We wanted a quick way to retrieve and share card information must like that found on the /r/magicTCG subreddit when making a post with [[cardName]].

Once you have the service up and running you can create a custom command line integration in slack by configuring a default one that points to your server with the command /mtg.

Once the request is processed the bot will make a post in the channel the message was invoked. It will display the image of the card searched, the search term used, and the sets that card has appeared in.

![](http://i.imgur.com/vwOtbWb.png)

If you want a specific card you can use quotes. If you search for Ezuri it will return Ezuri, Renegade leader every time. But if you wanted the precon commander you would have to search with "Ezuri, Claw of Progress".

Since magic cards can appear in many different sets you may sometimes want a certain art to be returned. By adding # and the set abbreviation behind the card name you can get the desired card. So Diabolic Tutor#KLD will return the Kaladesh version of the card.

Start up

`ruby mtg-bot.rb -p 8080`

Testing for local

```
curl localhost:8080/mtg-bot?text=ezuri

curl localhost:8080/mtg-bot?text=Diabolic%20Tutor%23kld

curl localhost:8080/mtg-bot?text=Diabolic%20Tutor%23KLD

curl localhost:8080/mtg-bot?text=help

curl localhost:8080/mtg-bot?text=set+list

curl localhost:8080/mtg-bot?text=set%20list

curl localhost:8080/mtg-bot?text=%22gerrard%22

curl localhost:8080/mtg-bot?text=ashling%20the%20pilgrim
```

response format

```
{
  "response_type":"in_channel",
  "text":"http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=194243&type=card\n search term: ezuri\n Releases: Scars of Mirrodin(SOM), Commander 2014(C14), Commander 2015(C15)",
  "attachments":[]
}
```
