# FFEUD

## Why
I always thought about family feud being some kind of niche TV show where two families compete to win a prize.
One day I decided to end this ignorance and watch a few clips. There were families but I saw some discussions that shouldn't take place on-air.
Flabbergasted with this finding I took a look at the core concept of this game. Two groups compete while individuals in groups cooperate while doing so.

I remembered the one concept in my currently failed TEYL class about gamified teaching. Currently there are few games on wordwall from lucky wheel to popping a bunch of balloons into a vagon.
But they seemed a bit fabricated. Not to insult our own TV production (Though I do think it's headed in a horrendous path) we do have a clone of it, PG of course. So I thought I might had a chance to
establish this sort of game without students feeling too alienated. So here you go, Classroom Feud.


## Screenshots
To remove clutter I didn't embed them into this document directly. You can navigate into assets folder if you would like to see some screenshots.


## How do I use?

### Using pre-packaged binaries
Head over to releases and grab the suitable binaries for your operating system if available. Currently I run linux so there should be Linux and android executables.
### Running directly from source
The app is written using flutter. A great UI library. After installing flutter for your OS, Navigate either into familyfeud or familyfeudbtn directory inside a terminal and run `flutter run`. This will launch the app inside debug mode. Alternatively you can run `flutter build` to build for your own device *ahem* windows *ahem* and `flutter build apk` to build for your android device.

After running one of these steps, run the familyfeud executable on your machine and run buttons on your designated phones. Input the IP address shown on the server machine, give a role to the phone and hit connect. Rest is up to you.

## Bugs, horrendous design choices and malfunctions

There are a few things for you to keep an eye out before using this in a real classroom environment
* Broken connections are not handled at all
* HARVEY (Host) mode for familyfeudbtn will not fit in your screen if viewed in potrait mode.
* There are three teams instead of two and each button has to run on an individual phone.
    I have two phones to spare, and I can install the button as a separate app on the host phone as well so... 
* Input textbox will not disappear completely after receiving input from Host device
    This is intentional as to not interrupt the flow in an event where host device disconnects
* Popularity scores for each answer means nothing, it's not counted
    While preparing a lesson plan in turkey we have very limited allocated time. If you were to use this app during your activities I'll guarantee at least 4 of the 7 minutes allocated for the activity will be spent explaining what this is. During such limited time I'm sure it will be "who won" rather than "who had biggest score"
* Game automatically begins once you connect both RED and Host buttons
    Normally I thought about starting the game once all clients were connected but some of us don't have a random phone gathering dust in the shelves.

So, from one sleep deprived teacher to another. Hope this helps you bring more color into your lessons.