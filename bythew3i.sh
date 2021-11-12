#!/bin/bash

init_post() {
    # $1: name
    # $2: title
    # $3: date
    # $4: header_image
    file="_posts/$3-$1.md"
    touch $file
    echo "---" >> $file
    echo "layout:         post" >> $file
    echo "title:          $2" >> $file
    echo "subtitle:       XXX" >> $file
    echo "date:           $3" >> $file
    echo "author:         bythew3i" >> $file
    if [[ $4 -eq 1 ]]; then
        mkdir -p "img/$3-$1"
        echo "img-path:       /img/$3-$1/" >> $file
        echo "header-img:     img/$3-$1/XXX" >> $file
        echo "header-mask:    0.5" >> $file
    else
        echo "header-style:   text" >> $file
    fi
    echo "catalog:        true" >> $file
    echo "tags:" >> $file
    echo "    - A" >> $file
    echo "    - B" >> $file
    echo "---" >> $file

    echo "$file is created successfully!"
    code $file >> /dev/null 2>&1
}


init_keynote() {
    # $1: name
    # $2: title
    # $3: date
    file="_posts/$3-$1.md"
    touch $file
    echo "---" >> $file
    echo "layout:         keynote" >> $file
    echo "title:          $2" >> $file
    echo "subtitle:       XXX" >> $file
    echo "date:           $3" >> $file
    echo "author:         bythew3i" >> $file
    echo "iframe:         Slides Path" >> $file
    echo "navcolor:       invert" >> $file
    echo "tags:" >> $file
    echo "    - A" >> $file
    echo "    - B" >> $file
    echo "---" >> $file

    echo "$file is created successfully!"
    code $file >> /dev/null 2>&1
}

init_page() {
    # $1: name
    # $2: title
    file="$1.html"
    touch $file
    echo "---" >> $file
    echo "layout:         page" >> $file
    echo "title:          $2" >> $file
    echo "description:    XXX" >> $file
    echo "header-img:     XXX" >> $file
    echo "header-mask:    0.5" >> $file
    echo "hide-in-nav:    true" >> $file
    echo "---" >> $file

    echo "$file is created successfully!"
    code $file >> /dev/null 2>&1
}

init_default() {
    # $1: name
    # $2: title
    file="$1.html"
    touch $file
    echo "---" >> $file
    echo "layout:         default" >> $file
    echo "title:          $2" >> $file
    echo "description:    XXX" >> $file
    echo "header-img:     XXX" >> $file
    echo "header-mask:    0.5" >> $file
    echo "hide-in-nav:    true" >> $file
    echo "---" >> $file

    echo "$file is created successfully!"
    code $file >> /dev/null 2>&1
}

echo "Layouts:"
echo "  - [P]OST"
echo "  - [T]EXT"
echo "  - [K]EYNOTE"
echo "  - [PA]GE"
echo "  - [D]EFAULT"
read -p 'Please choose a layout (p): ' btw_type
read -p 'Please enter a title: ' btw_title

if [[ -z "$btw_title" ]]; then
    echo "Error: Title can not be empty"
    exit 1
fi
btw_name=$(tr -d [:punct:] <<< $btw_title)
btw_name=$(tr [A-Z] [a-z] <<< $btw_name)
btw_name=${btw_name// /-}
# echo $btw_name


prompt_date() {
    read -p 'Please enter a date YYYY-MM-DD: ' btw_date
    if [[ -z "$btw_date" ]]; then
        btw_date=$(date +'%Y-%m-%d')
    fi
    date -f "%Y-%m-%d" -j $btw_date >/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "Error: Date $btw_date is not a valid YYYY-MM-DD date"
        exit 1
    fi
}


btw_type="$(tr [A-Z] [a-z] <<< "$btw_type")"
case $btw_type in 
    "k" | "keynote")
        echo "keynote"
        prompt_date
        init_keynote "$btw_name" "$btw_title" "$btw_date"
        ;;
    "pa" | "page")
        init_page "$btw_name" "$btw_title"
        ;;
    "d" | "default")
        init_default "$btw_name" "$btw_title"
        ;;
    "t" | "text")
        prompt_date
        echo $btw_date
        init_post "$btw_name" "$btw_title" "$btw_date" 0
        ;;
    *)
        prompt_date
        init_post "$btw_name" "$btw_title" "$btw_date" 1
        ;;
esac
