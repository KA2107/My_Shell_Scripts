## Originally written by aysiu from the Ubuntu Forums
## This is GPL'ed code
## So improve it and re-release it

## Define portion to make pcmanfm the default if that appears to be the appropriate action
makepcmanfmdefault()
{
## I went with --no-install-recommends because
## I didn't want to bring in a whole lot of junk,
## and Jaunty installs recommended packages by default.
echo -e "\nMaking sure pcmanfm is installed\n"
sudo apt-get update && sudo apt-get install pcmanfm --no-install-recommends

## Does it make sense to change to the directory?
## Or should all the individual commands just reference the full path?
echo -e "\nChanging to application launcher directory\n"
cd /usr/share/applications
echo -e "\nMaking backup directory\n"

## Does it make sense to create an entire backup directory?
## Should each file just be backed up in place?
sudo mkdir nonautilusplease
echo -e "\nModifying folder handler launcher\n"
sudo cp nautilus-folder-handler.desktop nonautilusplease/

## Here I'm using two separate sed commands
## Is there a way to string them together to have one
## sed command make two replacements in a single file?
sudo sed -i -n 's/nautilus --no-desktop/pcmanfm/g' nautilus-folder-handler.desktop
sudo sed -i -n 's/TryExec=nautilus/TryExec=pcmanfm/g' nautilus-folder-handler.desktop
echo -e "\nModifying browser launcher\n"
sudo cp nautilus-browser.desktop nonautilusplease/
sudo sed -i -n 's/nautilus --no-desktop --browser/pcmanfm/g' nautilus-browser.desktop
sudo sed -i -n 's/TryExec=nautilus/TryExec=pcmanfm/g' nautilus-browser.desktop
echo -e "\nModifying computer icon launcher\n"
sudo cp nautilus-computer.desktop nonautilusplease/
sudo sed -i -n 's/nautilus --no-desktop/pcmanfm/g' nautilus-computer.desktop
sudo sed -i -n 's/TryExec=nautilus/TryExec=pcmanfm/g' nautilus-computer.desktop
echo -e "\nModifying home icon launcher\n"
sudo cp nautilus-home.desktop nonautilusplease/
sudo sed -i -n 's/nautilus --no-desktop/pcmanfm/g' nautilus-home.desktop
sudo sed -i -n 's/TryExec=nautilus/TryExec=pcmanfm/g' nautilus-home.desktop
echo -e "\nModifying general Nautilus launcher\n"
sudo cp nautilus.desktop nonautilusplease/
sudo sed -i -n 's/Exec=nautilus/Exec=pcmanfm/g' nautilus.desktop

## This last bit I'm not sure should be included
## See, the only thing that doesn't change to the
## new pcmanfm default is clicking the files on the desktop,
## because Nautilus is managing the desktop (so technically
## it's not launching a new process when you double-click
## an icon there).
## So this kills the desktop management of icons completely
## Making the desktop pretty useless... would it be better
## to keep Nautilus there instead of nothing? Or go so far
## as to have Xfce manage the desktop in Gnome?
echo -e "\nChanging base Nautilus launcher\n"
sudo dpkg-divert --divert /usr/bin/nautilus.old --rename /usr/bin/nautilus && sudo ln -s /usr/bin/pcmanfm /usr/bin/nautilus
echo -e "\nRemoving Nautilus as desktop manager\n"
killall nautilus
echo -e "\npcmanfm is now the default file manager. To return Nautilus to the default, run this script again.\n"
}

restorenautilusdefault()
{
echo -e "\nChanging to application launcher directory\n"
cd /usr/share/applications
echo -e "\nRestoring backup files\n"
sudo cp nonautilusplease/nautilus-folder-handler.desktop .
sudo cp nonautilusplease/nautilus-browser.desktop .
sudo cp nonautilusplease/nautilus-computer.desktop .
sudo cp nonautilusplease/nautilus-home.desktop .
sudo cp nonautilusplease/nautilus.desktop .
echo -e "\nRemoving backup folder\n"
sudo rm -rf nonautilusplease
echo -e "\nRestoring Nautilus launcher\n"
sudo rm /usr/bin/nautilus && sudo dpkg-divert --rename --remove /usr/bin/nautilus
echo -e "\nMaking Nautilus manage the desktop again\n"
nautilus --no-default-window &

## The only change that isn't undone is the installation of pcmanfm
## Should pcmanfm be removed? Or just kept in?
## Don't want to load the script with too many questions?
}



## Make sure that we exit if any commands do not complete successfully.
## Thanks to nanotube for this little snippet of code from the early
## versions of UbuntuZilla
set -o errexit
trap 'echo "Previous command did not complete successfully. Exiting."' ERR


## This is the main code
## Is it necessary to put an elseif in here? Or is
## redundant, since the directory pretty much
## either exists or it doesn't?
## Is there a better way to keep track of whether
## the script has been run before?
if [[ -e /usr/share/applications/nonautilusplease ]]; then

restorenautilusdefault

else

makepcmanfmdefault

fi;
