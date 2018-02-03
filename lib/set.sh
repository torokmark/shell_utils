#!/usr/bin/env bash

#####################################################################
##
## title: Set Extension
##
## description:
## Set extension of shell (bash)
##   with well-known function for set manipulation
##
## author: Mihaly Csokas
##
## date: 03. Feb. 2018
##
## license: MIT
##
#####################################################################

source "./console.sh"

set_structure() {
  local operation="$1"
  shift

  case "$operation" in

        create)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[create must be followed by one param]" && return 1

            set_name="$1"
            declare -gA "$set_name"

            ;;

        add)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[add must be followed by two params]" && return 1

            declare -n set_name="$1"
            local key="$2"
            local value=" "
            set_name+=( ["$key"]="$value" )

            ;;

        clear)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[clear must be followed by one param]" && return 1

            unset $1
            declare -gA "$1"

            ;;

        size)
            # pre-conditions:

            [[ "$#" -lt 1 ]] && log_failure "[size must be followed by one param]" && return 1

            declare -n set_name="$1"
            echo ${#set_name[@]}

            ;;

        remove)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[remove must be followed by two params]" && return 1

            declare -n set_name="$1"
            local key="$2"
            unset set_name["$key"]

            ;;

        elements)
            # pre-conditions:
            [[ "$#" -lt 1 ]] && log_failure "[elements must be followed by one param]" && return 1

            declare -n set_name="$1"
            echo ${!set_name[@]}

            ;;

        contains)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[contains must be followed by two params]" && return 1

            declare -n set_name="$1"
            local element="$2"
            local retval="false"

            for i in "${!set_name[@]}"
            do
              if [[ "$i" = "$element" ]]; then
                retval="true"
              fi
            done

            echo ${retval}

            ;;

        union)
            # pre-conditions:
            [[ "$#" -lt 3 ]] && log_failure "[union must be followed by three params]" && return 1

            declare -n first_set="$1"
            declare -n second_set="$2"
            declare -n union_set="$3"

            for i in "${!first_set[@]}"
            do
              set_structure add union_set "$i"
            done

            for i in "${!second_set[@]}"
            do
              set_structure add union_set "$i"
            done

            ;;

        intersection)
            # pre-conditions:
            [[ "$#" -lt 3 ]] && log_failure "[intersection must be followed by three params]" && return 1

            declare -n first_set="$1"
            declare -n second_set="$2"
            declare -n intersection_set="$3"
            local contains="false"

            for i in "${!first_set[@]}"
            do
              contains=$( set_structure contains second_set "$i" )
              if [[ $contains = "true" ]]; then
                set_structure add intersection_set "$i"
              fi
            done

            ;;

        difference)
            # pre-conditions:
            [[ "$#" -lt 3 ]] && log_failure "[difference must be followed by three params]" && return 1

            declare -n first_set="$1"
            declare -n second_set="$2"
            declare -n difference_set="$3"
            local contains="false"

            for i in "${!first_set[@]}"
            do
              contains=$( set_structure contains second_set "$i" )
              if [[ $contains = "false" ]]; then
                set_structure add difference_set "$i"
              fi
            done

            ;;

        equal)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[equal must be followed by two params]" && return 1

            declare -n first_set="$1"
            declare -n second_set="$2"
            local contains="false"
            local equals="true"


            for i in "${!first_set[@]}"
            do
              contains=$( set_structure contains second_set "$i" )
              if [[ $contains = "false" ]]; then
                equals="false"
              fi
            done

            if [[ ${#first_set[@]} -ne ${#second_set[@]} ]]; then
              equals="false"
            fi

            echo "$equals"
            ;;

        subset)
            # pre-conditions:
            [[ "$#" -lt 2 ]] && log_failure "[subset must be followed by two params]" && return 1

            declare -n first_set="$1"
            declare -n second_set="$2"

            local subset="true"

            for i in "${!first_set[@]}"
            do
              contains=$( set_structure contains second_set "$i" )
              if [[ $contains = "false" ]]; then
                subset="false"
              fi
            done

            echo "$subset"
            ;;

        "")
            set
            ;;

        *)
            echo $"Usage: $0 { create | add "\
              "| remove | elements | clear "\
              "| size | intersection | difference "\
              "| subset | equal }"
            exit 1

  esac

}
