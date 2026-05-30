<?php
require __DIR__ . '/config/database.php';

// use $link (NOT $conn)
if (isset($link) && $link) {
    mysqli_query($link, "SELECT 1");
}

http_response_code(200);
echo "OK";