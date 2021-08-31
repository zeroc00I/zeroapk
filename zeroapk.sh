#!/bin/bash
CYAN=`tput setaf 8`
GREEN=`tput setaf 10`
NON=`tput sgr0`
apkurl="https://apkcombo.com"

search="$1"
url="$apkurl/pt/search?q=$search#gsc.tab=0&gsc.q=$search&gsc.page=1"

function getLinkPagesRelated(){
extractedLinksFrom=`curl -sf "$url" | awk -F'"' '/class="l_item"/{print "'$apkurl'" $4}'`
}

function fetchEachLink(){
echo "$extractedLinksFrom" | while read link; do
apkComponentName=`echo "$link" | awk -F '/' '{print $(NF-1)}'`
getDownloadLinksRelated "$link" "$apkComponentName";done
}

function getDownloadLinksRelated(){
echo "$GREEN[__MAIN__]$NON $link $GREEN [$apkComponentName]$NON"
allLinkVersions=`curl -sf "$link"| tr '"' '\n' |grep "$apkComponentName/download" | sed "s#^#$apkurl#g" |sort -u`
echo "$allLinkVersions" | while read version;do
echo "$CYAN[VERSIONS]$NON $version"
getAllVersionsLinks "$version";done
}

function getAllVersionsLinks(){
rawVersionLink=`curl -sf "$version" | tr '"' '\n' | grep 'cdn.down' | sort -u`
echo "$CYAN[__RAW__]$NON $rawVersionLink"
}

function prepareDownload(){
mkdir "$apkComponentName" &&
cd "$apkComponentName" &&
wget -O 
}

main(){
"getLinkPagesRelated"
"fetchEachLink"
}

main
