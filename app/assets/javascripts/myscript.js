
$(document).ready(function () {
// live print text in from form-fields into letter based on ids

  $('input').focus(function() {
    inputField = document.activeElement;
    inputField.onkeyup = function(){
      text = inputField.value;
      input_class = "." + inputField.id;
      $(input_class).html(text);


    }
  });

    $('#letter').click(function() {
      $('#letter').css('background-color','rgba(50,200,100,0.3)');
    });

// VARIABLES
  var current_frame, next_frame, previous_frame; // set up frames for each section of form
  var right, opacity, scale; //frame properties which we will animate
  var animating; //flag to prevent quick multi-click glitches





  previous_frame = $("fieldset").eq(0);
  current_frame = $("fieldset").eq(0);
  next_frame = $("fieldset").eq(0);


// switch to correct fieldset when clicking on progress bar
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

      current_frame.css({'right': '0%', 'opacity': opacity});
      current_frame.show();

  });

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
    return false; // do nothing with form for now... replace with email/download/pdf/copy... accordian menu later?
  });

  function next_fieldset() {

    //activate next step on progressbar using the index of next_fs
    $("#progressbar li").eq($("fieldset").index(next_frame)).addClass("showing");
    //show the next fieldset
    next_frame.show();

    current_frame.animate({opacity: 0}, {
      step: function(now) {
        right = (now * 50) + "%";
        opacity = 1 - now;
        next_frame.css({'right':right, 'opacity': opacity});
      },
      duration: 200,
      complete: function() {
        current_frame.hide();
        animating = false;
      }
    });
  }

  function previous_fieldset() {

    //de-activate current step on progressbar
    $("#progressbar li").eq($("fieldset").index(current_frame)).removeClass("showing");
    //show the previous fieldset
    previous_frame.show();

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
        animating = false; // make buttons clickable again
      }
    });
  }
});