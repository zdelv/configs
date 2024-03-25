# CLI Interface
# -o, --output-dir: output directory, default=~/.vim
# -h, --help: help
# -v, --version: version

FILES=(".vimrc" "lua/")

VERSION="1.0.0"

# Copy files in current directory
# to output directory
function copy_files() {
	# Create output directory if it does not exist
	if [ ! -d $OUTPUT_DIR ]; then
		mkdir -p $OUTPUT_DIR
	fi

	# Copy files
	for file in ${FILES[@]}; do
		printf "Copying $file to $OUTPUT_DIR\n"
		cp -r $file $OUTPUT_DIR
	done
}

# Print help
function print_help() {
	echo "Usage: ./install.sh [options]"
	echo "Options:"
	echo "  -o, --output-dir, default=~/.vim"
	echo "  -h, --help"
	echo "  -v, --version"
}

# Print version
function print_version() {
	echo "Version: $VERSION"
}

if [ $# -eq 0 ]; then
	print_help
	exit 0
fi

# Parse command line arguments
while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		-o|--output-dir)
			OUTPUT_DIR="$2"
			shift
			shift
			;;
		-h|--help)
			print_help
			exit 0
			;;
		-v|--version)
			print_version
			exit 0
			;;
		*)
			echo "Unknown option: $1"
			exit 1
			;;
	esac
done

copy_files
