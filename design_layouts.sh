#!/bin/bash

# Get parameters

if [ "$1" == "--help" ]; then
	echo "To run type:"
	echo "./design_layouts.sh --astran <path_to_astran_project> --spices <path_to_spices>"
	exit 1
elif [ "$1" == "--astran" ] && [ "$3" == "--spices" ]; then
	if [ -d $2 ] && [ -d $4 ]; then
		ASTRAN_PATH=$2
		SPICES_PATH=$4
		echo "--> Correct arguments."
	else
		echo "--> --astran and/or --spices values are not directories."
	fi
else
	echo "--> Invalid arguments."
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
	echo "--> The spices folders does not contain spice files."
	exit 1
fi


# Create auxiliar folders
mkdir -p in_execution
mkdir -p final/spices
mkdir -p final
mkdir -p final/layouts
mkdir -p final/spices
mkdir -p initial
mkdir -p final/spices
echo "--> The auxiliar folders were created."

# Define OS type and get number of cores
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    OS="linux"
    CORES=$( nproc )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    CORES=$( sysctl -n hw.ncpu )
else
	echo "--> The Operation System can't be defined. The script end."
	exit 1
fi

echo "--> The operation system is $OS. The machine has $CORES logic cores."


echo "Do you like to design how many layouts of each spice?"
read LAYOUTS_PER_SPICE

if [[ $LAYOUTS_PER_SPICE =~ ^[0-9]+$ ]]; then
	echo $LAYOUTS_PER_SPICE	
fi


# FILES=/home/astran-master/Astran/build/bin/TCC_Design_Layouts/Reordering/design_spices/pclass-4-fc/original/v2/spices/*.sp #Pasta com arquivos .sp das celulas
# TECH=/home/astran-master/Astran/build/Work_test/tech_0065_2.rul
# GUROBI=/opt/gurobi702/linux64/bin/gurobi_cl
# GND="GND"
# VDD="VDD"

# for arquivo in $FILES
# do
# 	#Retira o nome da celula
# 	nomeArquivoSpice="${arquivo##*/}"
# 	echo $nomeArquivoSpice
# 	nomeCelula="${nomeArquivoSpice%%.*}"
# 	nomeCelula="${nomeCelula^^}"
# 	echo $nomeCelula
# 	#Cria um arquivo com os comandos para executar o ASTRAN
#        	echo -e "set lpsolve \"$GUROBI\"\nset vddnet $VDD\nset gndnet $GND\nload technology \"$TECH\"\nload netlist \"$arquivo\"\ncellgen select \"$nomeCelula\"\ncellgen autoflow\nexport layout \"$nomeCelula\" \"""layouts/""$nomeCelula"".cif\"\nexit" > comandos.run
# 	cp comandos.run ../../
# 	#Executa o ASTRAN via scritp
#        ../../../../../.././Astran --shell comandos.run

# done
