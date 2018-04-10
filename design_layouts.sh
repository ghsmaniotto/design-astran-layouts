#!/bin/bash

# Get terminal arguments
if [ "$1" == "--help" ]; then
	echo "To run type:"
	echo "./design_layouts.sh --astran <path/to/astran/project> --spices <path/to/spices>
							  --rules <path/to/tech/rules/file> --gurobi_lic <path/to/gurobi/license/file>"
	exit 1
elif [ "$1" == "--astran" ] && [ "$3" == "--spices" ] && [ "$5" == "--rules" ] && [ "$7" == "--gurobi_lic" ]; then
	if [ -d $2 ] && [ -d $4 ] && [ -f $6 ] && [ -f $8 ]; then
		ASTRAN_PATH=$2
		SPICES_PATH=$4
		TECH_RULES=$6
		GUROBI_LIC=$8
		echo "--> Correct arguments."
	else
		echo "### --astran and/or --spices values are not directories."
		echo "### --rules and/or --gurobi_lic values are not files."
	fi
else
	echo "### Invalid arguments."
	exit 1
fi

# Get spices
SPICES=(${SPICES_PATH}/*.sp)
echo $SPICES
NUM_SPICES=${#SPICES[@]}
echo $NUM_SPICES

# Check if there are spices in folder
if [[ -f ${SPICES[0]} ]]; then
	echo "--> $NUM_SPICES spices were founded."
else
	echo "### The spices folders does not contain spice files."
	exit 1
fi

# Define OS type and get number of cores
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
    CORES=$( nproc )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    CORES=$( sysctl -n hw.ncpu )
else
	echo "### The Operation System can't be defined. The script end."
	exit 1
fi

echo "--> The operation system is $OS. The machine has $CORES logic cores."

# Create auxiliar folders
mkdir -p in_execution
mkdir -p not_designed
mkdir -p final/spices
mkdir -p final
mkdir -p final/layouts
mkdir -p final/spices
mkdir -p initial
mkdir -p final/spices

# Copy the spices to in_execution folder

# UNNCOMMENT BELOW LINE TO CORRECT EXECUTION
# cp ${SPICES_PATH}/*.sp initial/
echo "--> Copy the spice files to in_execution directory."


# Creates folders for each CPU core
# Each core will design defined count of layouts
for (( CORE=1; CORE<=CORES; CORE++))
do
	echo "--> Create folder to core number $CORE"
	mkdir -p in_execution/$CORE
	mkdir -p in_execution/$CORE/spices
	mkdir -p in_execution/$CORE/layouts
done

echo "--> The auxiliar folders were created."

echo "Do you like to design how many layouts of each spice?"
read LAYOUTS_PER_SPICE

if [[ $LAYOUTS_PER_SPICE =~ ^[0-9]+$ ]]; then
	echo $LAYOUTS_PER_SPICE
else
	echo "### Invalid layouts per spice."
	exit 1
fi