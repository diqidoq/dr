# di
... is a simple sh based lazy typer command line tool and wrapper which combines terminal repo checks and tasks with commands of Drush and Composer to unify and abbreviate (shorten) the daily experience of **installing/updating** and **removing** of Drupal extensions, setting up new projects, creating backups, repair permissions and more in command line enviroments. (Primary focused on simple "default version" installations of extensions without version specific arguments yet.). It is helpful when playing around with default Drupal in command line and for Weekend Drupalers who cannot remember all the long commands every once a while needed to go on with playing around on Drupal.

We make spaghetti commands like ```composer require drupal/modul1 drupal/module2 drupal/module3 && drush en module1 module2 module3 && drush cr``` to simply ```di module1 module2 module3```. Text file lists are supported like ```di modules.txt```, ```di modules-log``` (or later supported @todo  ```di modules.csv```).

But these are splitted tasks and will be confirmed so ```di module``` can also be used to simply enabling or disabling a module. For example: The -r flag inverts the command and goes thru the process of disabling and removal. The -tp flag lists all variants (bundle types) of your given entity type. And these commands have shortlink wrappers. So di -r can be called with dr, and di -bkp can be called with dbkp and so on.

 - Project website: [https://diqidoq.github.io/di](https://diqidoq.github.io/di)
 - Github repository: [https://github.com/diqidoq/di](https://github.com/diqidoq/di)

**WARNING**: At the moment the script only supports Drupal project roots build like ```drupal/web/core``` with ```drupal/web/sites/default/files``` etc like provided by the Drupal Composer project-recommended repository. More variants of project trees are planned. This script has been initially developed for internal use in our offices only and we want to make it available public as a contribution to the wonderful Drupal community. So some tasks are still remaining for a full cross compatible public version yet.

### Limitations and future plans
NOTE: At the moment the install and removal part of the script is for Drupal extensions only (no other vendor packages yet) and is targeted mainly to bash shell, but with sh* cross compatible commands and future plans. Cross compatibility to other shells and other parts of a Drupal project packages like Drupal Composer dependencies are planned. Feel free to contribute to it here on github.

## How to install
Simply clone the Github repository (or download it) which can be found under [https://github.com/diqidoq/di](https://github.com/diqidoq/di) and move or symlink the executable files inside bin/ to your command line tools folder. Common is the username/bin or /usr/local/bin folder. Or create one if you don't have one. Make sure this bin folder is added to your PATH and the command executables are set as executables with ```chmod u+x```. If you are new to this read about executable scripts and how to access them on your machine. Seach engines are full of tutorials on this. Using sym links has the advantage of using updated versions automatically on each git pull or new clone.

### Example installation 
If your executables folder would be under yourusername/bin and your default shell is bash, then the install commands what look like this:

```
cd userfolder
git clone git@github.com:diqidoq/di.git
ln -s ~/di/bin/* ~/bin/
chmod u+x ~/bin/*
source ~/.bashrc
```  

You can test it in a Drupal root with ```derr``` or ```dwarn``` for example to get Drupal system errors or warnings from reports of level 1 and 2 very quick. Or with ```di coffee``` to simply require and install (enable) the latest version of the gorgeous coffee module compatible with your Drupal version.

## Requirements
[Composer](https://getcomposer.org) and [Drush](https://www.drush.org) accessable in your Drupal ^8|^9|^10 root. NOTE: For Drupal before 10 you need [Drush Launcher](https://github.com/drush-ops/drush-launcher) that ```di``` detects Drush correctly. For Drupal 10 and higher other workarounds are recommended. Read more about the reasons and solutions at [this Drush Launcher issue](https://github.com/drush-ops/drush-launcher/issues/105) or follow this [little bash config trick](https://github.com/drush-ops/drush-launcher/issues/105#issuecomment-1621097643) by awesome Drupal community member and long-term contributor @chx.

## How to use
Install, checkout, update or remove multiple Drupal extensions in one simple line. Simply type one of the following:

 - ```di extension-machine-name```
 - ```di extension-machine-name1 extension-machine-name2```
 - ```di extension-machine-name1, extension-nachine-name2```

to get a Drupal module or other extension via Composer, and it will do the rest for you with help of Composer, some SHELL, PHP and some checks and finally with Drush if wanted. Same commands with a leading ```-r``` flag will invert the behaviour of ```di``` and uninstall via Drush and remove multiple extensions via Composer. Or you can use the sortlink ```dr``` instead of ```di -r```. Same goes for ```di -c``` (checkout/info) using ```dc``` or ```di -s``` (show outdated) using ```ds```. And so on. @todo Tutorials and code examples will follow one day.

The list of all shortlink commands regarding di can be found in [https://github.com/diqidoq/di/tree/main/bin](https://github.com/diqidoq/di/tree/main/bin). Some need arguments like extension1 extension2 but some are global short commands like dprm for permission repair.

## Feel free to use but consider support
I think the best of Open Source is sharing knowlegde so please consider helping here to make it a better tool with issue reports and patches/merges when you use this tool. So we all win and you will get an improved tool on each release.
