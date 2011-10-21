
$(function() {
	$('.delete').click(function(evt) {
		if (confirm('Are you sure?')) {
			var url = $(this).attr('href');
			var row = $(this).parent().parent();
					
			$.post(url, { _method: 'delete' }, function(result) {
				if (result.status === 'success')
					$(row).remove();
			});
		}
		return false;
	});

	$("form").validate();
})