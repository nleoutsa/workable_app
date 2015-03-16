

$(document).ready(function () {


// live print text in from form-fields into letter based on ids
  $('input').focus(function() {
    inputField = document.activeElement;
    inputField.onkeyup = function(){
      document.getElementById(inputField.id).innerHTML = inputField.value;
    }
  });






    //jQuery time
  var current_fs, next_fs, previous_fs; //fieldsets
  var right, opacity, scale; //fieldset properties which we will animate
  var animating; //flag to prevent quick multi-click glitches





    previous_fs = $("fieldset").eq(0);
    current_fs = $("fieldset").eq(0);
    next_fs = $("fieldset").eq(0);


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

      previous_fs = $("fieldset").eq(last_id);
      current_fs = $("fieldset").eq(current_id);
      next_fs = $("fieldset").eq(next_id);

      $("fieldset").hide();

      current_fs.show();

/*
    if (($(this).index() > current_fs.index())) {
      current_fs = $("fieldset").eq(last_id);
      next_fs = $("fieldset").eq(current_id);
      previous_fs.hide();
      next_fieldset();

    }
    else if (($(this).index() <= current_fs.index())) {
      previous_fs = $("fieldset").eq(current_id);
      current_fs = $("fieldset").eq(next_id);
      next_fs.hide();
      previous_fieldset();

    }
    else {}
*/
    document.getElementById("print-content").innerHTML = "prev: " + previous_fs.index() + "\ncurr: " + current_fs.index() + "\nnext: " + next_fs.index();

  });

  $(".next").click(function(){
    if(animating) return false;
    animating = true;

    current_fs = $(this).parent();
    next_fs = $(this).parent().next();

    next_fieldset();
    document.getElementById("print-content").innerHTML = "prev: " + previous_fs.index() + "\ncurr: " + current_fs.index() + "\nnext: " + next_fs.index();

  });

  $(".previous").click(function(){
    if(animating) return false;
    animating = true;

    current_fs = $(this).parent();
    previous_fs = $(this).parent().prev();

    previous_fieldset();
    document.getElementById("print-content").innerHTML = "prev: " + previous_fs.index() + "\ncurr: " + current_fs.index() + "\nnext: " + next_fs.index();

  });

  $(".submit").click(function(){
    return false;
  });


  function next_fieldset() {

    //activate next step on progressbar using the index of next_fs
    $("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");
    //show the next fieldset
    next_fs.show();
    //hide the current fieldset with style
    current_fs.animate({opacity: 0}, {
      step: function(now, mx) {
        //as the opacity of current_fs reduces to 0 - stored in "now"
        //1. scale current_fs down to 80%
        scale = 1 - (1 - now) * 0.2;
        //2. bring next_fs from the right(50%)
        right = (now * 50)+"%";
        //3. increase opacity of next_fs to 1 as it moves in
        opacity = 1 - now;
        current_fs.css({'transform': 'scale('+scale+')'});
        next_fs.css({'right': right, 'opacity': opacity});
      },
      duration: 200,
      complete: function(){
        current_fs.hide();
        animating = false;
      }
    });
  }

  function previous_fieldset() {

    //de-activate current step on progressbar
    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");
    //show the previous fieldset
    previous_fs.show();


    //hide the current fieldset with style
    current_fs.animate({opacity: 0}, {
      step: function(now, mx) {
        //as the opacity of current_fs reduces to 0 - stored in "now"
        //1. scale previous_fs from 80% to 100%
        scale = 0.8 + (1 - now) * 0.2;
        //2. take current_fs to the right(50%) - from 0%
        right = ((1-now) * 50)+"%";
        //3. increase opacity of previous_fs to 1 as it moves in
        opacity = 1 - now;
        current_fs.css({'right': right});
        previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
      },
      duration: 200,
      complete: function(){
        current_fs.hide();
        animating = false;
      }
    });
  }

});