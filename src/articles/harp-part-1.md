---
Title: "Let's Build: a static blog with Harp - Part 1"
Description: How to build a static blog site with Harp - Part 1
Type: Article
Date: 1/31/16
---

<article class="content">

# Let's Build: <small>a static blog with Harp - Part 1</small>

As part of my first Let's Build, we are going to build a static blog 
site utilizing [Harp](http://harpjs.com/). Harp is a Node based toolset 
that includes a static web server and preprocessing / compilation 
tools to take a variety of formats ([EJS](http://ejs.co/), 
[Markdown](http://daringfireball.net/projects/markdown/), Jade, LESS, Sass,
CoffeeScript) and convert them into their compiled / static assets
(HTML, CSS, and Javascript).

Harp makes it easy to focus on writing instead of configuration
and layout. In this series, we are going to utilize [EJS](http://ejs.co/) for our views,
[Markdown](http://daringfireball.net/projects/markdown/) for our blog articles, and some simple CSS for styling. Our 
demo site will be based on [Twitter Bootstrap](http://getbootstrap.com/) 
(specifically this [Blog Demo Component](http://getbootstrap.com/examples/blog/))

At the end of Part 1, we will have :
* A site layout with partials
* A couple content pages
* A functional site hosted on [Surge](https://surge.sh/)

You can follow along with me via Github by viewing the end of
each step here: [Step 1 Code](https://github.com/wkallhof/Harp-Bootstrap-Demo/tree/s1)

## Let's get started

First things first, make sure you have [NodeJs](https://nodejs.org/en/) installed.
Once you have done that, we need to use NPM to install Harp. I like
to do this globally so I can use it to generate new sites when
needed.

`$ npm install -g harp`

Once installed, let's make a new directory to hold our site. I should note
that Harp does come with an `init` command that will initialize
a new boilerplate project for you, however, I like to start from
scratch in order to understand the structure a bit better. For this article
we are going to start from scratch.

 At the start, we are going to need the following structure.
```
/ROOT
|-- /public
`-- harp.json
```

The `/public` folder will be used to contain the public facing content for
this blog. Anything outside of this folder will be inaccessible when running
on a server. The `/public` folder is a Harp construct, so it must be named public
in order for Harp to know how to handle the files. Alternatively, Harp does allow
you to treat the root as a public folder, but I like to play it safe and explicitly
provide the folder I want to use in case I need to keep things outside of it secret
(for example a readme.md for version control, etc.)

The `harp.json` file will contain global meta data to be used throughout
the site. Harp will make the contents of this file accessible in our
templates.

In this `harp.json` file we will add the following content:
```
{
    "globals": {
        "siteTitle": "Our Harp Blog",
        "seoDescription" : "Our harp Blog"
    }
}
```

The `globals` section will be exposed to our templates so we can use any of
the properties within for rendering. For example, we will
use the `siteTitle` property to set the site's Title. Feel free
to add any properties (with proper JSON structure) to this `globals` section
in order to use them throughout your site.

## Define our Layouts / Views

Now that we have the basic project structure set up, we can start adding
our views and view layouts via EJS. 

In our `/public` folder let's add the following files:

```
-- public/
    |-- _layout.ejs
    |-- index.ejs
    `-- about.ejs
```

Our `_layout.ejs` file introduces an important rule for Harp: **any files or folders prepended with
an underscore ('_') will be excluded from our final compiled output**. However,
these files can still be used to provide data or layout assistance to those files
that are exposed publicly (in this case, the `index` and `about` pages.

The `_layout.ejs` file will be used to house our global layout markup to be rendered
for every page in our site. This includes things like navigation and footer elements.
Essentially everything that wraps your article content will go in here.
In this file let's add the following markup:

``` html

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta name="description" content="<%= seoDescription %>">

    <title><%= siteTitle %></title>

    <!-- Bootstrap core CSS -->
    <link href="//getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="//getbootstrap.com/examples/blog/blog.css" rel="stylesheet">
    
  </head>

  <body>

    <div class="blog-masthead">
      <div class="container">
        <nav class="blog-nav">
          <a class="blog-nav-item active" href="/">Home</a>
          <a class="blog-nav-item" href="/about">About</a>
        </nav>
      </div>
    </div>

    <div class="container">

      <div class="blog-header">
        <h1 class="blog-title">The Bootstrap Blog</h1>
        <p class="lead blog-description">The official example template of creating a blog with Bootstrap.</p>
      </div>

      <div class="row">

        <div class="col-sm-8 blog-main">

          <%- yield %>

          <nav>
            <ul class="pager">
              <li><a href="#">Previous</a></li>
              <li><a href="#">Next</a></li>
            </ul>
          </nav>

        </div><!-- /.blog-main -->

        <div class="col-sm-3 col-sm-offset-1 blog-sidebar">
          <div class="sidebar-module sidebar-module-inset">
            <h4>About</h4>
            <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
          </div>

          <div class="sidebar-module">
            <h4>Elsewhere</h4>
            <ol class="list-unstyled">
              <li><a href="#">GitHub</a></li>
              <li><a href="#">Twitter</a></li>
              <li><a href="#">Facebook</a></li>
            </ol>
          </div>
        </div><!-- /.blog-sidebar -->

      </div><!-- /.row -->

    </div><!-- /.container -->

    <footer class="blog-footer">
      <p>Blog template built for <a href="http://getbootstrap.com">Bootstrap</a> by <a href="https://twitter.com/mdo">@@mdo</a>.</p>
      <p>
        <a href="#">Back to top</a>
      </p>
    </footer>


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="//getbootstrap.com/dist/js/bootstrap.min.js"></script>

  </body>
</html>


```

This is slightly modified markup from the 
[Twitter Bootstrap Blog Example](http://getbootstrap.com/examples/blog/).
Within this layout, you will notice some EJS templating functionality.
* `<meta name="description" content="<%= seoDescription %>">`
* `<title><%= siteTitle %></title>`
* `<div class="col-sm-8 blog-main"> <%- yield %> <nav>`

In the first example, you can see how we are pulling in the `seoDescription`
property from our `harp.json -> globals` property. The same is true
for our use of the `siteTitle` property. However, the `<%- yield %>`
example is used by Harp / EJS to know where to place the current content
within the template. This is where we are going to render all of our blog articles
and article listing pages (along with other supplementary pages like About).

Let's add the content for our `index.ejs` and `about.ejs` files:

**index.ejs**
```html
<div class="blog-post">
  <h2 class="blog-post-title">Sample blog post</h2>
  <p class="blog-post-meta">January 1, 2014</p>

  <p>This blog post shows a few different types of content that's supported and styled with Bootstrap. Basic typography, images, and code are all supported.</p>
  <hr>
  <p>Cum sociis natoque penatibus et magnis <a href="#">dis parturient montes</a>, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.</p>
  <blockquote>
    <p>Curabitur blandit tempus porttitor. <strong>Nullam quis risus eget urna mollis</strong> ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
  </blockquote>
  <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
</div><!-- /.blog-post -->

<div class="blog-post">
  <h2 class="blog-post-title">Another blog post</h2>
  <p class="blog-post-meta">December 23, 2013</p>

  <p>Cum sociis natoque penatibus et magnis <a href="#">dis parturient montes</a>, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.</p>
  <blockquote>
    <p>Curabitur blandit tempus porttitor. <strong>Nullam quis risus eget urna mollis</strong> ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
  </blockquote>
  <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
  <p>Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.</p>
</div><!-- /.blog-post -->

<div class="blog-post">
  <h2 class="blog-post-title">New feature</h2>
  <p class="blog-post-meta">December 14, 2013</p>

  <p>Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
  <ul>
    <li>Praesent commodo cursus magna, vel scelerisque nisl consectetur et.</li>
    <li>Donec id elit non mi porta gravida at eget metus.</li>
    <li>Nulla vitae elit libero, a pharetra augue.</li>
  </ul>
  <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
  <p>Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue.</p>
</div><!-- /.blog-post -->
```

Our `index.ejs` file contains what we want to display when the user first
accesses our site. In this case, we want to display a list of our blog posts.
For now, we are going to leave the content static but we will eventually list out
our dynamic blog list.

**about.ejs**
```html
<div class="blog-post">
  <h2 class="blog-post-title">About</h2>
  <p>Some information about this blog</p>
  <hr>
  <p>Cum sociis natoque penatibus et magnis <a href="#">dis parturient montes</a>, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.</p>
  <blockquote>
    <p>Curabitur blandit tempus porttitor. <strong>Nullam quis risus eget urna mollis</strong> ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
  </blockquote>
  <p>Etiam porta <em>sem malesuada magna</em> mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.</p>
</div><!-- /.blog-post -->
```

Our `about.ejs` page is used to display the About content for our site. Usually,
this would give the user more information about you or the subject of your blog.

## Compile and Running with Harp
With our current site:

```
ROOT
|-- public/
|   |-- _layout.ejs
|   |-- index.ejs
|   `-- about.ejs
`-- harp.json
```

we are ready to compile and run the site locally. From the root of our project
run
```
$ harp compile
```
The compile command will scan your folders and compile your site. If Harp runs
into any issues, it will let you know. If it was successful, a new `www` folder will
be generated that will contain your static site in its entirety. It should
result in the following output:

```
ROOT
`-- www/
    |-- about.html
    `-- index.html
```

Likewise, as I often do, I will utilize HarpsJs's `server` command to compile
and host the site locally. This utilizes a simple NodeJs server to watch
your solution and automatically render the site as you create it without
having to run the `compile` command each time. Let's do this to view the site
we have created:
```
$ harp server
```
This, by default, will spin up a new server running locally at 
[http://localhost:9000](http://localhost:9000).
If you run into `Error: listen EADDRINUSE` issues it is because you
already have a server up and running on the localhost with the port of 9000.
You will need to specify a new unique port to use, something like:
```
$ harp server --port 8000
```

Now when you navigate to your site URL, you should see a functional
site with body content. In the navigation, click between the `Home` and `About`
pages to see how the body content changes.

## Deployment to Surge
Now that we have a functional site, we should push it up live so others
can access it. For that, we are going to use [Surge]("http://surge.sh"), which
is a free static site hosting service. It has some seriously great, free
features like:
* Custom Domain support
* Free SSL for surge.sh subdomains
* CLI deployments

In order to use surge, we need to install it via NPM:
```
$ npm install --g surge
```

One installed, let's make sure we compile one last time:
```
$ harp compile
```
then, we need to navigate into the `www` folder
```
$ cd www
```
then simply run
```
$ surge
```

Surge will step you through setting up a new account (which it remembers for
subsequent commands). Once you confirm your project path, Surge
will let you know the size of your static site along with providing you
an auto-generated domain name. Feel free to change the subdomain to something
that works for your project (ex. `harp-demo.surge.sh`). 

After hitting enter, Surge should provide some context as to how long the deployment
will take along with providing a progress bar. Once complete, the endpoint you 
pushed to should be available for browsing your site.

## End of Part 1
With a functional static site hosted on Surge, we are done with Part 1.
Recall you can find the final Part 1 source here: [Part 1 Code](https://github.com/wkallhof/Harp-Bootstrap-Demo/tree/s1)
For Part 2, we will:
* Updating our _layout.ejs with a cleaner layout using EJS Partials
* Utilize `_data.json` meta data files for more granular, per-page metadata
* Create a few blog posts
* Dynamically list our blog posts on our `index.ejs` home page.
* Update our navigation to display active states


</article>