$(function (){
	
	if ($('form#pools').length > 0) {
		$("input[type='submit']").click(function (evt){
			evt.preventDefault();
			var selections = $("input:checked").length
			if (selections === 5)
				$('form').submit();
			else
				alert("Devi scegliere 5 sessioni.");
		});
	}
})