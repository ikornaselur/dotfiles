# Termux bootstrapping

Playing around with Termux on Android. It's handy to have a script that sets up
the whole environment from the start. Given that all data is living in the app
data folder, uninstalling or even clearing the data from the app resets the
whole environment. Getting used to simply running this script for any change,
forces the environment to be fresh.

## Usage

To kickstart this off you can run the bootstrap.sh directly, which will clone
the repo and use it:

```
curl https://raw.githubusercontent.com/ikornaselur/dotfiles/master/termux/bootstrap.sh | sh
```