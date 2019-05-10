#!/bin/bash
#
# .SYNOPSIS
#   Alfred workflow - project launcher
#
# .DESCRIPTION
#   Project Manager is an Alfred Workflow that will be used to launch all of the
#   required functionality for dev projects. This superceeds the web dev workflow
#   because each project is contained within a JSON file and you can run whatever apps
#   you require, not just web dev standards apps.
#
# .PARAMETER $1 = projectID
#   Optional. If specified, will run in Execute Mode which will execute the commands specified
#   in the selected project's JSON. If not specified or can't find the project specified, then
#   will run in List Mode which will return a full list of projects from the JSON file for
#   you to select.
#
# .INPUTS
#   projects.json
#
# .OUTPUTS Alfred Debugger
#   Alfred Script Filter JSON
#
# .NOTES
#   Version:        1.0
#   Author:         Luca Sturlese
#   Creation Date:  25.04.2019
#   Purpose/Change: Initial script development
#
#   Version:        1.1
#   Author:         Luca Sturlese
#   Creation Date:  05.05.2019
#   Purpose/Change: Added icon selection in project JSON
#
#   Version:        1.2
#   Author:         Luca Sturlese
#   Creation Date:  06.05.2019
#   Purpose/Change: Fixed issue with executing commands with spaces
#
#   Version:        1.3
#   Author:         Luca Sturlese
#   Creation Date:  06.05.2019
#   Purpose/Change: Updated documentation

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

JSONFile=$( cat "./projects.json" )     # File path of project's JSON file

#-----------------------------------------------------------[Functions]------------------------------------------------------------

#=========================================
# Check-PreReqs
#
# Synopsis: Checks to ensure all required
# software is installed before executing
#
# Parameters:
#   $1 = Command to check for
#=========================================
function Check-PreReqs {
  command -v $1 >/dev/null 2>&1 || {
    echo "This script requires $1 but it isn't installed. Aborting."  1>&2
    exit 1
  }
}

#=========================================
# ListMode
#
# Synopsis: Gets a list of projects from project.json file which is
#           returned to Alfred via the ReturnAlfredJSON function.
#
# Parameters:
#   $1 = None
#=========================================
function ListMode {
  echo "ListMode function.." 1>&2

  # Get project name and path from JSON
  resultsString=""
  results=$( echo $JSONFile | /usr/local/bin/jq -r 'to_entries[] | [.key, .value.name, .value.path, .value.icon] | tostring' )

  # Store results in a string
  while IFS= read -r i ; do
    resultsString+="$i"
  done < <( echo "$results" )

  # Split resultsString into an array with delimiter as ][
  delimiter=']['
  s=$resultsString$delimiter
  resultsArray=();
  while [[ $s ]]; do
    resultsArray+=( "${s%%"$delimiter"*}" );
    s=${s#*"$delimiter"};
  done;

  # Declare resultsArray & projects array
  declare -p resultsArray > /dev/null 2>&1
  projects=()

  # Enumerate resultsArray array and clean-up string and build project array
  for item in ${resultsArray[*]}; do
    # Remove [ from beginning and ] from end
    project=$( echo $item | sed 's/\[//' | sed 's/]$//' )
    
    # Remove " characters
    project=$( echo $project | sed 's/\"//g' )
    
    # Add " character around each array element
    project="\"$project\""

    # Add line to projects array
    projects+=( $project )
  done

  # Call ReturnAlfredJSON function with list of projects
  ReturnAlfredJSON $projects
}

#=========================================
# ReturnAlfredJSON
#
# Synopsis: Returns script filter JSON to Alfred in order to be able to
#           display a full list of projects for the user to select.
#
# Parameters:
#   $1 = projects array with the element format of: name,path
#=========================================
function ReturnAlfredJSON {
  echo "ReturnAlfredJSON function.." 1>&2

  projects=$1

  # Add pre JSON data
  jsonOutput+="{\"items\": ["

  # Enumerate projects and build json
  for ((i = 0; i < ${#projects[*]}; i++)) do
    # Remove " characters
    project=$( echo ${projects[$i]} | sed 's/\"//g' )
    
    projectID="$(cut -d',' -f1 <<<"$project")"
    projectName="$(cut -d',' -f2 <<<"$project")"
    projectPath="$(cut -d',' -f3 <<<"$project")"
    projectIcon="$(cut -d',' -f4 <<<"$project")"

    jsonProject="{ \"uid\": \"$projectID\", \"title\": \"$projectName\", \"subtitle\": \"$projectPath\", \"arg\": \"$projectID\", \"icon\": { \"path\": \"$projectIcon\" } },"
    jsonOutput+=$jsonProject
  done

  # Remove comma from last json item
  jsonOutput=${jsonOutput%?}

  # Add post JSON data
  jsonOutput+="]}"

  # Return JSON to Alfred
cat << EOB
$jsonOutput
EOB
}

#=========================================
# ExecuteMode
#
# Synopsis: Gets the commands of the projectID passed as a parameter and then
#           executes each command sequentially.
#
# Parameters:
#   $1 = project name to execute
#=========================================
function ExecuteMode {
  echo "ExecuteMode function.." 1>&2
  projectID=$1

  # Find project based on specified name
  project=$( echo $JSONFile | /usr/local/bin/jq -r .$projectID )

  # Get project details required to execute commands (i.e. path and commands)
  projectPath=$( echo $project | /usr/local/bin/jq -r .path )
  commands=$( echo $project | /usr/local/bin/jq .commands[] )

  # --- START COMMAND EXECUTION ---
  cd $projectPath     # change directory to project path in order to execute commands

  echo "$commands" | while IFS= read -r item ; do
    # Remove [ from beginning and ] from end
    cmd=$( echo $item | sed 's/\"//' | sed 's/"$//' )

    # Execute each command
    eval $cmd
  done    
  # --- END COMMAND EXECUTION ---
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Check pre-reqs are installed on machine
Check-PreReqs /usr/local/bin/jq

# Check arguments: No more than 1 argument
if [ "$#" -gt 1 ]; then
  echo "Too many arguments supplied. Aborting" 1>&2
  exit 1
fi

# Check arguments: Argument passed or not
if [ "$1" == '' ]; then
  ListMode
else
  ExecuteMode $1
fi