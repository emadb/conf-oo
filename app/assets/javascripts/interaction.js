$(document).ready(function() {
	
	// homepage
	if ($('body.home').length>0) {
	
		var scroll_height = $('#boxScroll').height();
		var box_logo_height = $('#boxRoot header').height() + $('#boxRoot header').position().top;
		var box_cfp_height = $('#boxRoot section').height();
		
		function onScroll() {
		
			var window_height = $(window).height();
			var window_scroll = $(window).scrollTop();
		
			var portion = 1 - (scroll_height - window_height - window_scroll) / (scroll_height - window_height);
		
			// hide the tip text
			if(portion>0.5) {
				clearInterval(tip_timeout);
				$('#boxRoot aside span').fadeOut(200);
			}
		
			// set CFP box position
			if(portion>0.8) {
				$('#boxRoot section').css('marginTop','-'+((box_cfp_height + 50)*((portion - 0.8)/0.2))+'px');
			} else {
				$('#boxRoot section').css('marginTop','0px');
			}
			
			// set the arrow box dimension/position
			var vspace_available = window_height - box_logo_height - box_cfp_height - 50;
			
			var arrow_top = Math.max(box_logo_height,(box_logo_height + Math.floor(vspace_available/2)));

			$('#boxRoot aside').css('top',arrow_top+'px');
			
			// set the arrow image dimension/position [min=56px/max=256]
			var arrow_dim = Math.min(vspace_available,56 + (200*portion));
			$('#boxRoot aside img').width(arrow_dim+'px').height(arrow_dim+'px').css('margin-top','-'+(arrow_dim/2)+'px');
		
		}

		// show the "scroll down" tip after a few seconds
		$('#boxRoot aside span').hide();
		var tip_timeout = setTimeout(function() {
			$('#boxRoot aside span').fadeIn(3000);
		}, 3000); 

		// handle the scroll/resize events
		$(window).scroll(function (e) { onScroll(); });
		$(window).resize(function (e) { onScroll(); });
		
		// init appearence
		onScroll();
	
	}

});