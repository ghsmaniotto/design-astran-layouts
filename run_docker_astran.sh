#!/bin/bash

if [ "$1" == "--astran" ] && [ "$3" == "--rules" ] && [ "$5" == "--gurobi_lic" ] && [ "$7" == "--core" ]; then
	if [ -d $2 ] && [ -f $4 ] && [ -f $6 ]; then
		ASTRAN_PATH=$2
		TECH_RULES=$4
		GUROBI_LIC=$6
		CORE=$8

		echo "-----> Astran path: $ASTRAN_PATH"
		echo "-----> Tech rules: $TECH_RULES"
		echo "-----> Gurobi license: $GUROBI_LIC"
		echo "-----> CPU core to run: $CORE"
		echo "--> Correct arguments."
	else
		echo "### ERROR:"
		echo "--> --astran and/or --spices values are not directories."
		exit 1
	fi
else
	echo "### ERROR:"
	echo "--> Invalid arguments."
	echo "Try to run with the following command and arguments:"
	echo "./run_docker_astran.sh --astran <astran/path> --rules <path/to/tech/file> --gurobi_lic <path/to/gurobi/license> --core <CPU_core>" 
	exit 1
fi

# This flag is 1 until have spices in initial folder
DESIGNING=1

# Change directory to core execution directory
cd /home/simulation/in_execution/$CORE

EXEC_DIR=/home/simulation/in_execution/$CORE

while [[ DESIGNING -eq 1 ]]; do
	SPICES=($EXEC_DIR/spices/*.sp)
	echo "SPICE:: $SPICES"
	NUM_SPICES=${#SPICES[@]}
	echo "Spices in execution: $NUM_SPICES"
	# Check if there are spices to design in execution directory
	if [ -f ${SPICES[0]} ];then
		# There is a file. We need to design it. 
		# Define the location of gurobi.
		GUROBI=/opt/gurobi702/linux64/bin/gurobi_cl
		# Define the name of GND
		GND="GND"
		# Define the name of VDD
		VDD="VDD"

		#Retira o nome da celula
		nomeArquivoSpice="${SPICES##*/}"
		echo $nomeArquivoSpice
		nomeCelula="${nomeArquivoSpice%%.*}"
		nomeCelula="${nomeCelula^^}"
		echo $nomeCelula
		#Cria um arquivo com os comandos para executar o ASTRAN
	    echo -e "set lpsolve \"$GUROBI\"\nset vddnet $VDD\nset gndnet $GND\nload technology \"$TECH_RULES\"\nload netlist \"$SPICES\"\ncellgen select \"$nomeCelula\"\ncellgen autoflow\nexport layout \"$nomeCelula\" \"""${EXEC_DIR}/layouts/""$nomeCelula"".cif\"\nexit" > $EXEC_DIR/comandos.run

		#Executa o ASTRAN via scritp
	    /home/astran/Astran/build/bin/./Astran --shell $EXEC_DIR/comandos.run; echo "--> Execution finished: $nomeCelula."
		
		# Check if the layout was designed
		if [[ -f $EXEC_DIR/layouts/${nomeCelula}.cif ]]; then
			echo "--> Layout of ${nomeCelula} cell was designed."
			# Move the spice and layout to designed folder
			mv $SPICES /home/simulation/final/spices
			mv $EXEC_DIR/layouts/${nomeCelula}.cif /home/simulation/final/layouts

		else
			echo "--> Layout of ${nomeCelula} cell was not designed."
			mv $SPICES /home/simulation/not_designed
			# Move the spice to not designed folder
		fi

	else
		# Get spice from initial folder
		INITIAL_SPICES=(/home/simulation/initial/*.sp)
		# If there are no spices in initial folder, exit script
		if [[ ${#INITIAL_SPICES[@]} -lt 0 ]]; then
			echo "### The initial folder is empty. Finish the execution."
			DESIGNING=0
			exit 1
		fi
		
		# Try to move the spice to execution directory
		mv $INITIAL_SPICES in_execution/$CORE/spices/
		
		# Check it move command was correctly executed
		while [[ $? -ne 0 ]]; do
			# If the move command fails, try to move again--a
			INITIAL_SPICES=(/home/simulation/initial/*.sp)
			mv $INITIAL_SPICES $EXEC_DIR/spices
		done
		
		echo "--> Copy spice from initial folder to in_execution."
	fi
done




