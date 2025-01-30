<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$apiKey = 'AIzaSyBw2yjQlova1YwxnvA733FZ9PK7sn99jlU';
$url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

$params = $_GET;
$params['key'] = $apiKey;

$query = http_build_query($params);
$fullUrl = "$url?$query";

$response = file_get_contents($fullUrl);
echo $response;
?>
