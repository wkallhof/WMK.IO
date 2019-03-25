---
Title: Iron Beard
Description: Simple, zero-configuration static site generator written in .NET Core.
Type: Project
Date: 12/2/18
Image: images/projects/beard.png
---

<article class="content">

# Iron Beard : <small>.NET Core static site generator</small>

A simple and easy to use cross-platform static site generator built with .NET Core. IronBeard processes your Razor `.cshtml` files, markdown `.md` files into full `.html` files ready for static hosting on services like Amazon S3.

IronBeard maintains your folder structure and copies static assets like images, JS, and CSS into their respective directories to maintain the correct linking on the generated site.

Adding a `beard.json` file to your project root allows for further configuration (see below).

## Features
- Support for recursive folder and file structures
- Markdown Processor (with extensions: see [Markdig](https://github.com/lunet-io/markdig))
- Razor Processor
- Static File Processor
- Razor Layout Support (wraps other razor files and markdown markup)
- Markdown metadata (YAML Frontmatter support in markdown)
- Razor metadata (YAML Frontmatter support with Razor comments)
- HTML Formatting to clean up file output. 
- URL correction (properly handles relative routes and root folder routing (index.html etc.))
- Global configuration file
- Rich CLI output
- Valid system errors codes (useful for automation)
- Watch command for automatic rebuilding on file or directory change

### Check it out on [Github](https://github.com/wkallhof/iron-beard)

</article>