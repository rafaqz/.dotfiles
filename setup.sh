# Files
find . -maxdepth 1 -type f -exec ln -s {} ~/ \;
# Bin
ln -s bin ~/bin
# Config
find .config/ -maxdepth 1 -type d -exec ln -s {} ~/.config/ \;
