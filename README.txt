= faceoff

* http://github.com/yaksnrainbows/faceoff

== DESCRIPTION:

A scraper to backup your facebook account (albums, photos, notes, users, video).
Why a scraper instead of using facebook apps? Logging in as a user gives you
access to more data and it's harder to block.


== SYNOPSIS:

Using the gem lib:

  require 'faceoff'

  f = Faceoff.login "email@example.com", "password"

  f.photos_of_me{|p| p.save!}
  # Saves to ./Photos\ of\ me/

  f.albums[0].name
  #=> "Album title"

  f.albums[0].photos(0..10)
  #=> [<#Photo...>,<#Photo...>, ...]

  f.albums[0].photos[0].url
  #=> "http://photo/url.jpg"

  f.notes.first.title
  #=> "Title of note"


Using the gem bin:

  faceoff --all -d path/to/dir
  faceoff --notes --albums '1..4'
  faceoff email@example.com password -A

For more information see:

  faceoff -h

== REQUIREMENTS:

* mechanize
* highline
* json
* vpim

== INSTALL:

* sudo gem install faceoff

== LICENSE:

(The MIT License)

Copyright (c) 2010 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
