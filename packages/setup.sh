LN_NAME=$1
LN_TARGET=$2
ALIAS_JSON=".downloads/.alias.json"


alias_contains_name () {
	if jq "keys | .[]" -r $ALIAS_JSON | grep -q "$LN_NAME"; then
		return 0
	else
		return 1
	fi
}

alias_contains_target () {
	if jq ".$LN_NAME | .[]" -r $ALIAS_JSON | grep -q "$LN_TARGET"; then
		return 0
	else
		return 1
	fi
}

if [[ $1 == "" ]]; then
	echo "Regenerating all the symlinks using the first instance in array"
	jq 'to_entries|map("\(.key)/\(.value[0])")|.[]' -r $ALIAS_JSON | while read line; do
		IFS='/' read -r -a instruction <<< "$line"
		NAME="${instruction[0]}"
		TARGET="${instruction[1]}"
		
		ln -nsf ".downloads/$TARGET" "./$NAME"
	done
	exit 1
fi

if [[ $2 == "" ]]; then
	echo "Creating symlink using the first target in .alias.json"
	
	# TODO: Test if json contains the alias name in the first place

	if ! alias_contains_name; then
		echo "There is no alias named $LN_NAME"
		exit 1
	fi

	TARGET=$(jq ".$LN_NAME[0]" -r $ALIAS_JSON)
	
	ln -nsf ".downloads/$TARGET" "./$LN_NAME"

	exit 1
else
	
	# TODO: Test if json contains the alias name and the target name in the first place	
	
	if ! alias_contains_name;then
		echo "The alias $LN_NAME does not exist"
		exit 1
	fi

	if ! alias_contains_target;then
		echo "The target $LN_TARGET does not exist for alias $LN_ALIAS"
		exit 1
	fi

	echo "Creating symlink with specified target"

	ln -nsf ".downloads/$LN_TARGET" "./$LN_NAME"

	exit 1
fi
