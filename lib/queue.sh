#!/usr/bin/env bash

#####################################################################
##
## title: Queue Extension
##
## description:
## Queue extension of shell (bash, ...)
##
## author: Mihaly Csokas
##
## date: 04. Feb. 2018
##
## license: MIT
##
#####################################################################

source "./console.sh"

queue() {
  local operation="$1"
  shift

  case "$operation" in

        create)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[create must be followed by one param]" && return 1

            queue_name="$1"
            declare -ga "$queue_name"

                ;;

        add)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[add must be followed by two params]" && return 1

            declare -n queue_name="$1"
            local value="$2"
            #queue_name=( $value "${queue_name[@]}" )
            queue_name+=( "$value" )

            ;;

        clear)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[clear must be followed by one param]" && return 1

            unset $1
            declare -ga "$1"

            ;;

        size)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[size must be followed by one param]" && return 1

            declare -n queue_name="$1"
            echo ${#queue_name[@]}

            ;;

        last)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[next must be followed by one param]" && return 1

            declare -n queue_name="$1"
            local retval
            #local last_index=$(( ${#queue_name[@]} - 1 ))
            retval=${queue_name[0]}

            echo "$retval"
            ;;

        next)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[next must be followed by one param]" && return 1

            declare -n queue_name="$1"
            local retval
            #local last_index=$(( ${#queue_name[@]} - 1 ))
            retval=${queue_name[0]}
            queue_name=(${queue_name[@]:1})

            echo "$retval"
            ;;


        empty)

            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[empty must be followed by one param]" && return 1

            declare -n queue_name="$1"
            local size="${#queue_name[@]}"
            [[ $size -eq 0 ]] && echo "true" || echo "false"

            ;;


        *)
            echo $"Usage: $0 { create | add "\
              " | remove | elements | clear "\
              "}"
            exit 1

  esac

}