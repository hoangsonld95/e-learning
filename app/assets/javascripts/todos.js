$(function(){
  $("form").submit(function(event){
    event.preventDefault();

    // this debugger should be hit when you click the submit button!
    var action = $(this).attr('action');
    var method = $(this).attr('method');

    var description = $(this).find("#todo_description").val();
    var priority = $(this).find("#todo_priority").val();
    var data = $(this).serializeArray();

    $.ajax({
      method: method,
      url: action,
      data: { description: description, priority: priority }
    });

  });
});
