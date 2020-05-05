<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# APT-GET (Argument Summary)


## update

* Update is used to resynchronize the package index file from their sources The indexes of available packages are fetched from the locations specified in /etc/apt/sources.list. Update should do before “upgrade” or “dist-upgrade” so that apt-get knows that new versions of packages are available 


## upgrade

* Upgrade is used to install newest versions of all packages currently installed on the system from sources enumerated in /etc/apt/sources.list


## dist-upgrade

* dist-upgrade also intelligently handels changing dependencies with new versions of packages.
* It attempt to upgrade the most important pacakges at the expense of less important ones if necessary


## dselect-upgrade

* No mention here


## install

* The /etc/apt/sources.list file is used to locate the desired packages. 
* If a hyphen is appended to the package name (with no intervening space), the identified package will be removed if it is installed.
* A plus sign can be used to designate a package to install


## remove

* Similar with install instead of removing package files
* remove is not to delete configuration files in system


## Source-list file

* When ‘update’ command is run, ‘apt’ program fetches the new packages file by reading ‘source-list’ file. The file consists of deb http uri with parameters
* The format of line is <Archive Type> <Repository URL> <Distribution> <Component>

* Archive Type
    * deb
        * The pre-compiled packages (binary)
    * deb-src
        * Original program sources and Debian control file

* Repository URL
    * Indicates the url to download packages from

* Distribution
    * Is release code name/alias (jessie, stretch, buster, etc.) or the release class (oldstable, stable, testing, unstable)

* Component
    * **main** consists of “DFSG(Debian Free Software Guidelines)-compliant” packages
        * Don’t rely on software outside this area to operate
        * So, only packages considered part of the Debian distribution
    * **contrib** consists of “DFSG-compliant” but, have dependencies not in main
    * **non-free** consists of software that doesn’t comply with the DFSG


## Debian Free Software Guidelines (DFSG)

* If we follow this guidelines to the software, It’s DFSG-compliant software Hereare some guidelines …
    1. Free Redistribution
    2. Source code
    3. Derived Works
    4. Integrity of The Author’s Source Code
    5. No Discrimination Against Persons or Groups
    6. No discrimination Against Fields of Endeavor
    7. Distribution of License
    8. License Must Not Be Specific to Debian
    9. License Must Not Contaminate Other Software
