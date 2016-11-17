#!/bin/sh

bundle exec sass --update --sourcemap=none sass:. && glib-compile-resources gnome-shell-theme.gresource.xml
