Summary
-------

* Do not edit the CSS directly, edit the source SCSS files and process them with SASS (running
  `make` should do that when you have the required software installed, as described below;
  run `/.parse-sass.sh` manually if it doesn't)
* To be able to use the lates/adequate version of sass, install ruby, gem, sass & bundle. 
  On Fedora F20, this is done with `sudo dnf install rubygems && gem install bundle && bundle install`
  from the same directory this README resides in.

How to tweak the theme
----------------------

Adwaita is a complex theme, so to keep it maintainable it's written and processed in SASS, the
generated CSS is then transformed into a gresource file during gtk build and used at runtime in a 
non-legible or editable form.

It is very likely your change will happen in the _common.scss file. That's where all the widget 
selectors are defined. Here's a rundown of the "supporting" stylesheets, that are unlikely to be the 
right place for a drive by stylesheet fix:

_colors.scss        - global color definitions. We keep the number of defined colors to a necessary minimum, 
                      most colors are derived from a handful of basics. It is an exact copy of the gtk+ 
                      counterpart. Light theme is used for the classic theme and dark is for GNOME3 shell 
                      default.

_drawing.scss       - drawing helper mixings/functions to allow easier definition of widget drawing under
                      specific context. This is why Adwaita isn't 15000 LOC.

_common.scss        - actual definitions of style for each widget. This is where you are likely to add/remove
                      your changes.
                      
You can read about SASS at http://sass-lang.com/documentation/. Once you make your changes to the
_common.scss file, you can either run the ./parse-sass.sh script or keep SASS watching for changes as you
edit. This is done by running `bundle exec sass --watch --sourcemap=none .` If sass is out of date, or is
missing, you can install it with `bundle install`.
