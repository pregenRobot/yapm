LN_NAME=$1
LN_TARGET=$2
ALIAS_JSON=".downloads/.alias.json"


# If there aren't enough arguments
if [[ $1 == "" || $2 == "" ]]; then
	echo "Not enough arguments. Usage: bash add.sh {alias name} {target}"
	exit 1
fi

# Perform cleanup =====

rm .downloads/.alias.json.t 2> /dev/null

# Perform cleanup =====


# Check if dictionary contains key 
if jq "keys | .[]" -r $ALIAS_JSON | grep -q "$LN_NAME"; then
	echo "found"

	# Check if the target name exists in the array for the respective alias name
	if jq ".$LN_NAME | .[]" -r $ALIAS_JSON | grep -q "$LN_TARGET"; then
		echo "Path $LN_TARGET already exists for $LN_NAME. Exiting..."
		exit 1
	else
		
		# Check if folder exists at .downloads and it contains bin
		if ls -l ".downloads/$LN_TARGET" 2> /dev/null | grep -q "bin"; then
			echo "Adding new path, $LN_TARGET, for $LN_NAME"
			jq ".$LN_NAME+= [\"$LN_TARGET\"]" -r $ALIAS_JSON > "$ALIAS_JSON.temp"
			mv "$ALIAS_JSON.temp" $ALIAS_JSON
		else
			echo "folder \"$LN_TARGET\" does not exist under .downloads folder or that folder does not contain a ./bin folder. Exiting ..."
			exit 1
		fi
	fi
else
	# Check if folder exists at .downloads and it contains bin
	if ls -l ".downloads/$LN_TARGET" 2> /dev/null | grep -q "bin"; then
		echo "not found. creating new link $LN_NAME for target $LN_TARGET now"

		jq ". + {\"$LN_NAME\": [\"$LN_TARGET\"]}" -r $ALIAS_JSON > "$ALIAS_JSON.temp"
		mv "$ALIAS_JSON.temp" $ALIAS_JSON
	else
		echo "folder \"$LN_TARGET\" does not exist under .downloads folder or that folder does not contain a ./bin folder. Exiting ..."
		exit 1
	fi
	
fi
