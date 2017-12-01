---------------------------------------------------------------------------------------------------------

-- Popular Sender All-time
SELECT source, count(source) AS freq 
FROM packet_data 
WHERE source != '' AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY source 
ORDER BY count(source) 
DESC LIMIT 10;

-- Popular Sender Recent 30 Min
SELECT source, count(source) AS freq 
FROM packet_data 
WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data)
AND source != '' 
AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY source 
ORDER BY count(source) 
DESC LIMIT 10;

---------------------------------------------------------------------------------------------------------

-- Popular Destination Port All-time
SELECT destination_port, count(destination_port) AS freq 
FROM packet_data 
WHERE destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca'
GROUP BY destination_port 
ORDER BY count(destination_port) 
DESC LIMIT 10;

-- Popular Destination Port Recent 30 Min
SELECT destination_port, count(destination_port) AS freq 
FROM packet_data 
WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data)
AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY destination_port 
ORDER BY count(destination_port) 
DESC LIMIT 10;

---------------------------------------------------------------------------------------------------------

-- Network Activity All-time
SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, COUNT(date) AS freq
FROM packet_data
WHERE (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY UNIX_TIMESTAMP(date) DIV (TIMESTAMPDIFF(SECOND,(SELECT MIN(date) FROM packet_data),(SELECT MAX(date) FROM packet_data))/50);

-- Network Activity Recent 30 Min
SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, COUNT(date) AS freq
FROM packet_data
WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data)
AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY UNIX_TIMESTAMP(date) DIV 120;

---------------------------------------------------------------------------------------------------------

-- Average Frame Length All-time
SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, AVG(size) AS avgLen
FROM packet_data
WHERE (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY UNIX_TIMESTAMP(date) DIV (TIMESTAMPDIFF(SECOND,(SELECT MIN(date) FROM packet_data),(SELECT MAX(date) FROM packet_data))/50);

-- Average Frame Length Recent 30 Min
SELECT DATE_FORMAT(`date`, '%m-%d %H:%i') AS timeChunk, AVG(size) AS avgLen
FROM packet_data
WHERE date >= (SELECT MAX(date) - INTERVAL 30 MINUTE FROM packet_data)
AND (destination LIKE 'vps105582.vps.ovh' OR destination LIKE 'vps105582.vps.ovh.ca')
GROUP BY UNIX_TIMESTAMP(date) DIV 120;

---------------------------------------------------------------------------------------------------------
