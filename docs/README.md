# tadhatfield.com

This folder is the whole website. GitHub Pages turns it into HTML with
[Jekyll](https://jekyllrb.com/) every time something is pushed to `master`,
usually live within a minute or two. There is no server or database, and
nothing to run on your computer.

## Where things are

| To change…                     | Edit                                   |
| ------------------------------ | -------------------------------------- |
| About page / contact info      | `about.md`                             |
| Resume                         | `resume.md`                            |
| Books list                     | `_data/books.yml` + a cover in `assets/images/books/` |
| Home page                      | `index.html`                           |
| Header links, social links     | `_config.yml` (`navigation`, `social`) |
| Look and feel (colors, fonts)  | `assets/css/style.css` (colors are at the top) |
| Page frame (header/footer)     | `_layouts/default.html`, `_includes/`  |

Pages written in `.md` files are [Markdown](https://www.markdownguide.org/basic-syntax/).
The block between the `---` lines at the top of each file is settings
("front matter"): title, URL, description, and so on.

## Write a new post

1. Create a file in `_posts/` named `YYYY-MM-DD-short-name.md`, for example
   `_posts/2026-10-05-soil-moisture-map.md`.
2. Start it like this, then write the post in Markdown below it:

   ```markdown
   ---
   title: "Soil Moisture Across Iowa"
   description: One or two sentences shown on the post cards and in search results.
   cover: /assets/images/posts/soil-moisture.jpg   # optional header image
   cover_alt: "Map of Iowa shaded by soil moisture" # describe the image
   image: /assets/images/posts/soil-moisture.jpg   # optional, for link previews
   ---

   Your post here. **Bold**, _italic_, [links](https://example.com), lists…

   ![Describe the image](/assets/images/posts/another-picture.jpg)
   ```

3. Put any images in `assets/images/posts/`.
4. Commit and push. It shows up on the home page, `/posts/`, and the RSS feed
   automatically. The URL is `/short-name/` (from the file name).

You can paste raw HTML into a post too, e.g. an ArcGIS, YouTube, or Google
Maps embed. See `_posts/2024-07-04-first-post.md` for the ArcGIS map. Wrap
a wide embed in `<div class="full-bleed">…</div>` to let it go past the text column.

You can do all of this in the browser: on GitHub, open the `docs/` folder,
click **Add file → Create new file** (or the pencil icon to edit), and commit.

## Add a book

Save the cover in `assets/images/books/` (around 400 px wide is plenty) and
add an entry at the top of `_data/books.yml`:

```yaml
- title: "Book Title"
  author: Author Name
  cover: book-title.jpg
```

## Preview on your own computer (optional)

Needs Ruby. From this folder:

```sh
bundle install
bundle exec jekyll serve
```

Then open http://localhost:4000. It reloads as you save files.

## Settings that matter

- `CNAME` holds the custom domain. Don't delete it.
- `_config.yml` has `theme: null` so GitHub doesn't apply its default theme
  over this design.
- Only [plugins GitHub Pages supports](https://pages.github.com/versions/)
  will work.
