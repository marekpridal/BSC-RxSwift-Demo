# Task

Implement simple native iPhone application for management of personal notes. The application should be ready to build and run right after clone of your repository.

The application should integrate API, which is ready to use at URL: <a href="http://private-9aad-note10.apiary-mock.com/">http://private-9aad-note10.apiary-mock.com/</a>

### Methods
`GET /notes`

`GET /notes/{id}`

`POST /notes`

`PUT /notes/{id}`

`DELETE /notes/{id}`


### Functional requirements
Main page with list of notes should be opened right after installation/opening of the application.
User can display, edit, delete and create new note.


### Non-functional requirements
You are the GUI designer, feel free to do whatever you want, but follow platform conventions and standards.
The application should be created from standard and native components.
Swift is preferred way. Objective-C is simply OK.
The project has to contain at least one unit test.



## Instalation
1. Use `git clone` for getting repository
2. Use command line to navigate into root directory of project
3. Run `pod install` in terminal
4. Open `BSC.xcworkspace` file
5. Run project using `CMD+R`

## Unit tests
1. After successful project setup, go to `BSCTests` group
2. In `NotesModelTests.swift` file find test method `testAddNewNote` and run it by clicking on symbol of diamond
