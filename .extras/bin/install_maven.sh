#!/usr/bin/env bash

# Install maven.

usage()
{
  cat <<USAGE_TEXT
Usage:  $(basename "${BASH_SOURCE[0]}")
            [--dry_run]
            [--show_diff]
            [--verbose]
            [--maven_version=<version>]
            [--maven_archive_file_checksum=<algorithm_and_checksum>]
            [--install_directory=<install_directory>]
            [--requires_become=<true|false>]
            [--help | -h]
            [--script_debug]

Install rhsso_cli.

Available options:
    --dry_run
        Run the configuration process without making changes.
    --show_diff
        Show before/after changes to config.
    --verbose
        Show additional detail.
    --maven_version=<version>
        The version of maven to install.
        Default: 3.9.6
    --install_directory=<install_directory>
        The directory in which to install maven.
        Default: /opt/maven
    --requires_become=<true|false>
        Is privilege escalation required?
        Default: true
    --help, -h
        Print this help and exit.
    --script_debug
        Print script debug info.
USAGE_TEXT
}

main()
{
  initialize
  parse_script_params "${@}"
  install_maven
}

install_maven()
{
  EXTRAS_DIRECTORY="$(cd "${THIS_SCRIPT_DIRECTORY}/.."; pwd)"
  export ANSIBLE_ROLES_PATH=${EXTRAS_DIRECTORY}/.ansible/roles/:${HOME}/.ansible/roles/

  # Install the dependencies of the playbook:
  ANSIBLE_ROLES_PATH=${HOME}/.ansible/roles/ \
    && \
    ansible-galaxy \
      install \
      --role-file=${EXTRAS_DIRECTORY}/.ansible/roles/requirements_maven.yml \
      --force
  last_command_return_code="$?"
  if [ "${last_command_return_code}" -ne 0 ]; then
    msg "Error: ansible-galaxy role installations failed."
    abort_script
  fi

  ASK_BECOME_PASS_OPTION=""
  if [ "${REQUIRES_BECOME}" = "${TRUE_STRING}" ]; then
    ASK_BECOME_PASS_OPTION="--ask-become-pass"
  fi

  ansible-playbook ${ANSIBLE_CHECK_MODE_ARGUMENT} ${ANSIBLE_DIFF_MODE_ARGUMENT} ${ANSIBLE_VERBOSE_ARGUMENT} ${ASK_BECOME_PASS_OPTION} \
    --inventory="localhost," \
    --connection=local \
    --extra-vars="adrianjuhl__maven__install_directory=${INSTALL_DIRECTORY}" \
    --extra-vars="adrianjuhl__maven__version=${MAVEN_VERSION}" \
    --extra-vars="local_playbook__install_maven__requires_become=${REQUIRES_BECOME}" \
    ${EXTRAS_DIRECTORY}/.ansible/playbooks/install_maven.yml
}

parse_script_params()
{
  MAVEN_VERSION="3.9.6"
  INSTALL_DIRECTORY="/opt/maven"
  REQUIRES_BECOME="${TRUE_STRING}"
  REQUIRES_BECOME_PARAM=""
  ANSIBLE_CHECK_MODE_ARGUMENT=""
  ANSIBLE_DIFF_MODE_ARGUMENT=""
  ANSIBLE_VERBOSE_ARGUMENT=""
  SCRIPT_DEBUG_OPTION="${FALSE_STRING}"
  while [ "${#}" -gt 0 ]
  do
    case "${1-}" in
      --maven_version=*)
        MAVEN_VERSION="${1#*=}"
        ;;
      --install_directory=*)
        INSTALL_DIRECTORY="${1#*=}"
        ;;
      --requires_become=*)
        REQUIRES_BECOME_PARAM="${1#*=}"
        ;;
      --dry_run)
        ANSIBLE_CHECK_MODE_ARGUMENT="--check"
        ;;
      --show_diff)
        ANSIBLE_DIFF_MODE_ARGUMENT="--diff"
        ;;
      --verbose)
        ANSIBLE_VERBOSE_ARGUMENT="-vvv"
        ;;
      --help | -h)
        usage
        exit
        ;;
      --script_debug)
        set -x
        SCRIPT_DEBUG_OPTION="${TRUE_STRING}"
        ;;
      -?*)
        msg "Error: Unknown parameter: ${1}"
        msg "Use --help for usage help"
        abort_script
        ;;
      *) break ;;
    esac
    shift
  done
  case "${REQUIRES_BECOME_PARAM}" in
    "true")
      REQUIRES_BECOME="${TRUE_STRING}"
      ;;
    "false")
      REQUIRES_BECOME="${FALSE_STRING}"
      ;;
    "")
      REQUIRES_BECOME="${TRUE_STRING}"
      ;;
    *)
      msg "Error: Invalid requires_become param value: ${REQUIRES_BECOME_PARAM}, expected one of: true, false"
      abort_script
      ;;
  esac
  #echo "REQUIRES_BECOME_PARAM is: ${REQUIRES_BECOME_PARAM}"
  #echo "REQUIRES_BECOME is: ${REQUIRES_BECOME}"
}

initialize()
{
  set -o pipefail
  THIS_SCRIPT_PROCESS_ID=$$
  initialize_this_script_directory_variable
  initialize_abort_script_config
  initialize_true_and_false_strings
}

initialize_this_script_directory_variable()
{
  # THIS_SCRIPT_DIRECTORY where this script resides.
  # See: https://www.binaryphile.com/bash/2020/01/12/determining-the-location-of-your-script-in-bash.html
  # See: https://stackoverflow.com/a/67149152
  THIS_SCRIPT_DIRECTORY=$(cd "$(dirname -- "$BASH_SOURCE")"; cd -P -- "$(dirname "$(readlink -- "$BASH_SOURCE" || echo .)")"; pwd)
}

initialize_true_and_false_strings()
{
  # Bash doesn't have a native true/false, just strings and numbers,
  # so this is as clear as it can be, using, for example:
  # if [ "${my_boolean_var}" = "${TRUE_STRING}" ]; then
  # where previously 'my_boolean_var' is set to either ${TRUE_STRING} or ${FALSE_STRING}
  TRUE_STRING="true"
  FALSE_STRING="false"
}

initialize_abort_script_config()
{
  # Exit shell script from within the script or from any subshell within this script - adapted from:
  # https://cravencode.com/post/essentials/exit-shell-script-from-subshell/
  # Exit with exit status 1 if this (top level process of this script) receives the SIGUSR1 signal.
  # See also the abort_script() function which sends the signal.
  trap "exit 1" SIGUSR1
}

abort_script()
{
  echo >&2 "aborting..."
  kill -SIGUSR1 ${THIS_SCRIPT_PROCESS_ID}
  exit
}

msg()
{
  echo >&2 -e "${@}"
}

# Main entry into the script - call the main() function
main "${@}"
