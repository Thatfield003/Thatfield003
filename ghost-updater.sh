#!/bin/bash

# Set variables
URL="tadhatfield.com"  # Change this to your URL if different
SERVERIP="localhost"  # Change this to your server IP if Ghost is on another machine
GHOST_CONTENT_PATH="/home/thatfield/ghost/content"

# Set file extensions
PNG="png"
JPG="jpg"
JPEG="jpeg"
WEBP="webp"

# Get current date
date=$(date)

# Pull latest changes from git
git pull origin master

# Recreate docs directory
rm -rf docs
mkdir -p docs/content/images

# Create CNAME file
echo $URL > docs/CNAME

# Run ecto1.py
ECTO1_SOURCE=http://$SERVERIP:2368 ECTO1_TARGET=https://$URL python3 ecto1.py

# Copy images from Ghost content to docs
echo "Copying images from $GHOST_CONTENT_PATH/images to docs/content/images"
cp -rv $GHOST_CONTENT_PATH/images/. docs/content/images/

# Initialize image optimization message
IMGMSG="No image optimization was used"

# Process command line options
while getopts ":o:" opt; do
  case $opt in
    o)
      arg_o="$OPTARG"
      echo "Option -o with argument: $arg_o"
      if [ "$arg_o" = "webp" ]; then
        echo 'Conversion to webp has started'
        find docs/content/images -type f \( -iname "*.${JPG}" -o -iname "*.${JPEG}" -o -iname "*.${PNG}" \) -exec mogrify -format webp {} + 
        find docs/content/images -type f \( -iname "*.${JPG}" -o -iname "*.${JPEG}" -o -iname "*.${PNG}" \) -delete
        grep -rlZ "\.$JPG\|\.$JPEG\|\.$PNG" docs | xargs -0 sed -i "s/\.$JPG/.$WEBP/g; s/\.$JPEG/.$WEBP/g; s/\.$PNG/.$WEBP/g"
        echo 'Conversion to webp has completed'
        IMGMSG="Images converted to webp"
      else
        echo 'Standard image optimization has started'
        find docs/content/images -type f -iname "*.${PNG}" -exec optipng -nb -nc {} +
        find docs/content/images -type f -iname "*.${PNG}" -exec pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time -ow {} +
        find docs/content/images -type f \( -iname "*.${JPG}" -o -iname "*.${JPEG}" \) -exec jpegoptim -f --strip-all {} +
        echo 'Standard image optimization has completed'
        IMGMSG="Standard image optimization was used"
      fi
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

# Commit and push changes
git add .
git commit -m "Compiled Changes - $date | $IMGMSG" ghost-updater.sh ecto1.py requirements.txt README.md serve.py docs/.
git config --global credential.helper store
git push -u origin master

echo "Script completed successfully."
