#!/bin/sh
if [ "$#" -ne 2 ]; then
   echo "Usage: $0 <package> <category>"
   exit 1
fi

package_name=$1
category=$2
dbPath=packages/
guix package -s $package_name | recsel -e "name = '$package_name'" > _package.rec

if [ -s _package.rec ]; then
   name=$(recsel -n 0 -P name _package.rec)
   title=$name
   version=$(recsel -n 0 -P version _package.rec)
   description=$(recsel -n 0 -P description _package.rec)
   homepage=$(recsel -n 0 -P homepage _package.rec)
   license=$(recsel -n 0 -P license _package.rec)
   #echo $name $title $version $description $homepage $license $category
   rm _package.rec
   file_name=$package_name".rec"
   > $file_name
   recins -f name -v $name -f title -v "$title" -f version -v $version -f description -v "$description" -f homepage -v $homepage -f license -v "$license" -f category -v $category \
   -f icon -v "https://assets.software.pantherx.org/$name/icons/" -f screenshot -v "https://assets.software.pantherx.org/$name/screenshots/" $file_name 
   sed -i '1i # -*- mode: rec -*-' $file_name
   mv $file_name $dbPath
   mkdir src/$name/icons -p
   mkdir src/$name/screenshots -p
   exit 0
fi
rm _package.rec
echo "$package_name not found"
exit 1

