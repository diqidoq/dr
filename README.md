# di
Drupal Install (di) is a simple sh based command line tool in combination of Drush and Composer commands to unify installing Drupal extensions in terminal. At the moment targeted to bash but mainly with sh* cross compatible commands.

# How to install
Simply clone this repo (or download it) and move di & dr to your command line tools folder, mostly common is the user bin folder. Or create one if you don't have one. Make sure this bin folder is added to your PATH and di and dr are set as executables. If you are new to this read about executable scripts and how to access them on your machine. Seach engines are full of tutorials on this.

# Requirements
Composer and Drush accessable in your Drupal ^8|^9|^10 root.

# How to use
Simply type 'di extension-machine-name' or 'di extension-machine-name1 extension-machine-name2' or ''di extension-machine-name1, extension-nachine-name2'' to require a Drupal module or other extension via Composer and it will the rest for you with help of Comoser and Drush

# Feel free to use but consider support
I think the best of Open Source is sharing knowlegde so please consider helping here to make it a better tool with issue reports and patches/merges when you use this tool. So we all win and you will get an improved tool on each release.
