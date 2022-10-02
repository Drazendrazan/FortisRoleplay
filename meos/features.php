<?php
   require "header.php";
   if (!$_SESSION['loggedin']) {
       Header("Location: login");
   }
?>
<div>
<h5 class="panel-container-title"><?php  echo $page['features']['title']; ?></h5>
</div>
<?php
   require 'footer.php'
?>