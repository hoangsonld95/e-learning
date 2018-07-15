# INTEGRATING AJAX INTO RAILS APP

© LeDinhHoangSon ([sonminator](https://m.facebook.com/hoangsonld?ref=bookmarks)) 2018<br>

**References**

[Integrating Ajax into simple To-Do App in Rails](http://roseweixel.github.io/blog/2015/07/05/integrating-ajax-and-rails-a-simple-todo-list-app/)

## GemFile

* From Rails 5.1, jQuery is not defaultly integrated in Rails app. We need to add it in GemFile

  ```ruby
      gem 'jquery-rails'
    ```

* Furthermore, replace the (//= require ....) lines in app/assets/javascript/application.js with:

    ```ruby
    //= require turbolinks
    //= require jquery3
    //= require jquery_ujs
    //= require_tree
  ```

* Install the gem : `bundle install`

## Basic Rails ToDo App

1. Create project : `rails new rails_app`

2. Create RESTful routes, controllers, views : `rails generate resource todo`

3. Create migration files to add columns (attributes) to (todo) database :

  ```ruby
  rails g migration add_description_to_ToDos description:string
    ```
    ```ruby
    rails g migration add_priority_to_ToDos priority:string
    ```
    Then migrate those changes into the DB :
    ```ruby
    rails db:migrate
    ```

4.  Fill in the actions in controller (`app/controllers/todos_controller.rb`) :

    ```ruby
    class TodosController < ApplicationController

         def index
            @todos = Todo.all
         end

         def create
          Todo.create(todo_params)
            redirect_to root_path
         end

         def destroy
            todo = Todo.find(params[:id])
            todo.destroy
            redirect_to root_path
         end

         private
            def todo_params
              params.require(:todo).permit(:description, :priority)
        end

    end
    ```

5. In `config/routes.rb`

    ```ruby
    Rails.application.routes.draw do
      root 'todos#index'
        resources :todos
    end
    ```

6.  Create `views/todos/index.html.erb` :

```erb
<h1>My Todos</h1>

<%= form_for Todo.new do |f| %>
  <div class="form-group">
    <%= f.text_field :description, placeholder:
    "what needs doing?" %>
  </div>

  <div class="form-group">
    <%= f.text_field :priority, placeholder: "priority level" %>
  </div>

  <div class="form-group">
  <%= f.submit %>
  </div>
<% end %>

<ul>
<% @todos.each do |todo| %>
  <li>
    <%= todo.description %><br>
    <%= todo.priority %><br>
    <%= link_to "done", todo_path(todo), method: 'delete' %>
  </li>
<% end %>
</ul>
```


## Posting new to-do with AJAX

All the javascript functions origins from application.js.
But we can devide those javascripts correspoding to model (in todos.js)

**There are 4 main steps when "Create" button is clicked : **

1.  Create an event listener for the "click" event to prevent the default behavior : reloading page
2.  Grab some information and send over Ajax request
3.  Make an Ajax request
4.  Handle the response, add new todo to the page

#### Create an event listener

1.  Make sure the document is ready before doing anything else :


```javascript
// Shorthand for $(document).ready(function(){ })
$(function(){

})
```

2.  Listen for the submission of the form :

```javascript
// Shorthand for $(document).ready(function(){ })
$(function(){
  $("form").submit(function(){
      // Prevent the default action of form : reloading the page
        event.preventDefault();

        var action = $(this).attr("action");
        var method = $(this).attr("method");

        var description = $(this).find("#todo_description").val();
        var priority = $(this).find("#todo_priority").val();

    });
})

```
#### Make the Ajax request

* Sample AJAX :
  ```ruby
  $.ajax({
      method: "POST",
        url: "some/php",
        data: { name: "son", email: "son@gmail.com" }
    })
    ```

Pry session:

    pry(main)> a.hello
    hello world!
    => nil
    pry(main)> def a.goodbye
    pry(main)*   puts "goodbye cruel world!"
    pry(main)* end
    => nil
    pry(main)> a.goodbye
    goodbye cruel world!
    => nil
    pry(main)> exit

    program resumes here.

### Command Shell Integration

A line of input that begins with a '.' will be forwarded to the
command shell. This enables us to navigate the file system, spawn
editors, and run git and rake directly from within Pry.

Further, we can use the `shell-mode` command to incorporate the
present working directory into the Pry prompt and bring in (limited at this stage, sorry) file name completion.
We can also interpolate Ruby code directly into the shell by
using the normal `#{}` string interpolation syntax.

In the code below we're going to switch to `shell-mode` and edit the
`.pryrc` file in the home directory. We'll then cat its contents and
reload the file.

    pry(main)> shell-mode
    pry main:/home/john/ruby/projects/pry $ .cd ~
    pry main:/home/john $ .emacsclient .pryrc
    pry main:/home/john $ .cat .pryrc
    def hello_world
      puts "hello world!"
    end
    pry main:/home/john $ load ".pryrc"
    => true
    pry main:/home/john $ hello_world
    hello world!

We can also interpolate Ruby code into the shell. In the
example below we use the shell command `cat` on a random file from the
current directory and count the number of lines in that file with
`wc`:

    pry main:/home/john $ .cat #{Dir['*.*'].sample} | wc -l
    44

### Code Browsing

You can browse method source code with the `show-method` command. Nearly all Ruby methods (and some C methods, with the pry-doc
gem) can have their source viewed. Code that is longer than a page is
sent through a pager (such as less), and all code is properly syntax
highlighted (even C code).

The `show-method` command accepts two syntaxes, the typical ri
`Class#method` syntax and also simply the name of a method that's in
scope. You can optionally pass the `-l` option to show-method to
include line numbers in the output.

In the following example we will enter the `Pry` class, list the
instance methods beginning with 're' and display the source code for the `rep` method:

    pry(main)> cd Pry
    pry(Pry):1> ls -M --grep re
    Pry#methods: re  readline  refresh  rep  repl  repl_epilogue  repl_prologue  retrieve_line
    pry(Pry):1> show-method rep -l

    From: /home/john/ruby/projects/pry/lib/pry/pry_instance.rb @ line 143:
    Number of lines: 6

    143: def rep(target=TOPLEVEL_BINDING)
    144:   target = Pry.binding_for(target)
    145:   result = re(target)
    146:
    147:   show_result(result) if should_print?
    148: end

Note that we can also view C methods (from Ruby Core) using the
`pry-doc` plugin; we also show off the alternate syntax for
`show-method`:

    pry(main)> show-method Array#select

    From: array.c in Ruby Core (C Method):
    Number of lines: 15

    static VALUE
    rb_ary_select(VALUE ary)
    {
        VALUE result;
        long i;

        RETURN_ENUMERATOR(ary, 0, 0);
        result = rb_ary_new2(RARRAY_LEN(ary));
        for (i = 0; i < RARRAY_LEN(ary); i++) {
            if (RTEST(rb_yield(RARRAY_PTR(ary)[i]))) {
                rb_ary_push(result, rb_ary_elt(ary, i));
            }
        }
        return result;
    }

### Documentation Browsing

One use-case for Pry is to explore a program at run-time by `cd`-ing
in and out of objects and viewing and invoking methods. In the course
of exploring it may be useful to read the documentation for a
specific method that you come across. Like `show-method` the `show-doc` command supports
two syntaxes - the normal `ri` syntax as well as accepting the name of
any method that is currently in scope.

The Pry documentation system does not rely on pre-generated `rdoc` or
`ri`, instead it grabs the comments directly above the method on
demand. This results in speedier documentation retrieval and allows
the Pry system to retrieve documentation for methods that would not be
picked up by `rdoc`. Pry also has a basic understanding of both the
rdoc and yard formats and will attempt to syntax highlight the
documentation appropriately.

Nonetheless, the `ri` functionality is very good and
has an advantage over Pry's system in that it allows documentation
lookup for classes as well as methods. Pry therefore has good
integration with  `ri` through the `ri` command. The syntax
for the command is exactly as it would be in command-line -
so it is not necessary to quote strings.

In our example we will enter the `Gem` class and view the
documentation for the `try_activate` method:

    pry(main)> cd Gem
    pry(Gem):1> show-doc try_activate

    From: /Users/john/.rvm/rubies/ruby-1.9.2-p180/lib/ruby/site_ruby/1.9.1/rubygems.rb @ line 201:
    Number of lines: 3

    Try to activate a gem containing path. Returns true if
    activation succeeded or wasn't needed because it was already
    activated. Returns false if it can't find the path in a gem.
    pry(Gem):1>

We can also use `ri` in the normal way:

    pry(main) ri Array#each
    ----------------------------------------------------------- Array#each
         array.each {|item| block }   ->   array
    ------------------------------------------------------------------------
         Calls _block_ once for each element in _self_, passing that element
         as a parameter.

            a = [ "a", "b", "c" ]
            a.each {|x| print x, " -- " }

         produces:

            a -- b -- c --

### Gist integration

If the `gist` gem is installed then method source or documentation can be gisted to GitHub with the
`gist` command.  The `gist` command is capable of gisting [almost any REPL content](https://gist.github.com/cae143e4533416529726), including methods, documentation,
input expressions, command source, and so on. In the example below we will gist the C source
code for the `Symbol#to_proc` method to GitHub:

    pry(main)> gist -m Symbol#to_proc
    Gist created at https://gist.github.com/5332c38afc46d902ce46 and added to clipboard.
    pry(main)>

You can see the actual gist generated here: [https://gist.github.com/5332c38afc46d902ce46](https://gist.github.com/5332c38afc46d902ce46)

### Edit methods

You can use `edit Class#method` or `edit my_method`
(if the method is in scope) to open a method for editing directly in
your favorite editor. Pry has knowledge of a few different editors and
will attempt to open the file at the line the method is defined.

You can set the editor to use by assigning to the `Pry.editor`
accessor. `Pry.editor` will default to `$EDITOR` or failing that will
use `nano` as the backup default. The file that is edited will be
automatically reloaded after exiting the editor - reloading can be
suppressed by passing the `--no-reload` option to `edit`

In the example below we will set our default editor to "emacsclient"
and open the `Pry#repl` method for editing:

    pry(main)> Pry.editor = "emacsclient"
    pry(main)> edit Pry#repl

### Live Help System

Many other commands are available in Pry; to see the full list type
`help` at the prompt. A short description of each command is provided
with basic instructions for use; some commands have a more extensive
help that can be accessed via typing `command_name --help`. A command
will typically say in its description if the `--help` option is
available.

### Use Pry as your Rails Console

The recommended way to use Pry as your Rails console is to add
[the `pry-rails` gem](https://github.com/rweng/pry-rails) to
your Gemfile. This replaces the default console with Pry, in
addition to loading the Rails console helpers and adding some
useful Rails-specific commands.

If you don't want to change your Gemfile, you can still run a Pry
console in your app's environment using Pry's `-r` flag:

    pry -r ./config/environment

Also check out the [wiki](https://github.com/pry/pry/wiki/Setting-up-Rails-or-Heroku-to-use-Pry)
for more information about integrating Pry with Rails.

### Limitations:

* Tab completion is currently a bit broken/limited this will have a
  major overhaul in a future version.

### Syntax Highlighting

Syntax highlighting is on by default in Pry. If you want to change
the colors, check out the [pry-theme](https://github.com/kyrylo/pry-theme)
gem.

You can toggle the syntax highlighting on and off in a session by
using the `toggle-color` command. Alternatively, you can turn it off
permanently by putting the line `Pry.color = false` in your `~/.pryrc`
file.

### Future Directions

Many new features are planned such as:

* Increase modularity (rely more on plugin system)
* Much improved documentation system, better support for YARD
* Better support for code and method reloading and saving code
* Extended and more sophisticated command system, allowing piping
between commands and running commands in background

### Contact

Problems or questions? File an issue at [GitHub](https://github.com/pry/pry/issues).

### Contributors

Pry is primarily the work of [John Mair (banisterfiend)](https://github.com/banister), for full list
of contributors see the
[contributors graph](https://github.com/pry/pry/graphs/contributors).
