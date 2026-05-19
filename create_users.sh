#!/bin/bash
if [ "$EUID" -ne 0 ];   then
  echo "ERROR: Script not in root."
  exit 1
fi

if [ "$#" -eq 0 ]; then
  echo "ERROR:Add atleast one user."
  exit 1
fi

for user in "$@"; do
  useradd -m "$user"
  echo "USER '$user' created."
  home_dir="/home/$user"
  mkdir -p "$home_dir/Documents"
  mkdir -p "$home_dir/Downloads"
  mkdir -p "$home_dir/Work"
  chmod 700 "$home_dir/Documents"
  chmod 700 "$home_dir/Downloads"
  chmod 700 "$home_dir/Work"
  chown -R "$user":"$user" "$home_dir"
done

for user in "$@"; do
  home_dir="/home/$user"
  welcome_file="$home_dir/welcome.txt"
  echo "Välkommen $user" > "$welcome_file"
  echo "" >> "$welcome_file"
  echo "Andra användare i systemet:" >> "$welcome_file"

  while IFS=: read -r existing_user _ uid _; do
    if [ "$uid" -ge 1000 ] && [ "$existing_user" != "$user" ]; then
       echo "- $existing_user" >> "$welcome_file"
    fi
  done < /etc/passwd

  chown "$user":"$user" "$welcome_file"
  echo "Hemkatalog och filer skapade för '$user'."
done
