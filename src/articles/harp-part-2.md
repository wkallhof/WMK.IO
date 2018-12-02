---
Title: "Let's Build: a static blog with Harp - Part 2"
Description: "For part 2 of our Let's Build : A static blog with Harp, we are going to wrap up the series with a fully functional static blog"
Tags: Article
SortOrder: 999
---

<article class="content">

# Let's Build: a static blog with Harp - Part 2

For part 2 of our Let's Build : A static blog with Harp, we are going to 
* Update our _layout.ejs with a cleaner layout using EJS Partials
* Utilize `_data.json` metadata files for more granular, per-page metadata
* Create a few blog posts
* Dynamically list our blog posts on our `index.ejs` home page.
* Update our navigation to display active states

<!-- more -->

A quick note, this is a continuation of our first part [Let's Build : A static blog with Harp - Part 1](/posts/harp-part-1). Read that
first before starting this part 2. Also, all source for this part 2 can be found here : [Part 2 Code](https://github.com/wkallhof/Harp-Bootstrap-Demo/tree/s2)

## Update our Layout with Partials
For the first part, we are going to update our `_layout.ejs` file to use partials in order to separate out concerns for the view.
This helps us keep our main `_layout.ejs` file from getting too large as well. Let's add a new `_partials` folder to our `public` folder
 and a few new files to our project:

```
public/
`-- _partials/
    |-- header.ejs
    |-- footer.ejs
    `-- sidebar.ejs
```

Note that we prepended our `_partials` folder with an underscore character. As mentioned in part one, this is important and it means
that this folder and its entire contents will not be exposed publicly. Once the site is live, a user can not navigate to
`[site root]/_partials/header.ejs` as it will not be generated as static output when we compile the site. It is simply used as
supplementary content when building our static files.

As you can see, we are going to be creating partials files to hold our markup that drives the header, footer, and sidebar sections of our
layout. We simply need to copy and paste the markup from our `_layout.ejs` file that represents each section and put it into
their respective partials

**header.ejs**
```html
<div class="blog-masthead">
    <div class="container">
    <nav class="blog-nav">
        <a class="blog-nav-item active" href="/">Blog</a>
        <a class="blog-nav-item" href="/about">About</a>
    </nav>
    </div>
</div>
```
**footer.ejs**
```html
<footer class="blog-footer">
    <p>Blog template built for <a href="http://getbootstrap.com">Bootstrap</a> by <a href="https://twitter.com/mdo">@@mdo</a>.</p>
    <p>
    <a href="#">Back to top</a>
    </p>
</footer>
```
**sidebar.ejs**
```html
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
```

**_layout.ejs**
```html
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
    <%- partial("_partials/header") %>
    <div class="container">
      <div class="blog-header">
        <h1 class="blog-title">The Bootstrap Blog</h1>
        <p class="lead blog-description">The official example template of creating a blog with Bootstrap.</p>
      </div>
      <div class="row">
        <div class="col-sm-8 blog-main">

          <%- yield %>

        </div><!-- /.blog-main -->
        <%- partial("_partials/sidebar") %>
      </div><!-- /.row -->
    </div><!-- /.container -->
    <%- partial("_partials/footer") %>

    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="//getbootstrap.com/dist/js/bootstrap.min.js"></script>

  </body>
</html>

```

Now our `_layout.ejs` file has been updated to make a call to render out our new partial files instead of containing that markup itself.
You can validate this by running your site (`$ harp server`) and noting that the site renders out exactly the same as it had before 
(but now our code is much cleaner).

## Utilize _data.json and folder context

The next thing we should probably do is make our static site "dynamically" list out actual blog posts instead of having them
be static. To start this, we should add a new `posts` folder to our `public` folder along with a few new files.

```
public/
`-- posts/
    |-- post1.md
    |-- post2.md
    `-- _data.json
```

For this new `posts` folder, we added a couple example posts (`post1.md` and `post2.md`) written in markdown syntax and a `_data.json` file
to hold metadata information for each of our posts.

In this case, it is important to note where we *didn't* include an underscore character. Our site's URLS are composed of our actual 
folder structure and public files. In order to allow our users to access our blog posts, we can simply create a `posts` folder and
place the files holding our post content within. When Harp runs through and compiles our site, it will output the public folders
and files in the same way we had them in our project, resulting in a URL like `[site root]/posts/post1.html`. 

One really interesting concept that Harp provides is folder scoped metadata. Our `posts` folder can contain its own `_data.json` file
which holds metadata information specifically for the content within our `posts` folder. Let's add some content to that file now to get a
better idea of this concept

**_data.json**
```json
{
  "post2": {
     "title": "Our Example Post 2",
     "date": "Feb 28, 2016"
   },
   
   "post1": {
     "title": "Our Example Post 1",
     "date": "Jan 31, 2016"
   }
 }
```

For each of our example blog posts, we add a new entry with the key being the same as the name of our file. Each of our posts will have 
two pieces of metadata associated with them, the title and date of the post. The benefit of matching the key to the name of our file
is that Harp will automatically set that metadata as the context for any EJS templating logic you add to your post. For example, in your post, 
you could add a reference to just `<%= title %>` and it will pull in the correct title property from the data that matches the name of your
static file.

Let's actually put some stuff in our example post files

**post1.md**
```markdown
This blog post shows a few different types of content that's supported and styled with Bootstrap. Basic typography, images, and code are all supported.

* * *

Cum sociis natoque penatibus et magnis [dis parturient montes](#), nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.

> Curabitur blandit tempus porttitor. **Nullam quis risus eget urna mollis** ornare vel eu leo. Nullam id dolor id nibh ultricies vehicula ut id elit.

Etiam porta _sem malesuada magna_ mollis euismod. Cras mattis consectetur purus sit amet fermentum. Aenean lacinia bibendum nulla sed consectetur.

## Heading

Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros.

### Sub-heading

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

    Example code block

Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa.

### Sub-heading

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.

*   Praesent commodo cursus magna, vel scelerisque nisl consectetur et.
*   Donec id elit non mi porta gravida at eget metus.
*   Nulla vitae elit libero, a pharetra augue.

Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue.

1.  Vestibulum id ligula porta felis euismod semper.
2.  Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
3.  Maecenas sed diam eget risus varius blandit sit amet non magna.

Cras mattis consectetur purus sit amet fermentum. Sed posuere consectetur est at lobortis.
```

**post2.md**
```markdown

### Sub-heading

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.

*   Praesent commodo cursus magna, vel scelerisque nisl consectetur et.
*   Donec id elit non mi porta gravida at eget metus.
*   Nulla vitae elit libero, a pharetra augue.

Donec ullamcorper nulla non metus auctor fringilla. Nulla vitae elit libero, a pharetra augue.

1.  Vestibulum id ligula porta felis euismod semper.
2.  Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
3.  Maecenas sed diam eget risus varius blandit sit amet non magna.

Cras mattis consectetur purus sit amet fermentum. Sed posuere consectetur est at lobortis.
```

Our posts will be written strictly with Markdown, meaning we shouldn't be adding any HTML markup directly to those files. This
makes is easier for us to write blog posts, as all we need to do is drop in a new markdown file and update our `_data.json` with new
metadata. No fudging with markup to get things to work. In order to support this idea, we need to add one more file to our `_partials` 
folder named `post-wrapper.ejs` and update our `_layout.ejs` file to use this new file before rendering the Markdown

**post-wrapper.ejs**
```html
<% var post = public.posts._data[current.source]; %>

<div class="blog-post">
  <h2 class="blog-post-title"><%= post.title %></h2>
  <p class="blog-post-meta"><%= post.date %></p>

  <%- yield %>
  
</div><!-- /.blog-post -->
```
Since the new `post-wrapper.ejs` file is rendered when a user actually goes to our post, we need to ensure we have the metadata for the
current post available for rendering our title and date. Since this file isn't technically the same name as our key in the "_data.json" file
where we define our post metadata, we can't use Harp's nice feature that auto-binds this data, so we need to manually fetch it.
``` js
<% var post = public.posts._data[current.source]; %>
```
is actually doing just that, where `public.posts._data` is referencing our `public/posts/_data.json` file and the `current.source` is the
name of the currently requested file, which maps to one of our keys defined in the JSON (ex. `post1`)

Once we have the data for the currently requested post, we assign the variables for display within the template and then call `<%- yield -%>`
where our requested markdown will actually be rendered. This allows us to not have to remember to add that metadata for each of our posts
that we create.

Now, let's update our layout to make sure we take advantage of this new partial file when rendering out our posts. Change the following:

**_layout.ejs**
```html
<div class="col-sm-8 blog-main">
    <%- yield %>
</div><!-- /.blog-main -->
```
to:

**_layout.ejs**
```html
<div class="col-sm-8 blog-main">
<!-- BLOG POST-->
<%if (current.path[0] === "posts") { %>
    <%- partial("_partials/post-wrapper", yield) %>
    
<!-- HOME -->
<% } else { %>
    <%- yield %>
<% } %>
</div><!-- /.blog-main -->
```
Essentially, what this is doing is checking whether or not the user is requesting a page within our `posts` folder, and if so, making
sure that the content for our post is rendered within the `post-wrapper.ejs` markup. If the user isn't requesting a post, just render
out whatever our current content is without passing it through a partial.

Now let's fire up the site and navigate to `[site root]/posts/post1` or `[site root]/posts/post2` and you should now see our post content
being displayed, and only our post content.

"Well great, but how do we get the user to these pages, our homepage is still static and doesn't link to this content" you say. Well, let's
fix that. Open up our `index.ejs` file and update it to have the following code :

**index.ejs**
```html
<% function excerpt(content) {
    if(content.indexOf("<!-- more -->") == -1) return content;
    else return content.split("<!-- more -->")[0]; 
} %>

<% for(var name in public.posts._data){ %>

<% var post = public.posts._data[name]; 
post.url = '/posts/'+name; %>

<div class="blog-post">
  <h2 class="blog-post-title">
      <a href="<%= post.url %>"><%= post.title %></a>
  </h2>
  <p class="blog-post-meta"><%= post.date %></p>
  <%- excerpt(partial(post.url)) %>
  <a href="<%= post.url %>" class="btn btn-primary">Read More &gt;</a>
</div><!-- /.blog-post -->

<% } %>
```

For now, ignore the `excerpt()` method we have defined at the top, we use that to take an excerpt of the post content so we don't display
the entire post on the homepage, just a snippet. I explain in more detail below. 

As far as the rest of the file, we are using EJS to create a for loop over our post keys that we have defined in our `/public/posts/_data.json` file.
For each post key listed in that file, we grab the metadata associated with that name key and set it to our `post` variable. We also go ahead
and set a new `url` property on our post for easy referencing in our template below. 

If you refresh your site and navigate to your home page, you should now see a listing of the blog posts you have defined along with
proper links to them.

## Blog Post Excerpts

A common feature of blogs is the ability to see an excerpt of the blog post content before clicking to view the entire article. As it stands,
we are listing **all** of our blog post content as we list them on our homepage. We started fixing that by including the `excerpt` function
in our `index.ejs` file (as defined above).

**index.ejs**
```html
<% function excerpt(content) {
    if(content.indexOf("<!-- more -->") == -1) return content;
    else return content.split("<!-- more -->")[0]; 
} %>

...
```

We use this method to parse our Markdown content and return a subset of the content based on the placement of the text `<!-- more -->`. Once
we add the HTML comment `<!-- more -->` to our posts, anything before that will be returned as our snippet that is displayed on our homepage,
prompting the user to "Read More". Let's update our post files to include the comment at the point where we want the home page to cut it off:

**post1.md**
```markdown
This blog post shows a few different types of content that's supported and styled with Bootstrap. Basic typography, images, and code are all supported.

* * *

Cum sociis natoque penatibus et magnis [dis parturient montes](#), nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Sed posuere consectetur est at lobortis. Cras mattis consectetur purus sit amet fermentum.
<!-- more -->
...
```
**post2.md**
```markdown
Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean lacinia bibendum nulla sed consectetur. Etiam porta sem malesuada magna mollis euismod. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.

*   Praesent commodo cursus magna, vel scelerisque nisl consectetur et.
*   Donec id elit non mi porta gravida at eget metus.
*   Nulla vitae elit libero, a pharetra augue.
<!-- more -->
...
```

Note that we added the `<!-- more -->` comment relatively near the top. Anything above the comment should give a good indication of what the rest
of the article is all about. 

Now, let's refresh our site. Once we do that, we should notice that our homepage is now listing only the excerpts for each article,
not the entirety of the article. When we click the link for that post, we can read the entire thing.

In a bit more detail
``` js
<%- excerpt(partial(post.url)) %>
```
is telling EJS to return us the content of our post by passing in the path of the post to the `partial()` method, which returns the
markup and then passes the result of that into our `excerpt()` method, which extracts just the first part of the article for rendering.

## Update our navigation with active states

The last little thing we need to do for this site is to update the navigation to give an indication to the user as to which section
of the site they are on.

Let's update our `header.ejs` partial file with the following markup:

**header.ejs**
```html
<div class="blog-masthead">
    <div class="container">
    <nav class="blog-nav">
        <% var path = current.path[0]; %>
        <a class="blog-nav-item <%= (path === 'index' || path === 'posts') ? 'active': '' %>" href="/">Blog</a>
        <a class="blog-nav-item <%= (path === 'about') ? 'active' : '' %>" href="/about">About</a>
    </nav>
    </div>
</div>
```

`<% path = current.path[0]; %>` is first setting the first part of our path to our `path` variable so we don't have to type it out
every time. We then use that path on each navigation link to determine whether or not to display the `active` class on the link.
In our first check, we need to check if the user is either on the homepage (`index`) or if they are on any of our posts `posts`. 
For our second check, we simply check if our first path value is `about`, which tells us the user is on the About page. 

## End of Part 2.
And that wraps up part 2 of series. Now push your updated site out live via Surge and start writing some blog posts.
Recall you can find the final Step 2 source here: [Part 2 Code](https://github.com/wkallhof/Harp-Bootstrap-Demo/tree/s2)
</article>