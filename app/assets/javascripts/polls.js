$(function (){

    $(".butt").click(function (){
       var text = $("#v"+this.id).html();
        alert(text);
    });

	if ($('form#polls').length > 0) {
		$("input[type='submit']").click(function (evt){
			evt.preventDefault();
			var selections = $("input:checked").length;
			if (selections === 5){	$
				('form').submit();
			}
			else {
				alert('Attenzione. Devi scegliere esattamente 5 sessioni.')
			}		
		});
	}
})