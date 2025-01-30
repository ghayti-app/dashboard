 

<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$apiKey = 'AIzaSyBw2yjQlova1YwxnvA733FZ9PK7sn99jlU';
$url = '';

if (isset($_GET['type']) && $_GET['type'] == 'autocomplete') {
    $url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
} elseif (isset($_GET['type']) && $_GET['type'] == 'details') {
    $url = 'https://maps.googleapis.com/maps/api/place/details/json';
}

$params = $_GET;
$params['key'] = $apiKey;
unset($params['type']);  

$query = http_build_query($params);
$fullUrl = "$url?$query";

$response = file_get_contents($fullUrl);
echo $response;
?>

