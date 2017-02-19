# reddit-ios-app
Reddit iOS App is a simple Top Reddits viewer. It is implemented in Swift 3 with just native components, without using any third-party library. It is implemented following object-oriented design good practices and patterns, like Dependency Injection (DI), Model-View-Presenter (MVP), Unit Testing and Service Testing. Test-Driven Development (TDD) process was followed to implement List Reddits Presenter features.

## Features
- Get Top Reddits from API using URLSession and GCD.
- List Top Reddits with thumbnails (implemented using MVP and DI patterns).
- Support for different device resolutions and orientation.
- Pull to refresh Reddits.
- Load more Reddits when reaching end of list.
- Display Reddit details (only for reddits with images in PNG and JPG format).
- Save Reddit image into photo library.
- Preserve application state.
- Unit tests for List Reddits Presenter.
- Service tests for Reddit Service Adapter.

## Screenshots

### Top Reddits Screen
![Top Reddits Screen](https://github.com/marcelobusico/reddit-ios-app/blob/master/Screenshots/RedditsList.png)

### Reddit Details Screen
![Reddit Details Screen](https://github.com/marcelobusico/reddit-ios-app/blob/master/Screenshots/RedditDetails.png)

### Unit Tests & Service Tests
![Unit Tests & Service Tests](https://github.com/marcelobusico/reddit-ios-app/blob/master/Screenshots/Tests.png)
