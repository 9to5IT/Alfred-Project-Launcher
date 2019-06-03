# Alfred Workflow - Project Launcher

This is an [Alfred Workflow](https://www.alfredapp.com/) (Alfred 3 & Alfred 4) that saves you time by launching all apps, folders, files, etc that relate to a specific project. A project can be a dev project, design project or literally anything - e.g. tax time. 

Whenever you need to launch multiple things for a specific task, create a project and use Project Launcher instead!

**Note:** You must have `jq` installed in `/usr/local/bin` for this to workflow to run. `jq` is a command-line JSON processor. For more information visit the [jq website](https://stedolan.github.io/jq/). For more information, see the installation section below.

## How it works

![Alfred Project Launcher](/docs/alfred-project-launcher.gif)

## Why use Project Launcher

Let's say you are developing a website. Typically you would launch Visual Studio Code, MAMP and a browser manually. Then you would need to open the correct folder within Visual Studio Code and browser your local dev site. This is boring, and time wasting.

With Project Launcher, just create a project in the project.json file with all of the commands that will launch your workflow. Then just use Project Launcher in Alfred to execute all of these for your project - all automated, ready for you to code. Life changed!

You don't need to just launch applications, it could be used for anything really, even other scripts. The possibilities are endless.

## Installation

#### JQ install

As mention above, this worflow requires `jq` to be installed in `/usr/local/bin`. The easiest way to do this is using [homebrew](https://brew.sh/), which is a package manager for MacOS.

1. Ensure homebrew is installed - to do this, follow the instructions on the [homebrew website](https://brew.sh/)
2. Now that you have homebrew installed, launch terminal and run the following command `brew install jq`
3. Wait for jq to install
4. To validate it was installed in the correct location run `ls /usr/local/bin | grep jq`. If the words `jq` are returned then you know it has been installed. If not, jq is not installed in `/usr/local/bin`
5. It is very important you have `jq` installed before proceeding.

#### Alfred workflow

Next is the super easy part, installing the Project Launcher workflow in Alfred.

1. First you actually need Alfred installed. If you don't have this head over to the [Alfred website](https://www.alfredapp.com/).
2. Clone or downlod this repo. Alternatively right click this [this link](./Project%20Launcher.alfredworkflow) and select Save as.
3. Double click the `Project Launcher.alfredworkflow` file
4. This will automatically install the workflow in Alfred

## Usage

#### How to run Project Launcher

To use Alfred Project Launcher do the following:

1. Launch Alfred via your selected keyboard shortcut (mine is ⌘ + ␣)
2. Type the `plaunch` keyword and select Project Launcher from the list
3. Project Launcher will now read the projects.json file and will now retrieve a list of all your configured projects 
4. Select a project to launch and  `Enter`
5. Project Launcher will now execute all of the actions associated with the selected project
6. Enjoy

#### Adding a new project

To add a new project, do the following:

1. Open the Alfred Project Launcher workflow directory *(you can do this by right-clicking the workflow in Alfred and selecting Open in Finder)*
2. Open the `project.json` file in a text editor
3. Either edit the existing demo projects or create a new one by copying another project's json structure *(note: the file must contain valid json only otherwise Project Launcher will not work)*
4. Ensure your new project has a unique project id which does not contain any spaces (use the format `px` where `x` is a unique number)
5. As a tip, to ensure each command will run successfully, test them out individually in a terminal windows first.
6. Ensure you follow the guidelines documented below, otherwise you will have issues displaying and executing your projects.
7. Save and enjoy.

## Key Considerations & Guidelines

#### JSON Project Guidelines

To be sucessful in creating your own projects, make sure you adhere to the following guidelines. If you have any issues with your projects, double check these:

- Project keys must be unique (e.g. `p1`, `p2`).
- Project keys must be in the format of `px` where `x` is a unique number.
- Project names must not contain spaces. Instead of spaces use a `-`.
- Project icons can be set to any icon within the `icons8` directory. Choose your favourite.
- Your JSON needs to be valid, use [JSON Formatter & Validator](https://jsonformatter.curiousconcept.com/) to test its validity.

#### Command Guidelines

To ensure your commands run successfully, follow these guidelines:

- Commands that contain spaces in the path must be encased in single quotes `''`
- You cannot escape spaces or any other character in your commands (i.e. `\ `) as you normally would in a terminal window. This is very important, especially if copying a command from the terminal
- Some applications (e.g. MAMP) steal the context of the terminal which prevents other commands to run until they are closed. To solve this, run these in background mode by appending ` &>/dev/null &` to your command
- Before any commands are executed Alfred will change to your project's directory path (i.e. `cd <project-path>`). This makes it easier in launching commands that need to open that directory. For example, to open your project's directory in a Finder window simply use `/usr/bin/open .`. The `.` represents the current directory, which already is your project's directory.

## Future Improvements

 Here are some future improvements for Project Launcher. If you have any good ideas, suggest it in the comments:

- Currently Project Launcher does not check if an application is already open, which is an issue for certain apps.
- Project names cannot contain spaces - this can be fixed.

## Source Code

If you would like to make your own version all of the source code is available in the `src` directory.

## Alfred Version Support

This workflow has been tested successfully on Alfred 3 and Alfred 4.

## Special Mentions

All icons are from [icons8](https://icons8.com/) except for the Project Launcher icon, which I can't seem to find where I got that from - so thank you to whoever that was