# PokemonTeams
This is a Coding Challenge an app that will let you create Pokemon temas and enjoy sharing your teams with your friends.

# PokemonTeams 
This codebase supports only iOS platform minimum OS version iOS 14

Orientations
      Portrait
      
# Project setup
This project uses cocoapods and a podfile.lock cloning de repo and running pod install should do that being said is you can get the project to run feel free to leave a comment with you contact info and i can step and take a look.

# Firestore
While in the development process for this project i notice that cocoapods and firestore have some kind of weird behavior had to do pod deintegrate pod install a few times in order for cocoapods to install it.

# Architecture
In this project i tried to get a good separation of concerns using MVVM and the rule of dependency inversion  creatig a comunication flow as follows View -> ViewController -> View Model - > Data Provider Abstraction -> Provider implementation.

also i decided to use most of apple new features using libraries as **Combine** to manage asynchronous call in the app also manage event listener for most of the app UI. Also used **DiffableDataSource** apples new way of providing info to collection views and table views.

# ThirdParty
   * Firebase: is used to handle login as login provider.
   * Firestore: is used to store users and pokemon info.
   * Anchorage: is used to create layouts constraint.

# Screenshots or videos

Splash screen

https://user-images.githubusercontent.com/31734131/109508486-4ce90000-7a76-11eb-8331-bbf45de4ac0a.mov


Commets
-------

Due to time frame there are some TODOS in the app that are also important like (share teams with link, some loading indicator for most fo the apps request) and feedback in someplaces of the app but with a litle more work (time) this could be implemented.

Login

![Simulator Screen Shot - iPhone 8 - 2021-03-01 at 10 10 11](https://user-images.githubusercontent.com/31734131/109509495-51fa7f00-7a77-11eb-823b-aac3c9e7d040.png)

Register

![Simulator Screen Shot - iPhone 8 - 2021-03-01 at 10 12 50](https://user-images.githubusercontent.com/31734131/109509523-59218d00-7a77-11eb-9aa8-b4b0d894a591.png)


Copy Name functionality
https://user-images.githubusercontent.com/31734131/109509381-355e4700-7a77-11eb-892e-0f7683445fad.mov

# Functionality
   
   User Managment
   ----
   In this project we have a user management sistem that uses firebase as an auth provider with a login and register screen also our user persis in the app thought and implementation of a local keychain that uses user defaults to save the user and retrive it from any place in the app.
   
   List pokemos
   ----
   In this project you can click on a pokemon on home screen and will get in your clip board the name of said pokemon which is usefull while creating new teams due to the api size i could not find a way to load a list of pokemons by name (i think there is not) so i implemented this because the api won't responde with names that are a like it will only add a pokemon to a team if we insert the right name so this is very helpfull.
   
   Team Management
   -----
   This project have a team management that uses firebase and the pokemon api to get a list of teams from firebase and get information of said teams  from the pokemon api and present it in my teams tap also you can delete and edit teams using trailling swipe actions.
   
   ![Simulator Screen Shot - iPhone 8 - 2021-03-01 at 10 24 02](https://user-images.githubusercontent.com/31734131/109510375-4f4c5980-7a78-11eb-8337-042560da0991.png)
   
   

   
   






   




 
