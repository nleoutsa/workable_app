
$(document).ready(function () {
// live print text in from form-fields into letter based on ids

  $('input').focus(function() {
    inputField = document.activeElement;
    input_class = "." + inputField.id;
    text = inputField.value;


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
      //  text = "______________________";
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
      //  text = "______________________";
        $(input_class).css("color", "rgba(0,0,0,0.3)");
      }
      else {
        $(input_class).css("color", "#444");
      };
      //$(input_class).html(text);
    }

    //un-highlight
    $(this).focusout(function() {
      text = inputField.value;
      if ((text == "") && (no_address < 0)) {
        //return to placeholder value
        text = inputField.placeholder;
      //  text = "______________________";
        $(input_class).css("color", "rgba(0,0,0,0.3)");
        $(input_class).css("background-color", "rgba(51,182,203, 0.0)");
      }
      else {

        $(input_class).css("background-color", "rgba(51,182,203, 0.0)");
        $(input_class).css("color", "#444");
        $(input_class).css("text-decoration", "none");
      };

      $(input_class).html(text);

    });
  });



$("input[type='checkbox']").click(function() {
  checkbox_name = $(this).prop("name");
  checkbox_class = "." + checkbox_name;
  if ($(this).prop('checked')) {
    $(checkbox_class).removeClass('dont_include');
  }
  else {
    $(checkbox_class).addClass('dont_include');
  };
});


// TODO:
  // Focus on correct field when clicking on letter

  // scroll to first mention of field in letter on focus/typing



// sticky form on left side...
  var offset = $('#multi-step-form').offset();

  $(window).scroll(function() {
    var scroll_top = 150 + $(window).scrollTop();

    if (offset.top < scroll_top) {
      $('#multi-step-form').addClass('fixed');
    }
    else {
      $('#multi-step-form').removeClass('fixed');
    }
  });





// VARIABLES
  var current_frame, next_frame, previous_frame; //frame status for transitions
  var right, opacity, scale; //properties of each frame which will be animated
  var animating; //prevents glitchy use from double clicks...


  previous_frame = $("fieldset").eq(0);
  current_frame = $("fieldset").eq(0);
  next_frame = $("fieldset").eq(0);


// switch to correct fieldset when clicking on progress bar (no animation)
  $("#progressbar li").click(function() {


    current_id = $(this).index();
    last_id = current_id - 1;
    next_id = current_id + 1;

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

    //activate next step on progressbar using the index of next_fs
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
});