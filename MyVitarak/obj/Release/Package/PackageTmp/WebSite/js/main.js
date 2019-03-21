(function ($) {
	"use strict";
	
	/* Preloader JS */
	$(window).load(function() {
        $('.preloader').fadeOut('slow', function() {
            $(this).remove();
        });
    });
    
    /* ScrollToTop JS */
    $(window).scroll(function() {
    	var wScroll = $(this).scrollTop();
    	if (wScroll > 800) {
    		$('.scrollToTop').fadeIn('slow');
    	} else {
    		$('.scrollToTop').fadeOut('slow');
    	}
    });
    $('.scrollToTop').on('click', function(){
		$('html, body').animate({scrollTop : 0},800);
		return false;
	});

	/* Sticky Menu JS */
	$('#mainmenu').sticky({topSpacing:0});

	/* jQuery smooth scroll Js*/
	$('.navbar-nav li a').on('click', function(event) {
		   $('.navbar-nav li a').parent().removeClass('active');
        var $anchor = $($(this).attr('href')).offset().top - 60;
		   $(this).parent().addClass('active');
        $('body, html').animate({scrollTop : $anchor}, 800);
					 event.preventDefault();
        return false;
    });
    
    /* Hide collapse menu */
    $('#navMenu li a').on('click', function() {
            $('#navMenu').removeClass('in');
    });

	
	/* slider JS */
	$('#home-slide-carousel').carousel({
        interval:6000
    });
    //Function to animate slider captions 
	function doAnimations( elems ) {
		//Cache the animationend event in a variable
		var animEndEv = 'webkitAnimationEnd animationend';
		
		elems.each(function () {
			var $this = $(this),
				$animationType = $this.data('animation');
			$this.addClass($animationType).one(animEndEv, function () {
				$this.removeClass($animationType);
			});
		});
	}
	
	//Variables on page load 
	var $myCarousel = $('#home-slide-carousel'),
		$firstAnimatingElems = $myCarousel.find('.item:first').find("[data-animation ^= 'animated']");
		
	//Initialize carousel 
	$myCarousel.carousel();
	
	//Animate captions in first slide on page load 
	doAnimations($firstAnimatingElems);
	
	//Pause carousel  
	$myCarousel.carousel('pause');
	
	
	//Other slides to be animated on carousel slide event 
	$myCarousel.on('slide.bs.carousel', function (e) {
		var $animatingElems = $(e.relatedTarget).find("[data-animation ^= 'animated']");
		doAnimations($animatingElems);
	});  

	/* Counter Js */ 
    $('.counter').counterUp({
        delay: 10,
        time: 2000
    });

    /* Venobox Js */
    $('.vbox-portfolio, .vbox-video').venobox({
    	numeratio: true,
        infinigall: true
    }); 

   	/* Mixutup Js */
	$('#portfolio-items').mixItUp({	
		animation: {
			effects: 'rotateZ',
			duration: 1000
		}
	});

	/* testimonial-slider Js */
	$('#testimonial-slider').owlCarousel({
	    loop: true,
	    margin: 15,
	    smartSpeed: 2000,
	    nav: false,
	    items: 1,
	    addClassActive: true,
	    dots: true,
	    autoplay: true,
	    autoplayTimeout: 5000,
	    responsiveClass: true,
	    responsive: {
	        0: {
	            items: 1,
	            nav: false
	        },
	        600: {
	            items: 1,
	            nav: false
	        }
	    }
	});

	/* partner-slider Js */
	$('#partner-slider').owlCarousel({
	    loop: true,
	    margin: 30,
	    smartSpeed: 2000,
	    nav: false,
	    addClassActive: true,
	    dots: false,
	    autoplay: true,
	    autoplayTimeout: 3000,
	    responsiveClass: true,
	    responsive: {
	        0: {
	            items: 2,
	            nav: false
	        },
	        600: {
	            items: 3,
	            nav: false
	        },
	        1000: {
	        	items: 5,
	        	nav: false,
	        	loop: true
	        }
	    }
	});

})(jQuery);