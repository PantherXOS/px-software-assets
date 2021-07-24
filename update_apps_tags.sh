#!/bin/sh

echo "*************************************************"
echo "not completed yet"
echo "*************************************************"
exit 1

usage () {
    echo "Usage: $0 append|new latest|recommended app_name1 app_name2 ..."
    echo "       Putting application to latest or recommended tag list. (append or add as a new list)"
}

update_package_rec_file() {
    _f=$1
    _tag=$2
    _remove_tag_flag=$3
    name=$(recsel -n 0 -P name "$_f")
    title=$(recsel -n 0 -P title "$_f")
    version=$(recsel -n 0 -P version "$_f")
    description=$(recsel -n 0 -P description "$_f")
    homepage=$(recsel -n 0 -P homepage "$_f")
    license=$(recsel -n 0 -P license "$_f")
    icon=$(recsel -n 0 -P icon "$_f")
    screenshots=$(recsel -n 0 -P screenshot "$_f")
    categories=$(recsel -n 0 -P category "$_f")
    tags=$(recsel -n 0 -P tag "$_f")

    > "$_f"
    command="recins -f name -v "$name" \
            -f title -v \""$title"\" \
            -f version -v \""$version"\" \
            -f description -v \""$description"\" \
            -f homepage -v \""$homepage"\" \
            -f icon -v \""$icon"\"  \
            -f license -v \""$license"\""

    while read line; 
    do 
        command="$command -f category -v \""$line"\""
    done <<< "$categories"

    while read line; 
    do 
        command="$command -f screenshot -v \""$line"\""
    done <<< "$screenshots"


    if [ "$_remove_tag_flag" = true ] ; then
        while read line;
        do 
            if [ "$line" != "$_tag" ]; then
                command="$command -f tag -v "\"$line""\"
            fi
        done <<< "$tags"
    else
        while read line;
        do
            if [ -z "$line" ]; then
                continue
            fi
            if [ "$line" != "$_tag" ]; then
                command="$command -f tag -v "\"$line""\"
            else
                _tag_found=true
            fi
        done <<< "$tags"
        if [ "$_remove_tag_flag" = false ] ; then
            command="$command -f tag -v "\"$_tag""\"
        fi
    fi
    command="$command $_f"
    echo $command
    eval $command
    sed -i '1i # -*- mode: rec -*-' $_f
}

if [ "$#" -lt 3 ]; then
    echo "Wrong arguments!"
    usage
    exit 1
fi

mode=$1
tag=$2

if [ "$mode" != "append" ] && [ "$mode" != "new" ] || [ "$tag" != "latest" ] && [ "$tag" != "recommended" ]; then
    echo "Wrong argument value"
    usage
    exit
fi

# get list of packages with passed tag
cd packages/
if [ "$mode" = "new" ]; then
    prev_tag_list=$(grep -rnl "tag: $tag")
fi

# remove tag from the current packages
for f in "$prev_tag_list"; 
do 
    if [ -z "$f" ]; then
        continue
    fi
    echo "removing tag ($tag) from: " $f
    update_package_rec_file "$f" "$tag" true
done

i=0
# for pkg in "$@"
# do
#     if [ "$i" -lt 2 ]; then
#         i=$((i+1))
#         continue
#     fi
#     echo "adding tag ($tag) to: " "$pkg.rec"
#     update_package_rec_file "$pkg.rec" "$tag" false
# done

cd -

