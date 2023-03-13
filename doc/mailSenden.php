<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
require 'vendor/autoload.php';
 
$mail = new PHPMailer(TRUE);
 
$mail->setFrom('ruedi@nomadus.ch', 'Passwort');
$mail->addAddress('ruedi.moser1@gmail.com', 'Ruedi Moser');
$mail->Subject = 'Passwort reset';
$mail->Body = 'Diesen Code: xxx beim login für askMe eingeben';
 
/* SMTP parameters. */
$mail->isSMTP();
$mail->Host = 'server41.hostfactory.ch';
$mail->SMTPAuth = TRUE;
$mail->SMTPSecure = 'tls';
$mail->Username = 'ruedi@nomadus.ch';
$mail->Password = 'Hegen.00';
$mail->Port = 587;
 
//Senden der E-Mail
$mail->send();

?>