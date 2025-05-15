<?php

// --- Data ---
$users = [
    [
        'id' => 1,
        'name' => 'John Doe',
        'email' => 'john.doe@example.com'
    ],
    [
        'id' => 2,
        'name' => 'Jane Smith',
        'email' => 'jane.smith@example.com'
    ],
    [
        'id' => 3,
        'name' => 'Peter Jones',
        'email' => 'peter.jones@example.com'
    ],
    [
        'id' => 4,
        'name' => 'Alice Brown',
        'email' => 'alice.brown@example.com'
    ],
    [
        'id' => 5,
        'name' => 'Robert Davis',
        'email' => 'robert.davis@example.com'
    ],
    [
        'id' => 6,
        'name' => 'mary Wilson', // Deliberately lowercase for sort testing
        'email' => 'mary.wilson@example.com'
    ],
];

// --- Sorting Logic ---
$allowedSortColumns = ['id', 'name', 'email'];
$sortBy = $_GET['sort_by'] ?? 'id'; // Default sort by 'id'
$sortOrder = $_GET['sort_order'] ?? 'asc'; // Default sort order 'asc'

// Validate sort_by parameter
if (!in_array($sortBy, $allowedSortColumns)) {
    $sortBy = 'id'; // Fallback to default if invalid column is provided
}

// Validate sort_order parameter
if (!in_array(strtolower($sortOrder), ['asc', 'desc'])) {
    $sortOrder = 'asc'; // Fallback to default
}

// Custom comparison function for usort
usort($users, function ($a, $b) use ($sortBy, $sortOrder) {
    $valA = $a[$sortBy];
    $valB = $b[$sortBy];

    // For case-insensitive string comparison (name, email)
    if (is_string($valA)) {
        $valA = strtolower($valA);
    }
    if (is_string($valB)) {
        $valB = strtolower($valB);
    }

    if ($valA == $valB) {
        return 0;
    }

    if ($sortOrder === 'asc') {
        return ($valA < $valB) ? -1 : 1;
    } else { // 'desc'
        return ($valA > $valB) ? -1 : 1;
    }
});

// --- Helper function for generating header links ---
function getSortLink($columnKey, $columnDisplay, $currentSortBy, $currentSortOrder) {
    $newSortOrder = 'asc'; // Default order for a new column
    $arrow = '';

    if ($columnKey === $currentSortBy) {
        // If this column is already being sorted, toggle the order
        $newSortOrder = ($currentSortOrder === 'asc') ? 'desc' : 'asc';
        // Add an arrow indicator using numeric HTML entities
        $arrow = ($currentSortOrder === 'asc') ? ' ▲' : ' ▼'; // Up (▲) / Down (▼) arrow
    }

    // Keep existing GET parameters if any (though not strictly needed for this simple example)
    $queryParams = $_GET;
    $queryParams['sort_by'] = $columnKey;
    $queryParams['sort_order'] = $newSortOrder;

    $url = '?' . http_build_query($queryParams);
    // Ensure $arrow is concatenated outside htmlspecialchars for $columnDisplay
    return '<a href="' . htmlspecialchars($url) . '">' . htmlspecialchars($columnDisplay) . $arrow . '</a>';
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            width: 80%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            cursor: pointer;
        }
        th a {
            text-decoration: none;
            color: black;
            display: block; /* Makes the whole header cell clickable */
        }
        th a:hover {
            text-decoration: underline;
        }
        /* .arrow class is not strictly needed if arrows are part of the link text now,
           but can be kept for potential future styling of the arrow itself if separated */
    </style>
</head>
<body>

    <h1>User List</h1>

    <table>
        <thead>
            <tr>
                <th><?php echo getSortLink('id', 'ID', $sortBy, $sortOrder); ?></th>
                <th><?php echo getSortLink('name', 'Name', $sortBy, $sortOrder); ?></th>
                <th><?php echo getSortLink('email', 'Email', $sortBy, $sortOrder); ?></th>
            </tr>
        </thead>
        <tbody>
            <?php if (empty($users)): ?>
                <tr>
                    <td colspan="3">No users found.</td>
                </tr>
            <?php else: ?>
                <?php foreach ($users as $user): ?>
                    <tr>
                        <td><?php echo htmlspecialchars($user['id']); ?></td>
                        <td><?php echo htmlspecialchars($user['name']); ?></td>
                        <td><?php echo htmlspecialchars($user['email']); ?></td>
                    </tr>
                <?php endforeach; ?>
            <?php endif; ?>
        </tbody>
    </table>

</body>
</html>