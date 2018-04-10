#!/bin/bash

if [ "$1" == "--astran" ] && [ "$3" == "--spices" ] && [ "$5" == "--rules" ] && [ "$7" == "--gurobi_lic" ] && [ "$9" == "--core" ]; then
	if [ -d $2 ] && [ -d $4 ] && [ -f $6 ] && [ -f $8 ]; then
		ASTRAN_PATH=$2
		SPICES_PATH=$4
		TECH_RULES=$6
		GUROBI_LIC=$8
		CORE=$10
		echo "--> Correct arguments."
	else
		echo "--> --astran and/or --spices values are not directories."
	fi
else
	echo "--> Invalid arguments."
	exit 1
fi



# Get spices
SPICES=(in_execution/$CORE/spices/*.sp)
echo $SPICES
NUM_SPICES=${#SPICES[@]}
echo $NUM_SPICES

if [ $NUM_SPICES -gt 0 ];then
	echo "--> Design one layout"
else
	echo "--> Copy spice from initial folder to in_execution."
fi


# FILES=/home/astran-master/Astran/build/bin/TCC_Design_Layouts/Reordering/design_spices/pclass-4-fc/original/v2/spices/*.sp #Pasta com arquivos .sp das celulas
# TECH=/home/astran-master/Astran/build/Work_test/tech_0065_2.rul
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
# GUROBI=/opt/gurobi702/linux64/bin/gurobi_cl