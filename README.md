# di
Drupal Install (di) is a simple sh based lazy typer command line tool and wrapper which combines terminal repo checks and tasks with commands of Drush and Composer to unify and abbreviate (shorten) the daily experience of **installing/updating** and **removing** of Drupal extensions in command line enviroments. (Primary focused on simple "default version" installations of extensions without version specific arguments yet.)

We make spaghetti commands like ```composer require drupal/modul1 drupal/module2 drupal/module3 && drush en module1 module2 module3 && drush cr``` to simply ```di module1 module2 module3```. Text file lists are supported like ```di modules.txt```, ```di modules-log``` (or later supported @todo  ```di modules.csv```).

But these are splitted tasks and will be confirmed so ```di module``` can also be used to simply enabling or disabling a module. The -r flag inverts the command and goes thru the process of disabling and removal.

NOTE: At the moment the script is for Drupal extensions only (no other vendor packages) and is targeted mainly to bash shell, but with sh* cross compatible commands. Cross compatibility to other shells and other parts of a Drupal project packages like Drupal Composer dependencies are planned. Feel free to contribute to it here on github

## How to install
Simply clone this repo (or download it) and move or symlink the executable files inside bin/ to your command line tools folder. Common is the username/bin or /usr/local/bin folder. Or create one if you don't have one. Make sure this bin folder is added to your PATH and the command executables are set as executables with ```chmod u+x```. If you are new to this read about executable scripts and how to access them on your machine. Seach engines are full of tutorials on this. Using sym links has the advantage of using updated versions automatically on each git pull or new clone.

## Requirements
[Composer](https://getcomposer.org) and [Drush](https://www.drush.org) accessable in your Drupal ^8|^9|^10 root. NOTE: For Drupal before 10 you need [Drush Launcher](https://github.com/drush-ops/drush-launcher) that ```di``` detects Drush correctly. For Drupal 10 and higher other workarounds are recommended. Read more about the reasons and solutions at [this Drush Launcher issue](https://github.com/drush-ops/drush-launcher/issues/105) or follow this [little bash config trick](https://github.com/drush-ops/drush-launcher/issues/105#issuecomment-1621097643) by awesome Drupal community member and long-term contributor @chx.

## How to use
Install, checkout, update or remove multiple Drupal extensions in one simple line. Simply type one of the following:

 - ```di extension-machine-name```
 - ```di extension-machine-name1 extension-machine-name2```
 - ```di extension-machine-name1, extension-nachine-name2```

to get a Drupal module or other extension via Composer, and it will do the rest for you with help of Composer, some SHELL, PHP and some checks and finally with Drush if wanted. Same commands with a leading ```-r``` flag will invert the behaviour of ```di``` and uninstall via Drush and remove multiple extensions via Composer. Or you can use the sortlink ```dr``` instead of ```di -r```. Same goes for ```di -c``` (checkout/info) using ```dc``` or ```di -s``` (show outdated) using ```ds```. And so on. @todo Tutorials and code examples will follow one day.

## Feel free to use but consider support
I think the best of Open Source is sharing knowlegde so please consider helping here to make it a better tool with issue reports and patches/merges when you use this tool. So we all win and you will get an improved tool on each release.
