<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../../favicon.ico">

    <title>Microarray Data Analysis</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="../../assets/css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="jumbotron-narrow.css" rel="stylesheet">

    
  </head>

  <body>

    <div class="container">
      <div class="header clearfix">
        <nav>
          <ul class="nav nav-pills pull-right">
		
		<?php
			//$p_name schon einglesen, damit wir in der Navigation damit arbeiten koennen
			$p_name = isset($_GET['page']) ? $_GET['page'] : "home";
		?>
            <li role="presentation" <?php echo $p_name == 'home' ? 'class="active"' : ''; ?>><a href="index.php?page=home">Home</a></li>
            <li role="presentation" <?php echo (($p_name == 'txt_to_db') || ($p_name == 'display_txt')) ? 'class="active"' : ''; ?>><a href="index.php?page=txt_to_db">Upload TXT-File</a></li>
            <li role="presentation" <?php echo $p_name == 'cel_upload' ? 'class="active"' : ''; ?>><a href="index.php?page=cel_upload">Upload CEL-Files</a></li>
          </ul>
        </nav>
        <h3 class="text-muted">Microarray Data Analysis</h3>
      </div>

      <div class="jumbotron">
		<?php
			//Pfad zusammensetzen
			$page_path = "dynamic_sites/" . $p_name . ".php";
			
			//Pruefen, ob gueltiger Dateiname angegeben wurde
			if(file_exists($page_path)) {
				include($page_path);
			//Wenn nichts angelickt wurde => Startseite laden
			} elseif($p_name == "home") {
				include('dynamic_sites/home.php');
			}
			//Wenn falscher link eingegeben wurde
			//=> Fehler ausgeben
			else {
				echo "Seite nicht gefunden!";
			}	
		?>
       		
        
      </div>

      

      <footer class="footer">
        <p>&copy; 2016 Softwareprojekt</p>
      </footer>

    </div> <!-- /container -->


    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
  </body>
</html>
