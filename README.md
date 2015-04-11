# scotty
Simple Drag n Drop file to URL uploader

What does it do?
----------------
It places an icon on your Linux (gnome/mate) desktop.
You can drag a file to it and it is uploaded using rsync to your server,
into your personal public_html folder (or other web reachable location).
The web URL to this file is then placed in your clipboard, ready to be pasted into chats and emails.

Setup
-----

$ git clone http://github.com/osteffen/scotty.git
$ cd scotty
$ ./scotty.sh -makeLauncher
