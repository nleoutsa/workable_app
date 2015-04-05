
$(document).ready(function () {


  // fill letter when reloading due to errors...
  var inputs = document.getElementsByTagName('input');
  // fill parts from text field values
  for (i = 0; i < inputs.length; i++) {


    if (inputs[i].type == "text" || inputs[i].type == "date") {
      input_class = "." + inputs[i].id;
      text = inputs[i].value;

      if (text == "") {
        //return to placeholder value
        text = inputs[i].placeholder;
      //  text = "______________________";
        $(input_class).css("color", "rgba(0,0,0,0.3)");
      }
      else {
        // rearrange date to mm/dd/yyyy
        if (inputs[i].type == "date") {
          old_date = text.split("-");
          text = old_date[1] + "/" + old_date[2] + "/" + old_date[0];
        }
        $(input_class).css("color", "#444");
      };

      $(input_class).html(text);
    }
    else if (inputs[i].type == "checkbox") {
      checkbox_id = "#" + inputs[i].id;
      checkbox_class = '.' + inputs[i].id;

      if ($(checkbox_id).prop('checked')) {
        $(checkbox_class).removeClass('dont_include');
      }
      else {
        $(checkbox_class).addClass('dont_include');
      };
    }
  }

// jump to appropriate field when clicking on part of the letter
  $('.placeholder').click(function() {
    //grab last class from each placeholder and set it as the id value used to access the corresponding form fields
    placeholder_id = "#" + this.className.split(" ").pop();
    placeholder_class = "." + this.className.split(" ").pop();

    // set frame ids
    current_id = ($(placeholder_id).parent().index() - 2);
    last_id = current_id - 1;
    next_id = current_id + 1;

    // go to current_id frame
    goto_frame();

    // focus on appropriate field
    $(placeholder_id).focus();

  });



// live print text in from form-fields into letter based on ids
  $('input').focus(function() {

    inputField = document.activeElement;
    input_class = "." + inputField.id;

    text = inputField.value;

    // set scroll offset for inputs
    input_class_offset = $(input_class).offset().top - 735;

    // because Chrome and Firefox/IE use different methods to get scroll distance...
    scroll_position = ((document.documentElement.scrollTop > document.body.scrollTop) ? document.documentElement.scrollTop : document.body.scrollTop);
    // scroll to start of tool
    if ((scroll_position < 550) || ((input_class_offset < 200) && (input_class_offset > -500))) {
      $('html, body').animate({
        scrollTop: 550
      }, 100);
    }
    // scroll to appropriate letter section on form field focus
    if ((input_class_offset > 200) || (input_class_offset < -100)) {
      $('#letter').animate({
        scrollTop: input_class_offset
      }, 100);
    }


    if (inputField.type == "text" || inputField.type == "date") {
      //highlight on focus
      $(input_class).css("background-color", "rgba(51,182,203, 0.5)");
      $(input_class).css("text-decoration", "underline");
      //
      no_address = (inputField.id).indexOf("address_2");

      // live type on key release, change font color to black and leave an underline for unfilled inputs
      inputField.onkeyup = function(){


        text = inputField.value;
        if ((text == "") && (no_address < 0)) {
          //return to placeholder value
          text = inputField.placeholder;
          $(input_class).css("color", "rgba(0,0,0,0.3)");
        }
        else {
          $(input_class).css("color", "#444");
        };
        $(input_class).html(text);
      }

      inputField.click = function(){

        text = inputField.value;
        if ((text == "") && (no_address < 0)) {
          //return to placeholder value
          text = inputField.placeholder;
          $(input_class).css("color", "rgba(0,0,0,0.3)");
        }
        else {

          $(input_class).css("color", "#444");
        };
        $(input_class).html(text);
      }

      //un-highlight
      $(this).focusout(function() {
        text = inputField.value;


        if ((text == "") && (no_address < 0)) {
          //return to placeholder value
          text = inputField.placeholder;
          $(input_class).css("color", "rgba(0,0,0,0.3)");
          $(input_class).css("background-color", "rgba(51,182,203, 0.0)");
        }
        else {
          // rearrange date to mm/dd/yyyy
          if (inputField.type == "date") {
            old_date = text.split("-");
            text = old_date[1] + "/" + old_date[2] + "/" + old_date[0];
          }
          $(input_class).css("background-color", "rgba(51,182,203, 0.0)");
          $(input_class).css("color", "#444");
          $(input_class).css("text-decoration", "none");
        };

        $(input_class).html(text);
      });
    }
  });






$("input[type='checkbox']").click(function() {
  checkbox_class = "." + this.id;

  if (this.checked) {
    $(checkbox_class).removeClass('dont_include');
  }
  else {
    $(checkbox_class).addClass('dont_include');
  };
});



// TODO scroll to first mention of field in letter on focus/typing



// sticky form on left side...
  var offset = $('#multi-step-form').offset();

  $(window).scroll(function() {
    var scroll_top = 10 + $(window).scrollTop();

    if (offset.top < scroll_top) {
      $('#multi-step-form').addClass('fixed');
    }
    else {
      $('#multi-step-form').removeClass('fixed');
    }
  });





// VARIABLES
  var current_frame, next_frame, previous_frame; //frame status for transitions
  var right, opacity; // initiate opacity and right vars, used for animating frame transition
  var animating; //prevents glitchy use from double clicks...


  previous_frame = $("fieldset").eq(0);
  current_frame = $("fieldset").eq(0);
  next_frame = $("fieldset").eq(0);


// switch to correct fieldset when clicking on progress bar (no animation)
  $("#progressbar li").click(function() {

    current_id = $(this).index();
    last_id = current_id - 1;
    next_id = current_id + 1;

    goto_frame();


  });


  //switch frames with animation on button click.
  $(".next").click(function(){
    if(animating) return false;
    animating = true;

    current_frame = $(this).parent();
    next_frame = $(this).parent().next();

    next_fieldset();
  });

  $(".previous").click(function(){
    if(animating) return false;
    animating = true;

    current_frame = $(this).parent();
    previous_frame = $(this).parent().prev();

    previous_fieldset();
  });


  $(".submit").click(function(){
    return false; // don't send form regularly. Only send via Rails controller actions...
  });

  function next_fieldset() {

    //activate next step on progressbar using the index of next_frame
    $("#progressbar li").eq($("fieldset").index(next_frame)).addClass("showing");

    //show the next fieldset

    $('fieldset').addClass('absolute');
    $('fieldset').removeClass('relative');

    next_frame.removeClass('absolute');
    next_frame.addClass('relative');


    next_frame.show();

    //animate transition
    current_frame.animate({opacity: 0}, {
      step: function(now) {
        right = (now * 50) + "%";
        opacity = 1 - now;
        next_frame.css({'right':right, 'opacity': opacity});
      },
      duration: 200, // in milliseconds
      complete: function() {
        current_frame.hide(); //hide current frame
        animating = false;
      }
    });

  }

  function previous_fieldset() {

    //de-activate current step on progressbar
    $("#progressbar li").eq($("fieldset").index(current_frame)).removeClass("showing");

    $('fieldset').addClass('absolute');
    $('fieldset').removeClass('relative');

    current_frame.removeClass('absolute');
    current_frame.addClass('relative');

    previous_frame.show();

    //animate transition
    current_frame.animate({opacity: 0}, {
      step: function(now) {
        right = ((1 - now) * 50) + "%";
        opacity = 1 - now;
        current_frame.css({'right': right});
        previous_frame.css({'opacity': opacity});
      },
      duration: 200, // ms
      complete: function() {
        current_frame.hide(); //hide current frame
        current_frame.css('right','0px'); // reset frame position
        previous_frame.removeClass('absolute');
        previous_frame.addClass('relative');
        animating = false; // make buttons clickable again
      }

    });
  }


  function goto_frame() {

    if (last_id < 0) {
      last_id = 0;
    }
    if (next_id > 4) {
      next_id = 4;
    }

    previous_frame = $("fieldset").eq(last_id);
    current_frame = $("fieldset").eq(current_id);
    next_frame = $("fieldset").eq(next_id);

    $("#progressbar li").removeClass("showing");

    for (x = 0; x <= current_id; x++) {
      $("#progressbar li").eq(x).addClass("showing");
    };

    $("fieldset").hide();

    current_frame.addClass('relative');
    current_frame.css({'right': '0%', 'opacity': opacity});
    current_frame.show();
  }

});