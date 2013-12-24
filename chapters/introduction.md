---
title: Introduction
layout: chapter
---

This tutorial will guide you through building a web app for scheduling events.

For general information about batman.js, also check out:

- [Batman.js website](http://batmanjs.org)
- [Batman.js mailing list](https://groups.google.com/forum/#!forum/batmanjs)

This tutorial is inspired by [Michael Hartl's Rails Tutorial](http://ruby.railstutorial.org/) which is an incredible resource for anyone who wants to learn web programming.

<a name="why_batman_js"></a>

### Why batman.js?
- __Powerful data-binding.__ batman.js features first-class data-binding, baked into the framework from the very start. For the user, this means live-updating pages. For the developer, this means not calling `render` over and over again.

- __Rails- (and human-)friendly API.__ The batman.js API is meant to be familiar to Rails developers. Not a Rails developer? Have no fear: "Rails-friendly" also means human-friendly. The Rails API (and the batman.js API) is meant to enable readable, intuitive application code.

- __Designed for CoffeeScript.__ [CoffeeScript](http://coffeescript.org/) is a "little language that compiles into JavaScript." A few advantages are: smart compilation (eg, syntax checks and automatic scoping), classical inheritance, powerful new features (eg, list comprehensions and destructuring assignment) and a clear, concise API. CoffeeScript syntax is inspired by Python, Ruby and JavaScript, so if you've ever programmed for the web, you should feel right at home.

- __Templates in pure HTML.__ batman.js views render into pure HTML templates. batman.js uses Liquid-style filter syntax which is powerful and familiar to many designers.

<a name="what_do_i_need_to_start"></a>

### What do I need to start?
- __Basic knowledge of HTML and CSS.__ Nothing fancy, just a basic familiarity. If you don't know it already, take an online tutorial. W3schools.com offers free, interactive tutorials in [HTML](http://www.w3schools.com/html/) and [CSS](http://www.w3schools.com/css/)

- __A working Ruby/Rails environment _or_ knowledge of another web programming framework.__ If you don't meet this requirement, check out [Setting Up Rails](#todo) to get going with Ruby on Rails. If you're using a framework other than Rails, simply ignore the Rails-specific parts of this tutorial.

- __A text editor or IDE.__ You'll need something to edit your code. This tutorial will use [Sublime Text](https://www.sublimetext.com), a top-notch text editor for all platforms.

- __A console window.__ New to the console? Check out [developing in the console](#todo).
