#!/usr/bin/env bash
set -e

# Settings:
#   bib_regex:
#     A regex (BRE) matching the path to the original BibTeX file as specified
#     using \addbibresource{path}. May not contain "<", ">", and "&".
bib_regex="\(\|.*/\)crypto.bib"


# Parse arguments
original_args=("$@")
while [[ $# -gt 0 ]]; do
  case $1 in
    --input-directory=*)
      input_dir="${1#*=}"
      shift
      ;;
    --input-directory)
      input_dir="$2"
      shift 2
      ;;
    --output-directory=*)
      output_dir="${1#*=}"
      shift
      ;;
    --output-directory)
      output_dir="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
set -- "${original_args[@]}"


lastarg="${*: -1}"
bcf_stem="${lastarg/%.bcf/}"
bcf="$bcf_stem.bcf"
bcf_dir=$(dirname "$bcf")
jobname=$(basename "$lastarg" ".bcf")
bib_ex="${bcf_stem}.exttmp.bib"

# Find the path to the BibTeX file in the BCF file
bib=$(sed -n "s&.*>\($bib_regex\)</bcf:datasource>.*&\1&p" "$bcf")

# If the path is relative, Biber interprets it relative to (see the manual):
#   1. --input-directory if specified
#   2. --output-directory if specified and --input-directory is not specified
#   3. the current working directory
#   4. the directory of the BCF file
# If all of this fails, it falls back on kpsewhich.
#
# We construct a suitable BIBINPUTS and delegate finding the file to kpsewhich.
option_dir="${input_dir:-${output_dir:-}}"
bibinputs_override="${option_dir:+$option_dir:}$PWD:$bcf_dir:$BIBINPUTS"
bib_abs=$(BIBINPUTS="$bibinputs_override" kpsewhich -format=bib "$bib") || (
    # Delegate printing the error message to Biber. This guarantees that
    # latexmk and friends will be able to parse it.
    biber "$@"
    ret=$?
    echo "$0 ERROR - Cannot find '$bib'!" >&2
    if [[ $ret -eq 0 ]]; then
      echo "$0 ERROR - Biber found '$bib' unexpectedly, see its log file!" >&2
      exit 1
    fi
    exit $ret
)
echo "$0 INFO - '$bib' found at '$bib_abs'." >&2

# Switch to the directory of this script
cd "${BASH_SOURCE%/*}" || exit 1

# Do the extraction
./vendor/extract_from_bibliography/extract_from_bibliography.py "$bcf" "$bib_abs" > "$bib_ex"

# Modify the BCF file to use the extracted BibTeX file
bcf_ex="${bcf_stem}.exttmp.bcf"
sed -e "s&>$bib_regex</bcf:datasource>&>$bib_ex</bcf:datasource>&" "$bcf" > "$bcf_ex"

# Call biber with the modified BCF file
biber "${@:1:$#-1}" "$bcf_ex"
ret=$?
if [ $ret -ne 0 ]; then
    exit $ret
fi

# Rename the generated files to have the right jobname
mv "${bcf_stem}.exttmp.bbl" "$bcf_dir/$jobname.bbl"
mv "${bcf_stem}.exttmp.blg" "$bcf_dir/$jobname.blg"

# Remove the temporary files
#
# We deliberately keep them when an error occurs, so they can be inspected.
rm -f "./$bcf_ex"
rm -f "./$bib_ex"
