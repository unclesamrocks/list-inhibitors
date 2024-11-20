#!/bin/bash

# Function to get inhibitors
get_inhibitors() {
  dbus-send --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.GetInhibitors
}

# Function to check an inhibitor's application ID
check_inhibitor() {
  local id="$1"
  dbus-send --print-reply --dest=org.gnome.SessionManager "/org/gnome/SessionManager/$id" org.gnome.SessionManager.Inhibitor.GetAppId
}

# Main function
main() {
  # Get the output of inhibitors
  cmd_out=$(get_inhibitors)

  # Array to hold application IDs
  inhibitors=()

  # Extract inhibitors using regex and iterate over them
  while read -r match; do
    app_id_output=$(check_inhibitor "$match")
    
    # Extract the application ID using regex
    app_id=$(echo "$app_id_output" | grep -oP '(?<=")[^"]+(?=")')
    
    # If an app ID is found, add it to the array
    if [[ -n "$app_id" ]]; then
      inhibitors+=("$app_id")
    fi
  done < <(echo "$cmd_out" | grep -oP 'Inhibitor\d+')

  # Print the collected application IDs
  printf "%s\n" "${inhibitors[@]}"
}

# Execute main function and handle errors
main || {
  echo "An error occurred."
  exit 1
}
