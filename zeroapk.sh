#!/bin/bash

CYAN=$(tput setaf 8)
GREEN=$(tput setaf 10)
NON=$(tput sgr0)
RED=$(tput setaf 1)
apkurl="https://apkcombo.com"

search="$1"
url="$apkurl/pt/developer/$search"

function getLinkPagesRelated() {
    extractedLinksFrom=$(curl -sf "$url" | awk -F'"' '/class="l_item"/{print "'$apkurl'" $4}')
    [[ -z "$extractedLinksFrom" ]] && 
	    echo "$RED[Exiting]$NON Ops! Seems that you've entered a wrong author name (0 App Results Found)" &&
    exit
}

function fetchEachLink() {
    echo "$extractedLinksFrom" | while read link; do
        apkComponentName=$(echo "$link" | awk -F '/' '{print $(NF-1)}')
        getDownloadLinksRelated "$link" "$apkComponentName"
    done
}

function getDownloadLinksRelated() {
    echo "$GREEN[__MAIN__]$NON $link $GREEN [$apkComponentName]$NON"
    allLinkVersions=$(curl -sf "$link" | tr '"' '\n' | grep "$apkComponentName/download" | sed "s#^#$apkurl#g" | sort -u)
    echo "$allLinkVersions" | while read version; do
        versionName=$(echo $version | awk -F '/' '{print $NF}')
        echo "$CYAN[VERSIONS]$NON $version"
        getAllVersionsLinks "$version"
    done
}

function getAllVersionsLinks() {
    rawVersionLinks=$(curl -sf "$version" | tr '"' '\n' | grep -E 'cdn.down|gcdn\.apkcombo' | sort -u | sed 's/&amp;/\&/g')
    echo "$rawVersionLinks" | while read rawLink; do
        [[ ! -z "$rawLink" ]] &&
        echo "$CYAN[__RAW__]$NON $rawLink" &&
        prepareDownload "$rawLink"
    done
}

function prepareDownload() {
    echo "$RED[GETTING $versionName]$NON $rawLink"
    mkdir -p "$apkComponentName" &&
        wget -q -O "$apkComponentName/$versionName.apk" "$rawLink"
}
function stats(){
    [ ! -f ".tnkx" ] && touch .tnkx && 
    curl 2>&1 -o /dev/null -sf 'http://download.zerocool.cf/?tnks4down' # I Just want to know if ur testing it =)
}

main() {
    "stats" # You can remove it
    "getLinkPagesRelated"
    "fetchEachLink"
}

main
