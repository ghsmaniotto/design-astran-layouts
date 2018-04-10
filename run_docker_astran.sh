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
# SPICES=(in_execution/$CORE/spices/*.sp)
# echo $SPICES
# NUM_SPICES=${#SPICES[@]}
# echo $NUM_SPICES

DESIGNING=1

while [[ DESIGNING -eq 1 ]]; do
	SPICES=(in_execution/$CORE/spices/*.sp)
	NUM_SPICES=${#SPICES[@]}

	if [ $NUM_SPICES -gt 0 ];then
		# FILES=/home/astran-master/Astran/build/bin/TCC_Design_Layouts/Reordering/design_spices/pclass-4-fc/original/v2/spices/*.sp #Pasta com arquivos .sp das celulas
		# TECH=/home/astran-master/Astran/build/Work_test/tech_0065_2.rul
		# GUROBI=/opt/gurobi702/linux64/bin/gurobi_cl
		GND="GND"
		VDD="VDD"

		#Retira o nome da celula
		nomeArquivoSpice="${SPICES##*/}"
		echo $nomeArquivoSpice
		nomeCelula="${nomeArquivoSpice%%.*}"
		nomeCelula="${nomeCelula^^}"
		echo $nomeCelula
		#Cria um arquivo com os comandos para executar o ASTRAN
	    echo -e "set lpsolve \"$GUROBI\"\nset vddnet $VDD\nset gndnet $GND\nload technology \"$TECH_RULES\"\nload netlist \"$SPICES\"\ncellgen select \"$nomeCelula\"\ncellgen autoflow\nexport layout \"$nomeCelula\" \"""layouts/""$nomeCelula"".cif\"\nexit" > in_execution/$CORE/comandos.run

		#Executa o ASTRAN via scritp
	    ASTRAN_PATH/./Astran --shell in_execution/$CORE/comandos.run ; echo "--> $nomeCelula designed."
		
		# Check if the layout was designed
		if [[ -f in_execution/layouts/${nomeCelula}.cif ]]; then
			# Move the spice and layout to designed folder
		else
			# Move the spice to not designed folder
		fi
	else
		# Get spice from initial folder
		INITIAL_SPICES=(initial/*.sp)
		# If there are no spices in initial folder, exit script
		if [[ ${#INITIAL_SPICES[@]} -lt 0 ]]; then
			echo "### The initial folder is empty. Finish the execution."
			exit 1
		fi
		
		# Try to move the spice to execution directory
		mv $INITIAL_SPICES in_execution/$CORE/spices/
		
		# Check it move command was correctly executed
		while [[ $? -ne 0 ]]; do
			INITIAL_SPICES=(initial/*.sp)
			mv $INITIAL_SPICES in_execution/$CORE/spices/
		done

		
		
		echo "--> Copy spice from initial folder to in_execution."
	fi
done




