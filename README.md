Kohana with Twitter bootstrap: Auto Generator
============================================================

Kohana HMVC with Twitter Bootstrap Generator  
**What it does?**  
* It makes a ready to develop web app on Kohana MVC along with Twitter Bootstrap UI framework.  
* First it downloads kohana, twitter bootstrap, jquery etc.  
* Secondly it makes necessary changes on the kohana boostrap and allocates UI assets.  
* Then it creates two types of routes for accessing front end and backend of the developing app.  
* It also makes changes on the default controller class and creates a view for it.  
* Also you can create a set of MVC (model, view, controller) classes/files by using create command.  
* Finally you can open the app in browser using open command.  

**Installation**  
* I assuem you have downloaded the `kohanastrap.sh` file on your home.  
* Open up the terminal. Change its permission by `chmod +x ~/kohanastrap.sh`  
* Make a symlink of it by `sudo ln -s ~/kohanastrap.sh /usr/bin/kohanastrap`  
* Type `kohanastrap` from inside any directory and talk with it.  
* I assume, you will enter into yout htdocs OR www directory and type `kohanastrap init` and then it will
build up a ready to develop web app using twitter bootstrap as template.  
* If you want to create a set of MVC files/classes such as a Controller, a Model and a View for managing users of your app, then type `kohanastrap User` and Done! Check inside your classes, views directory.  
* Finally run your web app using the command `kohanastrap open` and it will open your browser with two additional tabs containing
the URLs of front end and backend of your newly created app (If you are in Mac). Otherwise, Open the browser and go to 
[http://localhost/kohana/] (http://localhost/kohana/) OR [http://127.0.0.1/kohana/] (http://127.0.0.1/kohana/) if you are in other than Mac.  

**Demo**  
You can see an implemenation here: [http://youtu.be/h97NBcLANwU](http://youtu.be/h97NBcLANwU)

**Precautions**  
* Make sure `wget` works in your system. Also make sure your php has cURL, mcrypt, GD enabled and Apache has mod_rewrite 
enabled. Those are needed to kohana.  
