# CCEE Tech Masters

This application was developed for the Carolina Center for Educational Excellence.

The purpose of this app is to encourage student engagement in the tools and technologies at the CCEE by providing a competitive multiplayer approach.

As players learn about new technologies and complete related Challenges they earn xp and level up their character. The top 5 users are displayed on a leaderboard. Players also earn badges depending on the challenges they complete which can earn real life badges from the CCEE badge maker.


Architecture notes:

The actual workspace for this project is nested within the CCEETech folder (so don't try to open it with the top level workspace). This is due to a file organization mistake and has no effect on actual deployment.

This app uses Google Firebase for user authentication and data storage. This is not meant to be open source and we are providing the api key in the source code in good faith. If we notice any abuse in regards to our database usage we will make the code private and report you.

Class descriptions:

AppDelegate: handles user authentication state. Sends user to HomeViewController if logged in successfully. If user auth changes to logged out, sends user to MenuViewController (login/signup screen). Note: this is a hack and probably not the ideal way to handle auth according to our advisor but it works as far as we can tell.

Challenge1QuizViewController: handles the quiz at the end of Challenge 1. Awards score if the player doesn't have 1000 xp.

Challenge1ViewController: handles AR and video screen after clicking on button in Challenge 1. Awards score when the correct image is scanned.

Challenge2ViewController: handles quiz drag and drop, appends color codes to list that is sent to Quiz class to check for correct answer. Awards score.

Challenge3ViewController: same as Challenge2ViewController except has an additional clear function to clear the user inputs.

Challenge4ViewController: same as previous.

CustomChallengesViewController: meant to be utilized by instructors to add score for real-life challenges.

GoogleService-Info.plist - used for connecting to Google Firebase

Other view controllers have more info in their comments.
