#!/bin/bash

USER_FILE=/root/users.txt
TEMPLATE_USER_DIR=/etc/skel
DEBUG=false

if $DEBUG; then
    set -x
fi

# Parse options

PW_SEED=
GH_REPO=
N_USERS=100
USER_PREFIX=train
R_PACKAGES=
R_PACKAGES_GH=

usage () { 
  echo
  echo "Usage: ./start_rsp_train.sh --pw-seed <value> --gh-repo <value> [--n-users <value>]"
  echo "                            [--user-prefix <value>] [--r-packages <pkg1,pkg2,pkg3,...>]"
  echo "                            [--r-packages-gh <repo1/pkg1,repo2/pkg2,...>]"
  echo
  echo "Options:"
  echo "--pw-seed       Seed for randomly generated user passwords. Required."
  echo "--gh-repo       GitHub repository with training materials. Must contain exercises/ and solutions/ folders. Required"
  echo "--n-users       Number of users to generate. Default = 100."
  echo "--user-prefix   Prefix for user account. Default = \"train\"."
  echo "--r-packages    Comma-separated list of R packages to install from CRAN. Optional."
  echo "--r-packages-gh Comma-separates list of R packages to install from GitHub. Optional."
}

while :; do
  case "$1" in
    --pw-seed )
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        PW_SEED="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --gh-repo )
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        GH_REPO="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --n-users ) 
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        N_USERS="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --user-prefix )
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        USER_PREFIX="$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    --r-packages )
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        R_PACKAGES="$2"
        shift 2
      else
        # Silently accept missing argument
        shift 1
      fi
      ;;
    --r-packages-gh )
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        R_PACKAGES_GH="$2"
        shift 2 
      else
        # Silently accept missing argument
        shift 1
      fi
      ;;
    -- ) shift; break;;
    * ) break ;;
  esac
done

if [[ -z $PW_SEED ]]; then
  echo "Error: Password seed must be supplied to --pw-seed."
  usage
  exit 1
fi

if [[ -z $GH_REPO ]]; then
  echo "Error: GitHub repo must be supplied to --gh-repo."
  usage
  exit 1
fi

# Install R packages

if [[ -n $R_PACKAGES ]]; then
  IFS=","
  PKGS=( )
  read -ra PKGS <<< "$R_PACKAGES"

  for PKG in "${PKGS[@]}"; do
    echo
    echo "# Install CRAN R package $PKG..."
    echo
    R -e "install.packages(\"$PKG\", repos=\"https://packagemanager.rstudio.com/cran/__linux__/bionic/latest\")"
  done
fi

if [[ -n $R_PACKAGES_GH ]]; then
  IFS=","
  PKGS=( )
  read -ra PKGS <<< "$R_PACKAGES_GH"

  for PKG in "${PKGS[@]}"; do
    echo
    echo "# Install GitHub R package $PKG..."
    echo
    R -e "remotes::install_github(\"$PKG\")"
  done
fi


# Deactivate license with docker stop

deactivate() {
    echo "== Exiting =="
    echo " --> TAIL 100 rstudio-server.log"
    tail -100 /var/log/rstudio-server.log
    echo " --> TAIL 100 rstudio-launcher.log"
    tail -100 /var/lib/rstudio-launcher/rstudio-launcher.log
    echo " --> TAIL 100 monitor/log/rstudio-server.log"
    tail -100 /var/lib/rstudio-server/monitor/log/rstudio-server.log

    echo "Deactivating license ..."
    rstudio-server license-manager deactivate >/dev/null 2>&1

    echo "== Done =="
}
trap deactivate EXIT

# Copy course materials into /etc/skel

git clone "$GH_REPO" /tmp/materials

if [[ -d "/tmp/materials/exercises" && -d "/tmp/materials/solutions" ]]; then
  cp -a /tmp/materials/exercises/ /etc/skel/
  cp -a /etc/skel/exercises /etc/skel/backup
  cp -a /tmp/materials/solutions/ /etc/skel/
  rm -rf /tmp/materials
else
  echo
  echo "Error: GitHub repo must contain exercises/ and solutions/ directories."
  echo
  rm -rf /tmp/materials
  exit 1
fi

# Create users file

/usr/local/bin/create_users_table.R "$USER_PREFIX" "$N_USERS" "$PW_SEED" "$USER_FILE"

# Create users

if [[ ! -d $TEMPLATE_USER_DIR ]]; then
    printf 'Error: Template dir %s does not exist.\n' $TEMPLATE_USER_DIR
    exit 1
fi

while IFS=$'\t' read -r USERNAME PASSWORD || [[ -n $USERNAME ]]
do
    # Deal with new line at the end of the file
    if [[ -z "$USERNAME" ]]; then
        continue
    fi

    # Skip existing users
    USER_EXISTS=$(id -u "$USERNAME" > /dev/null 2>&1; echo $?)
    if [[ "$USER_EXISTS" -eq "0" ]]; then
        printf '# User %s exists, skipping\n' "$USERNAME"
        continue
    fi

    printf '# Create user %s with password %s\n' "$USERNAME" "$PASSWORD"

    # Start useradd command
    CMD="useradd --shell /bin/bash -g users -p \$(openssl passwd -1 $PASSWORD)"

    # Add home dir, unless existing
    HOME_DIR="/home/$USERNAME"
    if [ ! -d "$HOME_DIR" ]; then
        CMD=$(printf '%s --create-home' "$CMD")
    fi

    # Sudo users 001 through 009 (to be used by instructors)
    if [[ $USERNAME =~ 00[1-9] ]]; then
        CMD=$(printf '%s %s' "$CMD" "-G sudo")
    fi

    CMD=$(printf '%s %s' "$CMD" "$USERNAME")

    if $DEBUG; then
        printf 'RUN: %s\n' "$CMD"
    fi

    eval "$CMD"

done < $USER_FILE

# Run RSP startup script

/usr/local/bin/startup.sh