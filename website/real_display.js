function applyfilter() {
		document.write("bullshit!");
		<?php 
			$conn = connect();
			$query = "SELECT * FROM `$tablename` LIMIT 100";
			print_results($tablename, $query);
		?>

}