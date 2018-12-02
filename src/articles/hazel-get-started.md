---
Title: Getting started with Hazel
Description: Hazel is a personal attempt to create a self hosted web application that supports easy document composition with a wiki-like work flow.
Tags: Article
SortOrder: 999
---

<article class="content">

# Getting started with Hazel

[Hazel](http://hazel.wmk.io) is a personal attempt to create a self hosted web application that supports easy document composition with a wiki-like work flow.
Navigating to a page that doesn't exist will prompt you to create the content for that page. Cross-document association is as simple as
entering the title of the document, and the link is auto generated. 

<!-- more -->

### Getting Started
Of course, the first step to using Hazel with Node.js is to [install Node.js](https://nodejs.org/en/download/)

The next thing we need to do in order to get started with Hazel is to create the project root for our new Hazel project.
```bash
$ mkdir hazel-demo && cd hazel-demo
```

Now we should initialize our Node.js application
```bash
$ npm init 
```

This will step you through the process of setting up your `package.json` file. In my case, for this demo, mine turned out like :

```json
{
  "name": "hazel-demo",
  "version": "1.0.0",
  "description": "Hazel Demo",
  "main": "server.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}
```

Once you have your `package.json` file filled out to your liking, we need to make the call to install Hazel
```bash
$ npm install hazel-wiki --save
```

This will go through the process of loading all of Hazel's dependencies and installing them into a `node-modules` folder in your project root.
The `--save` flag tells NPM to add `hazel-wiki` as a dependency in your `package.json` file.

#### server.js setup

In the case of this demo, in my `package.json` file I specified the `main` attribute to point to a `server.js` file, so let's create that. This file should hold the code that
initializes Hazel and starts our Express server.

**server.js**
```js
"use strict";

const Hazel = require("hazel-wiki").app;
const config = require("./config.default.js");
const StorageProvider = require("hazel-wiki").storageProvider;

let app = new Hazel(config, StorageProvider);
let server = app.server;

server.listen(3000, () => {
    console.log("✔ Hazel server listening at 3000 ");
});
```

At the top we are pulling in our required dependencies
* `require("hazel-wiki").app` - The Hazel application
* `require("./config.default.js")` - Our personal configuration file for Hazel (which we haven't created yet, see below)
* `require("hazel-wiki").storageProvider` - Hazel's default storage provider, which writes files to disk on the server

We then initialize a new Hazel app, passing in the config and storage provider, then start the server on port 3000

#### config.default.js setup

You will notice we referenced a `config.default.js` file in the root of our project. This file is used to hold custom configuration options for your Hazel instance.
Let's create that file and add a few configuration options:

```bash
$ touch config.default.js
```

**config.default.js**
```js

var config = {
    // Your site title (format: page_title - site_title)
    site_title: "HAZEL DEMO"
};

// Exports
module.exports = config;
```

In our `config.default.js` file, we simply added a "site_title" override that allows us to specify the site title for our application.

You can review all of the available configuration options [on Github](https://github.com/wkallhof/Hazel/blob/master/app/config.default.js)

#### Run the site

Now that we have everything in place, we are ready to run the site!

```bash
$ node server.js
```

You should see your terminal display `✔ Hazel server listening at 3000`. Navigate in your browser to [http://localhost:3000](http://localhost:3000)
and you should now see our running Hazel instance.

Now start adding some documents and give me some feedback below.
</article>