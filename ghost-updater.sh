#!/bin/bash

URL="tadhatfield.com" #Change this to your url
SERVERIP="localhost" #Change this to your server ip if Ghost is on another machine

# this is needed or me running the script on my own website for this very page will break the script by replacing all the filetypes.
PNG="png"
JPG="jpg"
JPEG="jpeg"
WEBP="webp"

date=$(date)
git pull origin master
# Ensure we're in the correct directory
cd /home/thatfield/ghost

# Remove existing docs directory and create a new one
rm -rf docs
mkdir docs

# Create CNAME file
echo $URL > docs/CNAME

# Run ecto1.py
ECTO1_SOURCE=http://$SERVERIP:2368 ECTO1_TARGET=https://$URL python3 ecto1.py

# Create images directory in docs
mkdir -p docs/content/images

# Copy images from the mapped volume to the docs directory
cp -r ghost/content/images/. docs/content/images
IMGMSG="No image optimization was used"
while getopts ":o:" opt; do
  case $opt in
    o)
      arg_o="$OPTARG"
      echo "Option -o with argument: $arg_o"
      if [ $arg_o = "webp" ]; then
        echo 'Conversion to webp has started'
        sleep 1
        find docs/content/images/. -type f -regex ".*\.\($JPG\|$JPEG\|$PNG\)" -exec mogrify -format webp {}  \; -print
        find docs/content/images/. -type f -regex ".*\.\($JPG\|$JPEG\|$PNG\)" -exec rm {}  \; -print
        grep -lR ".$JPG" docs/ | xargs sed -i 's/\.$JPG/\.$WEBP/g'
        grep -lR ".$JPEG" docs/ | xargs sed -i 's/\.$JPEG/\.$WEBP/g'
        grep -lR ".$PNG" docs/ | xargs sed -i 's/\.$PNG/\.$WEBP/g'
        echo 'Conversion to webp has completed'
        IMGMSG="Images converted to webp"
      else
        echo 'Standard image optimization has started'
        sleep 1
        #credit goes to julianxhokaxhiu for these commands 
        find . -type f -iname "*.$PNG" -exec optipng -nb -nc {} \;
        find . -type f -iname "*.$PNG" -exec pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time -ow {} \;
        find . -type f \( -iname "*.$JPG" -o -iname "*.$JPEG" \) -exec jpegoptim -f --strip-all {} \;
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
git add .
git commit -m "Compiled Changes - $date | $IMGMSG" ghost-updater.sh ecto1.py requirements.txt README.md serve.py docs/.
git config --global credential.helper store
git push -u origin master
