# Alfred Workflow - Project Launcher

This is an Alfred Workflow which launches a number of applications (commands) related to a project. Project Launcher was born out of a development background (i.e. launching development projects), but really it can be used for anything where you have a number of tasks that need to be executed in order consistently.

## Why use Project Launcher
Let's say you are developing a website. Typically you would launch Visual Studio Code, MAMP and a browser manually. Then you would need to open the correct folder within Visual Studio Code and browser your local dev site. This is boring, and time wasting.

With Project Launcher, just create a project in the project.json file with all of the commands that will launch your workflow. Then just use Project Launcher in Alfred to execute all of these for your project - all automated, ready for you to code. life changed!

You don't need to just launch applications, it could be used for anything really, even other scripts.

## Installation
TODO: Need to add installation instructions here. Will need to package the workflow first. Should have a release directory and a src directory in the project.

## Adding a new project
To add a new project, do the following:

1. Copy the project-example.json file and name it project.json
2. Replace each project with the details of each project and the commands you wish to execute.
3. As a tip, to ensure each command will run successfully, test them out individually in a terminal windows first.
4. Ensure you follow the guidelines documented below, otherwise you will have issues displaying and executing your projects.
5. Save amd enjoy.

## JSON Project Guidelines
To be sucessful in creating your own projects, make sure you adhere to the following guidelines. If you have any issues with your projects, double check these:

- Project keys must be unique (e.g. `p1`, `p2`).
- Project keys must be in the format of `px` where `x` is a unique number.
- Project names must not contain spaces. Instead of spaces use a `-`.
- Project icons can be set to any icon within the `icons8` directory. Choose your favourite.
- Your JSON needs to be valid, use [JSON Formatter & Validator](https://jsonformatter.curiousconcept.com/) to test its validity.

## Command Guidelines
To ensure your commands run successfully, follow these guidelines:

- Commands that contain spaces in the path must be encased in single quotes `''`
- You cannot escape spaces or any other character in your commands (i.e. `\ `) as you normally would in a terminal window. This is very important, especially if copying a command from the terminal
- Some applications (e.g. MAMP) steal the context of the terminal which prevents other commands to run until they are closed. To solve this, run these in background mode by appending ` &>/dev/null &` to your command
- Before any commands are executed Alfred will change to your project's directory path (i.e. `cd <project-path>`). This makes it easier in launching commands that need to open that directory. For example, to open your project's directory in a Finder window simply use `/usr/bin/open .`. The `.` represents the current directory, which already is your project's directory.

## Other Considerations / Future Improvements
- Currently Project Launcher does not check if an application is already open, which is an issue for certain apps.