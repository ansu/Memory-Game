# Memory-Game:
###IOS:  A simple memory game app written in Swift.

![Memory Game](https://github.com/ansu/Memory-Game/blob/master/Screenshot.png)

It is a simple memory game where by default 9 images will be shown to the user for 10 seconds. These settings are configurable and can easily be changed through AppConstants file. User has to remember these images in given time. Once 10 seconds pass by, the images will get flipped.  

After that, at bottom one of the 9 images will be presented and user has to identify the correct image on the grid. The game ends when user will identify all the 9 correct images.


# Architecture

### MVVMR = MVVM + VIPER-Router  

1: Mainly uses the structure from MVVM.  
2: Introduces a component responsible for routing, similar to VIPER.  
3: Aims to keep everything simple, but modular and reusable.  
 


## Libary Used

1: **Kingfisher:** Image Caching.  
2: **Toast:** To show messages.  
3: **SwiftLint:** For enforcing swift rules.  



## Key-Things

1: **Network Protocol:** This project has two providers for Network protocol. One for live API Data and other for Mock.  
2: **Navigations:** This class takes care routing and all dependecies which are required for any controller or models.  
3: GameVC class takes the data from GameViewModelling. All business logic lies inside GameViewModelling class.  


