#!/bin/bash

#==== Munin dirs / default config ====#

	munin_conf_dir="/etc/munin"
	munin_html_dir="/var/www/munin"
	munin_tmpl_dir="$munin_conf_dir/templates"
	
	#Deal with ubuntu path case (it uses cache)
	if [ ! -d $munin_html_dir ]
	then
	    munin_html_dir="/var/cache/munin/www"
	fi

	path_munin_conf="$munin_conf_dir/munin.conf"

#==== Mobile Munin default config ====#
	
	#Config file
	mob_conf="munin-mobile.conf"

	#Mobile Template dir
	mob_tmpl_dir="templates-mobiles"

	#Mobile HTML dir
	src_mob_html_dir="mobile-www"
	dest_mob_html_dir="mobile"	
	
	#Mobile cron script 
	mob_script="update-mobile.sh"

#=== Final install paths ===#

	path_conf="$munin_conf_dir/$mob_conf_file"
	path_tmpl="$munin_conf_dir/$mob_tmpl_dir"
	path_html="$munin_html_dir/$dest_mob_html_dir"
	path_script="$munin_conf_dir/$mob_cron_script"


#=== Program start ===#

echo ""
echo "Mobile Munin Template Installer"
echo ""
echo "This will create the following directories: "
echo " .$path_html" 
echo " .$path_tmpl"
echo ""
echo "And copy the following files:"
echo " ./$mob_conf   -> $path_conf"
echo " ./$mob_tmpl_dir/* -> $path_tmpl/"
echo " ./$src_mob_html_dir/*        -> $path_html/*"
echo " ./$mob_script    -> $path_script"
echo ""
echo "It also sets the permissions to the same as your munin files"
echo ""
echo "############################################################"
echo ""

if [ $1 ]
then
    if [ $1 == "--auto" ]
    then
	    echo "- Auto-continue supplied as argument"
	    continue='Y'
     else
	echo -n "Continue? [Y]: "
	read continue
     fi
else
    echo -n "Continue? [Y]: "
    read continue
fi

if [[ $continue == "Y" || $continue == "y" ]]; then
        echo "- Continuing..."
        echo ""
else
        echo "OK, exiting."
        exit
fi

if [ -f $path_conf ]
then
    echo "-  $path_conf       - file exists! (not copied)"
else
    echo "- ./$mob_conf -> $path_conf"
    cp `pwd`/$mob_conf $path_conf
    chown $path_conf --reference=$path_munin_conf
fi    

echo "- ./$mob_tmpl_dir                 -> $path_tmpl"

if [ ! -d $path_tmpl ]
then
    mkdir $path_tmpl
fi

cp `pwd`/$mob_tmpl_dir/* $path_tmpl/
chown -R $path_tmpl --reference=$munin_tmpl_dir

echo "- ./$src_mob_html_dir                   	     -> $path_html"

if [ ! -d $path_html ]
then
    mkdir $path_html
fi

cp -r `pwd`/$src_mob_html_dir/* $path_html 
chown -R $path_html --reference=$munin_html_dir 

echo "- ./$mob_script                 -> $path_script"

cp $mob_script $path_script
chown $path_script --reference=$path_conf

chmod 755 $path_script

echo ""
echo "Finished!"


