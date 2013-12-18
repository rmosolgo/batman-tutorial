---
layout: chapter
---

# Install Batman.js

Let's get your app up and running. In this chapter, we'll cover loading batman.js in your application and routing requests to your batman.js app.


## Ruby on Rails

### Make a new Rails app

Once you have your [Ruby/Rails environment](#todo) set up, you're ready to start the project. Open your console and run these commands:

```
$ cd ~              # navigate to your home directory
$ mkdir code        # make a new directory
$ cd code
$ rails new events  # make a new rails app called 'events'
$ cd events         # navigate to your Rails root (the directory where your application code lives)
```

Rails provides a huge amount of structure for your app. You can get an intro to the different folder from the [Rails Guides](http://guides.rubyonrails.org/getting_started.html#creating-the-blog-application). Notice that it also created a new directory, `~/code/events`. This will be called our _Rails root_.

## Install Batman-rails

Open up `Gemfile` and add:

{% highlight ruby %}
gem 'batman-rails'   # provides batman.js generators
{% endhighlight %}

Then install them by running this command in your console:

```
$ bundle install
```

Now that the `batman-rails` gem is installed, you can use it to set up your batman.js app. Run this command in your console:

```
$ rails generate batman:app
```

This command provides the scaffold for our application. Notice that it put folders and files inside `app/assets/javascripts/batman`. From now on, that will be called our _batman root_. Let's make sure everything is running correctly. Start your Rails app with this command:

```
$ rails server
```

Then open your browser of choice and visit `http://localhost:3000` (this is your app's _root path_). You should see the batman.js landing page, `"You're set up with batman-rails!"`. Running `rails server` is necessary whenever you're working on your batman.js app.

## Other Backend

- a copy of Batman.js, jQuery, and batman.jquery.js
- dir for coffee and js files
- write npm script to compile coffee into one JS file
- include the JS file in your main page (it's a single-page application)


## Batman.js

Your app should have the following structure:

```
- Batman root
  - events.js.coffee
  - models/
  - controllers/
    - application_controller.js.coffee
  - views/
  - html/
```

_If your app has other files, don't worry about them!_

Start your development server and visit your app's _root path_ ("/"). Open your browser's JavaScript console and make sure the global variable `Batman` is defined. If so, you're ready for the next chapter!












