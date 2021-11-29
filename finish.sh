find packages/**/bin/* | while read line; do
	IFS='/' read -r -a path <<< "$line"
	BINNAME=${path[3]}

	ln -snf "../$line" "bin/$BINNAME"
done

USER=$(whoami)
echo 'export PATH=/home/maat1/Documents/setup/bin:$PATH' >> "/home/$USER/.bash_profile"

. /home/maat1/.bash_profile
