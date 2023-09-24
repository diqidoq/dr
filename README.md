# di
Drupal Install (di) is a simple sh based command line tool which combines terminal repo checks and tasks with commands of Drush and Composer to unify and abbreviate (short) the daily experience of **installing** and **removing** of Drupal extensions in command line enviroments. 

NOTE: At the moment the script is for Drupal extensions (no vendor tasks) only and targeted mainly to bash shell but with sh* cross compatible commands. Cross compatibility to other shells and other parts of a Drupal project like Drupal>Composer dependencies are planned. Feel free to contribute to it.

## How to install
Simply clone this repo (or download it) and move di & dr to your command line tools folder, mostly common is the user bin folder. Or create one if you don't have one. Make sure this bin folder is added to your PATH and di and dr are set as executables. If you are new to this read about executable scripts and how to access them on your machine. Seach engines are full of tutorials on this.

## Requirements
[Composer](https://getcomposer.org) and [Drush](https://www.drush.org) accessable in your Drupal ^8|^9|^10 root. NOTE: For Drupal before 10 you need [Drush Launcher](https://github.com/drush-ops/drush-launcher) that di detects Drush correctly. For Drupal 10 and higher other workarounds are recommended. Read more about the reasons and solutions at [this Drush Launcher issue](https://github.com/drush-ops/drush-launcher/issues/105) or follow this [little bash config trick](https://github.com/drush-ops/drush-launcher/issues/105#issuecomment-1621097643) by awesome Drupal community member and long-term contributor @chx.

## How to use
Install or remove multiple Drupal extensions in one simple line. Simply type one of the following:

 - ```di extension-machine-name```
 - ```di extension-machine-name1 extension-machine-name2```
 - ```di extension-machine-name1, extension-nachine-name2```

to get (require) a Drupal module or other extension via Composer and it will do the rest for you with help of Composer, some SHELL, PHP and some checks and finally with Drush if wanted. Same commands with an -r flag as first will invert the behaviour of di and uninstall via Drush and remove multiple extensions via Composer.

## Feel free to use but consider support
I think the best of Open Source is sharing knowlegde so please consider helping here to make it a better tool with issue reports and patches/merges when you use this tool. So we all win and you will get an improved tool on each release.
