# Cert Reaper

## Introduction

As a foreman user, with appropriate access, we wanted a plugin which allows us to manage puppet certs for our nodes, so that we can clean and regenerate them in a self-service fashion. We don't want to give this access through the puppet CA smart proxy "About" page.

## Acceptance criteria

This should be a Foreman plugin that:

* adds "clean cert" to the host "edit" pulldown menu, under "hosts" (a new "controller").
* adds the "clean cert" behavior to the API (a second new "controller").
* adds the ability to clean multiple certs through the UI (select several servers, add option to the "actions" pulldown menu), with a confirmation warning (a "view") when doing so.
* Documentation for the plugin
* A new repo for the plugin (this *CANNOT* co-mingle with our other code)
* The plugin must be presented in the form of a gem to ease foreman installation
require Foreman 1.12 or greater
* The plugin should use the ACLs related to editing a host when deciding if the user can revoke a cert.

### Notes
This does not address the CRL-copy functionality, that is a separate process.

The basis for this plugin was in the documentation found at the foreman web site: [How to Create a Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Create_a_Plugin).

## Installation

See [the foreman plugin installation documentation](https://theforeman.org/plugins/#2.Installation)
for details on how to install Foreman plugins. In a nut-shell, you can take the cert-reaper.rb bundler gem file and add it to your foreman installations bundler.d directory. You'll need to update the :path symbol to point to your cert_reaper directory or change it to point to the version of the cert_reaper gem you have installed into your ruby's $LOAD_PATH.

## Usage

*Usage here*

## TODO

*Todo list here*

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *2016, 2017* *Doug Scoular <dscoular@cisco.com>*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

