#! /bin/sh

function help () {
    echo "    What it does?"
    echo "    It makes a ready to develop web app on Kohana MVC along with Twitter Bootstrap UI framework." 
    echo "    First it downloads kohana, twitter bootstrap, jquery etc."
    echo "    Secondly it makes necessary changes on the kohana boostrap and allocates UI assets."
    echo "    Then it creates two types of routes for accessing front end and backend of the developing app."
    echo "    It also makes changes on the default controller class and creates a model and a view for it."
    echo "    Also you can create a set of MVC (model, view, controller) classes by using create command."
    echo ""
    echo "    kohanastrap init                  - Initalize a ready to access web app";
    echo "    kohanastrap create ClassName   	- creates two class files and one view file";
    echo "    kohanastrap open                   - open app in browser";
}

KOHANA="https://github.com/downloads/kohana/kohana/kohana-3.3.0.zip"
TWITTER_BOOTSTRAP="http://twitter.github.io/bootstrap/assets/bootstrap.zip"
JQUERY="http://code.jquery.com/jquery-latest.min.js"

if [ $1 ] 
then
	case "$1" in
	   init)
			echo "Downloading Kohana HMVC 3.X ..."
			wget --no-check-certificate $KOHANA 
			unzip `basename $KOHANA` 
			rm `basename $KOHANA` 			 
			if which xattr > /dev/null && [ "`xattr kohana/index.php`" = "com.apple.quarantine" ]
			then
			  xattr -d com.apple.quarantine SpecRunner.html
			fi
			echo "Downloaded and extracted Kohana!"

			cd kohana/
			echo "Setting permission to kohana cache and logs directory ..."
			if which xattr > /dev/null
				then
					chmod -R 0777 application/cache
					chmod -R 0777 application/logs
			else	    
				chmod 0777 -R application/cache
				chmod 0777 -R application/logs
			fi
			find . -type d -exec chmod 0755 {} \;
			echo "Changing permissions, Done!"

			echo "Renaming kohana install file ..."
			mv install.php _install.php	
			echo "Insllation file renamed!"

			echo "Setting cookie salt in bootstrap.php ..."
			sed -i "" "65a\\
			/*\\
			\ * Set the cookie salt\\
			\ */\\
			Cookie::\$\salt = 'foobar';\\
			\\
			" application/bootstrap.php
			echo "cookie salt placed in bootstrap.php"	

			echo "creating htaccess file for user friendly URL ..."
			rm example.htaccess
			echo '
# Turn on URL rewriting
RewriteEngine On

# Installation directory
RewriteBase /kohana/

# Protect hidden files from being viewed
<Files .*>
	Order Deny,Allow
	Deny From All
</Files>

# Protect application and system files from being viewed
RewriteRule ^(?:application|modules|system)\b.* index.php/$0 [L]

# Allow any files or directories that exist to be displayed directly
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d

# Rewrite all other URLs to index.php/URL
RewriteRule .* index.php/$0 [PT]
' > .htaccess
			echo "Basic kohana application ready!!!"

			mkdir assets
			cd assets/
			echo "Downloading Twitter Bootstrap ..."
			wget $TWITTER_BOOTSTRAP
			unzip `basename $TWITTER_BOOTSTRAP`
			rm `basename $TWITTER_BOOTSTRAP`
			mv bootstrap/* .
			rm -rf bootstrap
			echo "Twitter Bootstrap downloaded and assets allocated!"
			cd ..

			echo "Creating and spliting views/templates for front end ..."
	    	echo '
<!DOCTYPE html>
<html>
<head>
<title>Bootstrap 101 Template</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Bootstrap -->
<link href="assets/css/bootstrap.min.css" rel="stylesheet" media="screen">

<style>
		body {
	padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
		}
</style>    

</head>
<body>

	<?php if(isset($navigation)) echo $navigation; ?>
	<?php if(isset($content)) echo $content; ?>

	<script src="http://code.jquery.com/jquery.js"></script>
	<script src="assets/js/bootstrap.min.js"></script>
</body>
</html>' > application/views/template_front.php

			echo '
<div class="navbar navbar-inverse navbar-fixed-top">
  	<div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="#">Project name</a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
  	</div>
</div>' > application/views/navigation.php

echo '
<div class="container">
	<h1>Bootstrap starter template</h1>
	<p>Use this document as a way to quick start any new project.<br> All you get is this message and a barebones HTML document.</p>
</div> <!-- /container -->' > application/views/content.php		
        	echo "Views for front end, Done!"
        	
        	echo "Editing Welcome controller class ..."
        	echo '
<?php defined("SYSPATH") or die("No direct script access.");

class Controller_Welcome extends Controller_Template {

    public $template = "template_front";
    
    public function before()
    {
        parent::before();
    }

	public function action_index()
	{
		$navigation = View::factory("navigation");
		$content = View::factory("content");


		$this->template->navigation = $navigation->render();
		$this->template->content = $content->render();
	}

} // End Welcome
' > application/classes/Controller/Welcome.php
			echo "Front end of your kohana application is ready!!!  visit http://127.0.0.1/kohana/"
		
			echo "Adding a new route for admin panel access in bootstrap.php ..."
			sed -i "" "129a\\
			Route::set('admin', '<directory>(/<controller>(/<action>(/<id>)))', \\
				array('directory' => '(admin|affiliate)')) \\
    			->defaults(array( 'controller' => 'auth', 'action' => 'login', )); \\
			\\
			" application/bootstrap.php	
			echo "Route for admin panel access added!"		

			mkdir application/views/admin

			echo "Creating and spliting views/templates for backend ..."
	    	echo '
<!DOCTYPE html>
<html>
<head>
<title>Admin panel</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- Bootstrap -->
<link href="../../assets/css/bootstrap.min.css" rel="stylesheet" media="screen">

<style>
	      body {
	        padding-top: 40px;
	        padding-bottom: 40px;
	        background-color: #f5f5f5;
	      }

	      .form-signin {
	        max-width: 300px;
	        padding: 19px 29px 29px;
	        margin: 0 auto 20px;
	        background-color: #fff;
	        border: 1px solid #e5e5e5;
	        -webkit-border-radius: 5px;
	           -moz-border-radius: 5px;
	                border-radius: 5px;
	        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
	           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
	                box-shadow: 0 1px 2px rgba(0,0,0,.05);
	      }
	      .form-signin .form-signin-heading,
	      .form-signin .checkbox {
	        margin-bottom: 10px;
	      }
	      .form-signin input[type="text"],
	      .form-signin input[type="password"] {
	        font-size: 16px;
	        height: auto;
	        margin-bottom: 15px;
	        padding: 7px 9px;
	      }
</style>    

</head>
<body>

	<?php if(isset($content)) echo $content; ?>

	<script src="http://code.jquery.com/jquery.js"></script>
	<script src="assets/js/bootstrap.min.js"></script>
</body>
</html>' > application/views/admin/template_back.php	

        	echo '
<div class="container">

  <form class="form-signin">
    <h2 class="form-signin-heading">Please sign in</h2>
    <input type="text" class="input-block-level" placeholder="Email address">
    <input type="password" class="input-block-level" placeholder="Password">
    <label class="checkbox">
      <input type="checkbox" value="remember-me"> Remember me
    </label>
    <button class="btn btn-large btn-primary" type="submit">Sign in</button>
  </form>

</div> <!-- /container -->' > application/views/admin/content.php		
        	echo "Views for backend, Done!"	

        	mkdir application/classes/controller/admin
        	echo "Creating Auth controller class for admin panel login view ..."	
        	echo '
<?php defined("SYSPATH") or die("No direct script access.");

class Controller_Admin_Auth extends Controller_Template {

    public $template = "admin/template_back";
    
    public function before()
    {
        parent::before();
    }

	public function action_login()
	{
		$content = View::factory("admin/content");
		$this->template->content = $content->render();
	}

} // End Admin/Auth' > application/classes/controller/admin/auth.php
			echo "Backend of your kohana application is ready!!! visit http://127.0.0.1/kohana/admin/auth/login"

	   ;;
	   create)
		    if [ $2 ]
		    then
		      echo "
<?php defined('SYSPATH') or die('No direct script access.');

class Controller_$2 extends Controller_Template {

    public $template = "template_front";
    
    public function before()
    {
        parent::before();
    }

	public function action_index()
	{

	}

}" > application/classes/controller/$2.php

		      echo "
<?php defined('SYSPATH') or die('No direct script access.');

class Model_$2
{
     public function __construct(\$db = NULL)
    {
        parent::__construct(\$db);

    }
}" > application/classes/model/$2.php

		      echo "
<h1>$2 HTML here!</h1>
" > application/views/$2.php

		      echo "$2 MVC created!!! Check classes and views directory!"
		    else
		      echo 'please mention MVC file name.'
		    fi	    
	   ;;
	   open)
		    if [ "`which open`" = '/usr/bin/open' ] 
		    then
		      open http://127.0.0.1/kohana/
		      open http://127.0.0.1/kohana/admin/auth/login
		    else
		      echo "Please open http://127.0.0.1/kohana/ AND http://127.0.0.1/kohana/admin/auth/login in your browser."
		    fi	    
	   ;;
	   *)
	      help
	   ;;
	esac
else
	help;
fi
